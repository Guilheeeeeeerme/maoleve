#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${MAOLEVE_REPO_URL:-https://github.com/Guilheeeeeeerme/maoleve.git}"
INSTALL_DIR="${MAOLEVE_INSTALL_DIR:-$HOME/.local/share/maoleve}"

have() {
  command -v "$1" >/dev/null 2>&1
}

print_check() {
  local name="$1"
  if have "$name"; then
    printf 'ok   %s -> %s\n' "$name" "$(command -v "$name" 2>/dev/null || true)"
  else
    printf 'miss %s\n' "$name"
  fi
}

show_prereqs() {
  printf '%s\n' "Maoleve install prerequisites"
  printf '%s\n' "-----------------------------"
  for tool in bash git curl mkdir ln cp chmod sed awk; do
    print_check "$tool"
  done
  printf '\n%s\n' "Agent tools"
  printf '%s\n' "-----------"
  for tool in headroom rtk codex opencode cursor-agent cursor claude serena caveman gh; do
    print_check "$tool"
  done
}

source_dir() {
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    git rev-parse --show-toplevel
  else
    printf '%s\n' "$INSTALL_DIR"
  fi
}

install_from_source() {
  local src="$1"
  rm -rf "$INSTALL_DIR"
  mkdir -p "$INSTALL_DIR"
  cp -a "$src"/. "$INSTALL_DIR"/
  chmod +x "$INSTALL_DIR/install.sh" "$INSTALL_DIR/bin/maoleve"
  "$INSTALL_DIR/bin/maoleve" install
}

main() {
  show_prereqs

  if [[ -d "$INSTALL_DIR/.git" || -f "$INSTALL_DIR/AGENTS.md" ]]; then
    rm -rf "$INSTALL_DIR"
  fi

  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    install_from_source "$(source_dir)"
    printf '\n%s\n' "Installed from the local checkout."
    exit 0
  fi

  git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
  chmod +x "$INSTALL_DIR/install.sh" "$INSTALL_DIR/bin/maoleve"
  "$INSTALL_DIR/bin/maoleve" install
  printf '\n%s\n' "Installed from $REPO_URL"
}

main "$@"

