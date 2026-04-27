# k9s integration

![Nord](screen1.png)
![Osaka Jade](screen2.png)

Files in this integration:
- `integration.toml`
- `apply.sh`
- `templates/k9s.yaml.tpl`

Templates are installed by convention from this integration's `templates/` directory.

## Detection

The framework loads `integration.toml` and only runs this integration when its configured `check_path` exists.

## What it does

This integration ships:
- `templates/k9s.yaml.tpl`

That template gets installed to:
- `~/.config/omarchy/themed/k9s.yaml.tpl`

Omarchy then generates:
- `~/.config/omarchy/current/theme/k9s.yaml`

`apply.sh` copies that generated file to:
- `~/.config/k9s/skins/omarchy.yaml`

## Manual run

```bash
./integrations/k9s/apply.sh
```

## Notes

- `apply.sh` logs a skip message when Omarchy has not generated `k9s.yaml` yet.
