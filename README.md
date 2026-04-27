# omarchy-theme-everything

Extra Omarchy theme integrations for third-party apps.

Motivation: make Omarchy themes work in non-standard applications too.
[Related discussion](https://github.com/basecamp/omarchy/pull/5416#issuecomment-4322495081)

![Theme all the things](theme-all-the-things.jpg)

Current integrations:
- IntelliJ / JetBrains
- k9s

## Install

```bash
./install.sh
```

This:
- registers an Omarchy `theme-set` hook
- installs any integration templates into `~/.config/omarchy/themed/`
- attempts to install the IntelliJ plugin
- refreshes the current Omarchy theme

## Uninstall

```bash
./uninstall.sh
```

This removes the managed hook, installed templates, and generated IntelliJ plugin files.

## Integrations

Each integration lives in its own self-contained folder under `integrations/`.

See:
- `integrations/intellij/README.md`
- `intellij-plugin/README.md`
- `integrations/k9s/README.md`

## Notes

- JetBrains may need a restart after sync
- the IntelliJ plugin scaffold lives in `intellij-plugin/`; the integration can generate theme data even without the plugin installed
- the in-repo IntelliJ plugin is intended to be published as a proper IntelliJ plugin in the future
