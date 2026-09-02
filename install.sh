#!/usr/bin/env bash
# DEPRECATED: Use tier install prompts from docs/prompts/ instead.
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

The CLI blast-install path is deprecated. Pick a token-economy tier and paste
the matching install prompt into your coding agent:

  low    → docs/prompts/install-low.md
  fast   → docs/prompts/install-fast.md
  medium → docs/prompts/install-medium.md  (default)
  high   → docs/prompts/install-high.md
  full   → docs/prompts/install-full.md

See docs/token-tiers.md for the comparison table and DEPRECATED.md for details.
EOF
}

main "$@"
