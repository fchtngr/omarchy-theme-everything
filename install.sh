#!/usr/bin/env python3
import os
from pathlib import Path
import shutil
import stat
import subprocess
import sys

try:
    import tomllib
except ModuleNotFoundError:
    print('Python 3.11+ is required (missing tomllib)', file=sys.stderr)
    sys.exit(1)

ROOT_DIR = Path(__file__).resolve().parent
HOOK_DIR = Path.home() / '.config/omarchy/hooks'
HOOK_PATH = HOOK_DIR / 'theme-set'
THEMED_DIR = Path.home() / '.config/omarchy/themed'
START_MARKER = '# >>> omarchy-theme-everything >>>'
END_MARKER = '# <<< omarchy-theme-everything <<<'
INTEGRATIONS_DIR = ROOT_DIR / 'integrations'


def ensure_executable(path: Path) -> None:
    mode = path.stat().st_mode
    path.chmod(mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def load_metadata(integration_dir: Path) -> dict | None:
    metadata_path = integration_dir / 'integration.toml'
    if not metadata_path.exists():
        return None
    with metadata_path.open('rb') as f:
        return tomllib.load(f)


def install_templates() -> None:
    THEMED_DIR.mkdir(parents=True, exist_ok=True)
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
            target_path.write_text(template_path.read_text(encoding='utf-8'), encoding='utf-8')
            print(f'Installed template: {target_path}')


def install_hook() -> None:
    HOOK_DIR.mkdir(parents=True, exist_ok=True)
    block = f'{START_MARKER}\n"{ROOT_DIR / "bin/omarchy-theme-sync"}" "$@"\n{END_MARKER}'

    if HOOK_PATH.exists():
        content = HOOK_PATH.read_text(encoding='utf-8')
    else:
        content = '#!/usr/bin/env bash\nset -euo pipefail\n'

    if START_MARKER in content and END_MARKER in content:
        before, rest = content.split(START_MARKER, 1)
        _, after = rest.split(END_MARKER, 1)
        content = before.rstrip() + '\n\n' + block + after
    else:
        if not content.endswith('\n'):
            content += '\n'
        if not content.startswith('#!/usr/bin/env bash\n'):
            content = '#!/usr/bin/env bash\nset -euo pipefail\n' + content
        content = content.rstrip() + '\n\n' + block + '\n'

    HOOK_PATH.write_text(content, encoding='utf-8')
    ensure_executable(HOOK_PATH)
    print(f'Installed hook: {HOOK_PATH}')


def ensure_scripts_executable() -> None:
    ensure_executable(ROOT_DIR / 'install.sh')
    ensure_executable(ROOT_DIR / 'bin/omarchy-theme-sync')
    for integration_dir in sorted(INTEGRATIONS_DIR.iterdir()):
        if not integration_dir.is_dir():
            continue
        metadata = load_metadata(integration_dir)
        if metadata is None:
            continue
        apply_rel = metadata.get('apply', 'apply.sh')
        apply_path = integration_dir / apply_rel
        if apply_path.exists():
            ensure_executable(apply_path)
        for child in integration_dir.iterdir():
            if child.is_file() and child.name.startswith('omarchy-'):
                ensure_executable(child)


def main() -> int:
    install_templates()
    install_hook()
    ensure_scripts_executable()
    omarchy_theme_refresh = shutil.which('omarchy-theme-refresh')
    if omarchy_theme_refresh:
        print('Refreshing current Omarchy theme...')
        subprocess.run([omarchy_theme_refresh], check=True)
    else:
        print('omarchy-theme-refresh not found; running direct sync fallback.')
        subprocess.run([str(ROOT_DIR / 'bin/omarchy-theme-sync')], check=True)
    print('Done. Future omarchy-theme-set runs will sync third-party themes too.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
