#!/usr/bin/env bash
set -euo pipefail

K9S_CONFIG_DIR="${K9S_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/k9s}"
K9S_SKINS_DIR="$K9S_CONFIG_DIR/skins"
OMARCHY_K9S_THEME="$HOME/.config/omarchy/current/theme/k9s.yaml"
TARGET_THEME="$K9S_SKINS_DIR/omarchy.yaml"

if [[ ! -f "$OMARCHY_K9S_THEME" ]]; then
  echo "k9s: skip, Omarchy theme file not found: $OMARCHY_K9S_THEME"
  exit 0
fi

mkdir -p "$K9S_SKINS_DIR"
cp "$OMARCHY_K9S_THEME" "$TARGET_THEME"

echo "k9s: synced $TARGET_THEME"
