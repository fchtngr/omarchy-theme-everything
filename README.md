# omarchy-theme-everything

Extra Omarchy theme integrations for third-party apps.

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
- `integrations/k9s/README.md`

## Notes

- JetBrains may need a restart after sync
