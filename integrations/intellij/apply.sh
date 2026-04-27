#!/usr/bin/env bash
set -euo pipefail

INTEGRATION_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
python3 "$INTEGRATION_DIR/generate-theme.py"
