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
    headroom) printf 'headroom %s\n' "$FAKE_HEADROOM_VERSION" ;;
    serena) printf 'serena %s\n' "$FAKE_SERENA_VERSION" ;;
    cursor-agent) printf '%s\n' "$FAKE_CURSOR_AGENT_VERSION" ;;
    *) printf '%s\n' 'tool 1.0.0' ;;
  esac
else
  printf '%s\n' "$*" >> "${FAKE_ARGS_LOG:-/dev/null}"
  exit 0
fi
EOF
  chmod +x "$FAKE_BIN/$tool"
done

run_case() {
  local state_dir="$1"
  local expected_headroom="$2"
  local actual_headroom="$3"
  local expected_serena="$4"
  local actual_serena="$5"
  local output_file="$6"
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
    FAKE_HEADROOM_VERSION="$actual_headroom" FAKE_SERENA_VERSION="$actual_serena" \
    "$ROOT_DIR/bin/maoleve" wrap cursor-agent >"$output_file" 2>&1
}

breaking_output="$TEST_ROOT/breaking.out"
run_case "$TEST_ROOT/breaking-state" 0.37.0 0.32.1 1.5.3 1.7.0 "$breaking_output"
grep -q 'warning: headroom 0.32.1 is older than supported 0.37.0' "$breaking_output"
! grep -q 'warning: serena' "$breaking_output"
! grep -q 'Refusing to run' "$breaking_output"

compatible_output="$TEST_ROOT/compatible.out"
run_case "$TEST_ROOT/compatible-state" 0.32.1 0.37.0 1.5.3 1.7.0 "$compatible_output"
! grep -q 'warning: headroom' "$compatible_output"

repair_state="$TEST_ROOT/repair-state"
mkdir -p "$FAKE_HOME/.codex" "$repair_state"
cat >"$repair_state/versions.env" <<'EOF'
MAOLEVE_HEADROOM_VERSION=0.32.1
MAOLEVE_RTK_VERSION=1.0.0
MAOLEVE_CODEX_VERSION=1.0.0
MAOLEVE_OPENCODE_VERSION=1.0.0
MAOLEVE_CURSOR_AGENT_VERSION=1.0.0
MAOLEVE_TOKENSAVE_VERSION=1.0.0
MAOLEVE_SERENA_VERSION=1.7.0
MAOLEVE_CURSOR_BINARY=
MAOLEVE_CAVEMAN_PLUGIN_VERSION=
EOF
cat >"$FAKE_HOME/.codex/config.toml" <<'EOF'
[mcp_servers.headroom]
command = "/home/ferre/.local/bin/headroom"
args = [
    "mcp",
    "serve",
]

[mcp_servers.tokensave]
command = "/home/ferre/.local/bin/tokensave"
EOF
HOME="$FAKE_HOME" MAOLEVE_STATE_DIR="$repair_state" PATH="$FAKE_BIN:$PATH" \
  FAKE_HEADROOM_VERSION=0.32.1 FAKE_SERENA_VERSION=1.7.0 \
  FAKE_ARGS_LOG="$TEST_ROOT/codex-args.out" \
  "$ROOT_DIR/bin/maoleve" wrap codex >/dev/null 2>&1
! grep -q '\[mcp_servers\.headroom\]' "$FAKE_HOME/.codex/config.toml"
grep -q '\[mcp_servers\.tokensave\]' "$FAKE_HOME/.codex/config.toml"
grep -q -- '--no-mcp' "$TEST_ROOT/codex-args.out"

date_state="$TEST_ROOT/date-state"
mkdir -p "$date_state"
cat >"$date_state/versions.env" <<'EOF'
MAOLEVE_HEADROOM_VERSION=0.32.1
MAOLEVE_RTK_VERSION=1.0.0
MAOLEVE_CODEX_VERSION=1.0.0
MAOLEVE_OPENCODE_VERSION=1.0.0
MAOLEVE_CURSOR_AGENT_VERSION=2026.08.31
MAOLEVE_TOKENSAVE_VERSION=1.0.0
MAOLEVE_SERENA_VERSION=1.7.0
MAOLEVE_CURSOR_BINARY=
MAOLEVE_CAVEMAN_PLUGIN_VERSION=
EOF
HOME="$FAKE_HOME" MAOLEVE_STATE_DIR="$date_state" PATH="$FAKE_BIN:$PATH" \
  FAKE_HEADROOM_VERSION=0.32.1 FAKE_SERENA_VERSION=1.7.0 \
  FAKE_CURSOR_AGENT_VERSION=2026.08.30 \
  "$ROOT_DIR/bin/maoleve" wrap cursor-agent >"$TEST_ROOT/date.out" 2>&1
grep -q 'warning: cursor-agent 2026.08.30 is older than supported 2026.08.31' "$TEST_ROOT/date.out"

generated_home="$TEST_ROOT/generated-home"
generated_config="$TEST_ROOT/generated-config"
HOME="$generated_home" MAOLEVE_CONFIG_DIR="$generated_config" \
  MAOLEVE_STATE_DIR="$TEST_ROOT/generated-state" \
  PATH="$FAKE_BIN:$PATH" \
  "$ROOT_DIR/bin/maoleve" apply >/dev/null
! grep -q '\[mcp_servers\.headroom\]' "$generated_home/.codex/config.toml"

printf '%s\n' 'version drift warning tests passed'
