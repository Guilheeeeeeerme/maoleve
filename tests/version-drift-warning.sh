#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

FAKE_BIN="$TEST_ROOT/bin"
FAKE_HOME="$TEST_ROOT/home"
mkdir -p "$FAKE_BIN" "$FAKE_HOME"

for tool in headroom rtk codex opencode cursor-agent tokensave serena; do
  cat >"$FAKE_BIN/$tool" <<'EOF'
#!/usr/bin/env bash
if [[ "${1:-}" == "--version" ]]; then
  case "$(basename "$0")" in
    headroom) printf '%s\n' 'headroom 0.37.0' ;;
    serena) printf '%s\n' 'serena 1.7.0' ;;
    *) printf '%s\n' 'tool 1.0.0' ;;
  esac
else
  exit 0
fi
EOF
  chmod +x "$FAKE_BIN/$tool"
done

run_case() {
  local state_dir="$1"
  local expected_headroom="$2"
  local expected_serena="$3"
  local output_file="$4"
  mkdir -p "$state_dir"
  cat >"$state_dir/versions.env" <<EOF
MAOLEVE_HEADROOM_VERSION=$expected_headroom
MAOLEVE_RTK_VERSION=1.0.0
MAOLEVE_CODEX_VERSION=1.0.0
MAOLEVE_OPENCODE_VERSION=1.0.0
MAOLEVE_CURSOR_AGENT_VERSION=1.0.0
MAOLEVE_TOKENSAVE_VERSION=1.0.0
MAOLEVE_SERENA_VERSION=$expected_serena
MAOLEVE_CURSOR_BINARY=
MAOLEVE_CAVEMAN_PLUGIN_VERSION=
EOF
  HOME="$FAKE_HOME" MAOLEVE_STATE_DIR="$state_dir" PATH="$FAKE_BIN:$PATH" \
    "$ROOT_DIR/bin/maoleve" wrap cursor-agent >"$output_file" 2>&1
}

breaking_output="$TEST_ROOT/breaking.out"
run_case "$TEST_ROOT/breaking-state" 0.32.1 1.5.3 "$breaking_output"
grep -q 'warning: headroom 0.37.0 may contain breaking changes relative to supported 0.32.1' "$breaking_output"
! grep -q 'warning: serena' "$breaking_output"
! grep -q 'Refusing to run' "$breaking_output"

compatible_output="$TEST_ROOT/compatible.out"
run_case "$TEST_ROOT/compatible-state" 0.37.0 1.5.3 "$compatible_output"
! grep -q 'warning: headroom' "$compatible_output"

printf '%s\n' 'version drift warning tests passed'
