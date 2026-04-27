# IntelliJ / JetBrains integration

![Osake Jade](screen1.png)
![Nord](screen2.png)

Files in this integration:
- `integration.toml`
- `apply.sh`
- `omarchy-intellij-sync`

This integration has no `templates/` directory because it generates and installs its theme directly.

## Detection

The framework loads `integration.toml` and only runs this integration when its configured `check_path` exists.

## What it does

`omarchy-intellij-sync`:
- reads Omarchy `colors.toml`
- generates a local JetBrains theme plugin
- installs it into JetBrains data directories   
- selects the generated theme and editor scheme

Generated plugin id:
- `omarchy.intellij.theme`

Generated plugin layout:
- `~/.local/share/JetBrains/<IDE>/omarchy-intellij-theme/lib/omarchy-intellij-theme.jar`

The jar contains:
- `META-INF/plugin.xml`
- `theme/omarchy.theme.json`
- `theme/omarchy.xml`

Updated settings files:
- `~/.config/JetBrains/<IDE>/options/laf.xml`
- `~/.config/JetBrains/<IDE>/options/colors.scheme.xml`

## Manual run

```bash
./integrations/intellij/omarchy-intellij-sync
```

Useful options:

```bash
./integrations/intellij/omarchy-intellij-sync --help
```

## Notes

- Restart JetBrains IDEs after a sync for the most reliable theme reload.
