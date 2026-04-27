#!/usr/bin/env python3
import os
from pathlib import Path
import shutil
import stat
import sys

try:
    import tomllib
except ModuleNotFoundError:
    print('Python 3.11+ is required (missing tomllib)', file=sys.stderr)
    sys.exit(1)

ROOT_DIR = Path(__file__).resolve().parent
HOOK_PATH = Path.home() / '.config/omarchy/hooks/theme-set'
THEMED_DIR = Path.home() / '.config/omarchy/themed'
START_MARKER = '# >>> omarchy-theme-everything >>>'
END_MARKER = '# <<< omarchy-theme-everything <<<'
INTEGRATIONS_DIR = ROOT_DIR / 'integrations'


def load_metadata(integration_dir: Path) -> dict | None:
    metadata_path = integration_dir / 'integration.toml'
    if not metadata_path.exists():
        return None
    with metadata_path.open('rb') as f:
        return tomllib.load(f)


def remove_hook_block() -> None:
    if not HOOK_PATH.exists():
        return
    content = HOOK_PATH.read_text(encoding='utf-8')
    if START_MARKER in content and END_MARKER in content:
        before, rest = content.split(START_MARKER, 1)
        _, after = rest.split(END_MARKER, 1)
        new_content = (before.rstrip() + '\n' + after.lstrip('\n')).rstrip() + '\n'
        if new_content.strip() == '#!/usr/bin/env bash\nset -euo pipefail'.strip() or new_content.strip() == '#!/usr/bin/env bash'.strip():
            HOOK_PATH.unlink()
            print(f'Removed hook: {HOOK_PATH}')
            return
        HOOK_PATH.write_text(new_content, encoding='utf-8')
        print(f'Updated hook: {HOOK_PATH}')


def remove_templates() -> None:
    if not THEMED_DIR.exists():
        return
    for integration_dir in sorted(INTEGRATIONS_DIR.iterdir()):
        if not integration_dir.is_dir():
            continue
        metadata = load_metadata(integration_dir)
        if metadata is None:
            continue
        templates_dir = integration_dir / 'templates'
        if not templates_dir.is_dir():
            continue
        for template_path in sorted(p for p in templates_dir.iterdir() if p.is_file()):
            target_path = THEMED_DIR / template_path.name
            if target_path.exists():
                target_path.unlink()
                print(f'Removed template: {target_path}')


def remove_intellij_artifacts() -> None:
    jetbrains_config_root = Path.home() / '.config/JetBrains'
    jetbrains_data_root = Path.home() / '.local/share/JetBrains'
    google_config_root = Path.home() / '.config/Google'
    google_data_root = Path.home() / '.local/share/Google'

    config_roots = [jetbrains_config_root, google_config_root]
    data_roots = [jetbrains_data_root, google_data_root]

    for root in config_roots:
        if not root.exists():
            continue
        for ide_dir in sorted(p for p in root.iterdir() if p.is_dir()):
            for rel in [
                Path('options/laf.xml'),
                Path('options/colors.scheme.xml'),
            ]:
                path = ide_dir / rel
                if not path.exists():
                    continue
                content = path.read_text(encoding='utf-8')
                if 'omarchy.intellij.theme' in content or 'global_color_scheme name="Omarchy"' in content:
                    print(f'Leaving {path} in place; reset theme/scheme manually in the IDE if desired.')

    for root in data_roots:
        if not root.exists():
            continue
        for ide_dir in sorted(p for p in root.iterdir() if p.is_dir()):
            plugin_dir = ide_dir / 'omarchy-intellij-theme'
            if plugin_dir.exists():
                shutil.rmtree(plugin_dir)
                print(f'Removed IntelliJ plugin: {plugin_dir}')


def ensure_executable(path: Path) -> None:
    mode = path.stat().st_mode
    path.chmod(mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def main() -> int:
    ensure_executable(ROOT_DIR / 'uninstall.sh')
    remove_hook_block()
    remove_templates()
    remove_intellij_artifacts()
    print('Uninstall complete.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
