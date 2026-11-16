#!/bin/bash
# Checks that scripts/formula turns a release's SHA256SUMS into the expected
# formula, and that a binary with no macOS or Linux archive is refused.
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
actual=$(scripts/formula demo crumbkit/demo-repo 1.2.3 "Does a demo thing" tests/fixtures/SHA256SUMS)
if ! diff -u tests/fixtures/demo.rb <(printf '%s\n' "$actual"); then
  echo "FAIL: generated formula differs from tests/fixtures/demo.rb" >&2
  fail=1
fi

if scripts/formula other crumbkit/demo-repo 1.2.3 "x" tests/fixtures/SHA256SUMS >/dev/null 2>&1; then
  echo "FAIL: a binary with no archives produced a formula" >&2
  fail=1
fi

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
