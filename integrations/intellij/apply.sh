#!/usr/bin/env bash
set -euo pipefail

INTEGRATION_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
"$INTEGRATION_DIR/omarchy-intellij-sync"
