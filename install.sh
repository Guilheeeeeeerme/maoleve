#!/usr/bin/env bash
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

  cd "$INSTALL_DIR"
  chmod +x bin/maoleve install.sh
  ./bin/maoleve tools
  ./bin/maoleve apply
  ./bin/maoleve claude || true

  mkdir -p "$HOME/.local/bin"
  ln -sfn "$INSTALL_DIR/bin/maoleve" "$HOME/.local/bin/maoleve"

  printf '%s\n' "Mão leve installed into $INSTALL_DIR"
  printf '%s\n' "Run: maoleve doctor"
}

main "$@"
