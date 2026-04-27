#!/usr/bin/env bash
set -euo pipefail

HOOK_PATH="$HOME/.config/omarchy/hooks/theme-set"
THEMED_DIR="$HOME/.config/omarchy/themed"
START_MARKER="# >>> omarchy-theme-everything >>>"
END_MARKER="# <<< omarchy-theme-everything <<<"

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if [[ -f "$HOOK_PATH" ]] && grep -Fq "$START_MARKER" "$HOOK_PATH" && grep -Fq "$END_MARKER" "$HOOK_PATH"; then
  result=$("$ROOT_DIR/bin/manage-hook-block" remove "$HOOK_PATH" "$START_MARKER" "$END_MARKER")
  case "$result" in
    removed-file) echo "Removed hook: $HOOK_PATH" ;;
    updated) echo "Updated hook: $HOOK_PATH" ;;
  esac
fi

rm -f "$THEMED_DIR/k9s.yaml.tpl"
rm -rf "$HOME/.config/omarchy-theme-everything/intellij"
find "$HOME/.local/share/JetBrains" "$HOME/.local/share/Google" -mindepth 2 -maxdepth 2 -type f -name 'intellij-omarchy.zip' -delete 2>/dev/null || true
find "$HOME/.local/share/JetBrains" "$HOME/.local/share/Google" \( -path '*/plugins/intellij-omarchy' -o -path '*/intellij-omarchy' \) -type d -exec rm -rf {} + 2>/dev/null || true

echo "Removed installed templates and IntelliJ plugin files."
echo "If IntelliJ is still set to Omarchy, switch theme/scheme manually in the IDE."
