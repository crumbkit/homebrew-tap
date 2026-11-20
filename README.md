# crumbkit Homebrew tap

Homebrew formulas for the crumbkit command-line apps. Each formula installs
the prebuilt binary that the app's latest GitHub release attaches, checked
against the release's SHA256SUMS.

```bash
brew tap crumbkit/tap
```

```bash
brew install deadband mxv starmap flightdeck jumpgate
```

| Formula | Repository |
| --- | --- |
| `deadband` | [crumbkit/deadband](https://github.com/crumbkit/deadband) |
| `flightdeck` | [crumbkit/flightdeck](https://github.com/crumbkit/flightdeck) |
| `jumpgate` | [crumbkit/jumpgate](https://github.com/crumbkit/jumpgate) |
| `mxv` | [crumbkit/multiverse](https://github.com/crumbkit/multiverse) |
| `starmap` | [crumbkit/starmap](https://github.com/crumbkit/starmap) |

Binaries are built for macOS on Apple silicon and for Linux on arm64 and
x86_64.

Run deadband's daemon as a login service with:

```bash
brew services start deadband
```

Apps that ship agent skills install them with `<app> skills install` after
each upgrade.

## How formulas stay current

`Formula/` is generated. The Update formulas workflow runs `scripts/generate`
every hour and commits any change. The script writes a formula for each
binary of every public, non-archived crumbkit repository whose latest release
attaches `<bin>-<version>-<target>.tar.gz` archives and a `SHA256SUMS` file,
so a new app gets a formula the first time it publishes such a release.

`scripts/formula` writes one formula; `scripts/extras/<bin>.rb` adds blocks
such as `service`. `tests/run.sh` checks the generator.

## License

MIT OR Apache-2.0, like the apps.
