# IntelliJ Omarchy plugin

In-repo IntelliJ plugin for the Omarchy IntelliJ integration.

Planned future: publish it as a regular IntelliJ plugin.

## Build

```bash
./gradlew buildPlugin
```

Plugin zip:

- `build/distributions/`

## Install

```bash
./bin/install-plugin
```

## Runtime files

The plugin reads:

- `~/.config/omarchy-theme-everything/intellij/theme.json`
- `~/.config/omarchy-theme-everything/intellij/refresh.token`
