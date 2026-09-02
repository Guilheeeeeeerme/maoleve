#!/usr/bin/env bash
# Install RTK with branch fallback (main often 404; master is current upstream).
set -euo pipefail

for branch in master main; do
  url="https://raw.githubusercontent.com/rtk-ai/rtk/${branch}/install.sh"
  tmp="$(mktemp)"
  if curl -fsSL "$url" -o "$tmp"; then
    sh "$tmp"
    rm -f "$tmp"
    exit 0
  fi
  rm -f "$tmp"
done

echo "RTK install failed: could not fetch install.sh from master or main" >&2
exit 1
