#!/usr/bin/env bash
# Smoke test: RTK install.sh must be reachable on master (main may 404).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

test -x "$ROOT/scripts/install-rtk.sh"

master_code="$(curl -fsSL -o /dev/null -w '%{http_code}' \
  https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh || true)"
if [[ "$master_code" != "200" ]]; then
  echo "FAIL: RTK master install.sh HTTP $master_code (expected 200)" >&2
  exit 1
fi

echo "ok: RTK master install.sh reachable; scripts/install-rtk.sh present"
