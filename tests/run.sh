#!/bin/bash
# Checks that scripts/formula and scripts/cask turn a release's SHA256SUMS
# into the expected formula or cask, and that each refuses a release that
# lacks what it looks for.
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0

# expect <fixture> <command...>: the command's output must equal the fixture.
expect() {
  local fixture=$1 actual
  shift
  if ! actual=$("$@"); then
    echo "FAIL: $* exited non-zero" >&2
    fail=1
    return
  fi
  if ! diff -u "$fixture" <(printf '%s\n' "$actual"); then
    echo "FAIL: output of $* differs from $fixture" >&2
    fail=1
  fi
}

# refuse <reason> <command...>: the command must exit non-zero.
refuse() {
  local reason=$1
  shift
  if "$@" >/dev/null 2>&1; then
    echo "FAIL: $reason" >&2
    fail=1
  fi
}

# A release with no macOS Intel archive gets no on_intel block under on_macos.
expect tests/fixtures/demo.rb \
  scripts/formula demo crumbkit/demo-repo 1.2.3 "Does a demo thing" tests/fixtures/SHA256SUMS

# A release with all four targets gets an on_intel block under on_macos, and
# scripts/extras/board.desc stands in for crumbkit/board's empty description.
expect tests/fixtures/board.rb \
  scripts/formula board crumbkit/board 0.1.1 "" tests/fixtures/board.SHA256SUMS

refuse "a binary with no archives produced a formula" \
  scripts/formula other crumbkit/demo-repo 1.2.3 "x" tests/fixtures/SHA256SUMS
refuse "a formula was written with an empty description" \
  scripts/formula demo crumbkit/demo-repo 1.2.3 "" tests/fixtures/SHA256SUMS

# A notarised dmg becomes a cask, with scripts/extras/board-app.rb's caveat.
expect tests/fixtures/board-app.rb \
  scripts/cask board-app crumbkit/board-app 0.1.1 "Board.app: the macOS app that ships Board" \
  tests/fixtures/board-app.SHA256SUMS

# bin/dmg names an image Board-<version>-<release id>.dmg, where the release
# id is board-<12 hex>.app-<12 hex>. The board-app release renames it to
# Board-<version>.dmg, which the fixture above uses; both shapes give a cask.
check_url() {
  local got
  got=$(scripts/cask board-app crumbkit/board-app 0.1.1 "x" "$1" | sed -n 's/^  url "\(.*\)"$/\1/p') || true
  if [ "$got" != "$2" ]; then
    echo "FAIL: $1 gave cask url \"$got\", expected \"$2\"" >&2
    fail=1
  fi
}
check_url tests/fixtures/board-app-id.SHA256SUMS \
  'https://github.com/crumbkit/board-app/releases/download/v#{version}/Board-#{version}-board-0123456789ab.app-0123456789ab.dmg'

# The same name with -unnotarised before .dmg is refused.
refuse "an -unnotarised dmg produced a cask" \
  scripts/cask board-app crumbkit/board-app 0.1.1 "x" tests/fixtures/unnotarised.SHA256SUMS
refuse "a release with no dmg produced a cask" \
  scripts/cask demo crumbkit/demo-repo 1.2.3 "x" tests/fixtures/SHA256SUMS

check_desc() {
  local got
  got=$(scripts/formula demo crumbkit/demo-repo 1.2.3 "$1" tests/fixtures/SHA256SUMS | sed -n 's/^  desc "\(.*\)"$/\1/p')
  if [ "$got" != "$2" ]; then
    echo "FAIL: description \"$1\" became \"$got\", expected \"$2\"" >&2
    fail=1
  fi
}
check_desc "A local web page." "Local web page"
check_desc "Admits heavy jobs by live CPU and memory headroom, so a busy machine stays usable" \
  "Admits heavy jobs by live CPU and memory headroom"

[ "$fail" = 0 ] && echo "ok"
exit "$fail"
