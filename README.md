# crumbkit Homebrew tap

Homebrew formulas for the crumbkit command-line apps. Each formula installs
the prebuilt binary that the app's latest GitHub release attaches, checked
against the release's SHA256SUMS.

```bash
brew tap crumbkit/tap
```

```bash
brew install board deadband mxv starmap flightdeck jumpgate
```

Homebrew's own formulas have no `board`, so outside the tap write the full
name: `brew install crumbkit/tap/board`.

| Formula | Repository |
| --- | --- |
| `board` | [crumbkit/board](https://github.com/crumbkit/board) |
| `deadband` | [crumbkit/deadband](https://github.com/crumbkit/deadband) |
| `flightdeck` | [crumbkit/flightdeck](https://github.com/crumbkit/flightdeck) |
| `jumpgate` | [crumbkit/jumpgate](https://github.com/crumbkit/jumpgate) |
| `mxv` | [crumbkit/multiverse](https://github.com/crumbkit/multiverse) |
| `starmap` | [crumbkit/starmap](https://github.com/crumbkit/starmap) |

Binaries are built for macOS on Apple silicon and for Linux on arm64 and
x86_64. `board` is also built for macOS on Intel.

Run deadband's daemon as a login service with:

```bash
brew services start deadband
```

Apps that ship agent skills install them with `<app> skills install` after
each upgrade.

## How formulas and casks stay current

`Formula/` and `Casks/` are generated. The Update formulas workflow runs
`scripts/generate` every hour and commits any change. The script writes a
formula for each binary of every public, non-archived crumbkit repository
whose latest release attaches `<bin>-<version>-<target>.tar.gz` archives and
a `SHA256SUMS` file, so a new app gets a formula the first time it publishes
such a release. When a latest release's `SHA256SUMS` lists a notarised
`<Name>-<version>.dmg`, the script writes a cask named after the repository,
which installs `<Name>.app` on Apple silicon Macs with macOS 14 or later. A
dmg whose name ends in `-unnotarised.dmg` gets no cask. No crumbkit release
publishes a notarised dmg yet, so the tap has no casks.

`scripts/formula` writes one formula and `scripts/cask` one cask.
`scripts/extras/<name>.rb` adds blocks such as `service` or `caveats`, and
`scripts/extras/<name>.desc` replaces a repository's description when it is
empty or does not suit Homebrew. `tests/run.sh` checks the generator.

## License

MIT OR Apache-2.0, like the apps.
