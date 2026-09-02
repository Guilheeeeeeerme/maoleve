#!/usr/bin/env bash
# DEPRECATED: Use docs/prompts/install.md + activate-<tier>.md instead.
# See DEPRECATED.md — this script no longer blast-installs tools.
set -euo pipefail

REPO_URL="${MAOLEVE_REPO_URL:-https://github.com/Guilheeeeeeerme/maoleve.git}"
INSTALL_DIR="${MAOLEVE_INSTALL_DIR:-$HOME/.local/share/maoleve}"

main() {
  if [[ -d "$INSTALL_DIR/.git" ]]; then
    git -C "$INSTALL_DIR" pull --ff-only
  else
    rm -rf "$INSTALL_DIR"
    git clone "$REPO_URL" "$INSTALL_DIR"
  fi

  cat <<EOF
Mão leve checkout: $INSTALL_DIR

The CLI blast-install path is deprecated. One-time setup, verify, and per-chat tiers:

  install  → docs/prompts/install.md  (once per machine)
  verify   → docs/prompts/verify.md   (new chat after install)
  low      → docs/prompts/activate-low.md   or /maoleve-low
  fast     → docs/prompts/activate-fast.md  or /maoleve-fast
  medium   → docs/prompts/activate-medium.md (default) or /maoleve-medium
  high     → docs/prompts/activate-high.md  or /maoleve-high
  full     → docs/prompts/activate-full.md  or /maoleve-full

See docs/token-tiers.md for the comparison table and DEPRECATED.md for details.
EOF
}

main "$@"
