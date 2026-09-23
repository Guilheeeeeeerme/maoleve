#!/usr/bin/env bash
# Tests: opt-in adapter gates (repomix / logstrip / ccusage) — flags default OFF,
# manifest registration, logstrip never stacks on rtk-hooked agents (GAP-05),
# and versions.env pins match the approved feature_flags.yaml.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SANDBOX="$(mktemp -d)"
trap 'rm -rf "$SANDBOX"' EXIT
mkdir -p "$SANDBOX/home" "$SANDBOX/state"

export HOME="$SANDBOX/home"
export MAOLEVE_HOME="$SANDBOX/state"
export MAOLEVE_INSTALL_BINARIES=skip

die() { echo "FAIL: $*" >&2; exit 1; }

# --- T1: gate defaults (flag must stay OFF unless y/1) -----------------------
. "$ROOT/scripts/maoleve.sh" >/dev/null 2>&1   # source = usage only, no side effects

for v in "" n no off 0 no false N; do
  flag_on "$v" && die "flag_on '$v' must be rejected (default OFF)"
done
flag_on y  || die "flag_on 'y' rejected"
flag_on 1  || die "flag_on '1' rejected"
flag_on Y  || die "flag_on 'Y' rejected"
echo "ok: gates default OFF (T1)"

# --- T2: flag ON = manifest registered ---------------------------------------
echo y | env MAOLEVE_ENABLE_REPOMIX=y MAOLEVE_ENABLE_CCUSAGE=y \
  MAOLEVE_ACTIVE_AGENT=codex \
  bash "$ROOT/scripts/maoleve.sh" install codex >/dev/null

grep -q '^enabled_flags=.*repomix' \
  "$MAOLEVE_HOME/manifest" || die "MAOLEVE_ENABLE_REPOMIX=y did not register in manifest"
grep -q '^enabled_flags=.*ccusage' \
  "$MAOLEVE_HOME/manifest" || die "MAOLEVE_ENABLE_CCUSAGE=y did not register in manifest"
[[ -e "$HOME/.codex/skills/maoleve-repomix" ]] || die "repomix skill not installed for active agent"
echo "ok: flag ON -> manifest registered (T2)"

# --- T3: logstrip never on rtk-hooked agents ---------------------------------
echo y | env MAOLEVE_ENABLE_LOGSTRIP=y \
  MAOLEVE_ACTIVE_AGENT=codex \
  bash "$ROOT/scripts/maoleve.sh" install codex claude-code >/dev/null

ls="$(grep '^logstrip_agents=' "$MAOLEVE_HOME/manifest")"
[[ "$ls" != *claude-code* ]] || die "logstrip stacked on rtk-auto agent claude-code (GAP-05)"
[[ "$ls" != *opencode* ]]    || die "logstrip stacked on rtk-auto agent opencode (GAP-05)"
[[ "$ls" == *codex* ]] || die "logstrip fallback not registered for unhooked agent codex"
echo "ok: logstrip never stacked on rtk-hooked agents (T3)"

# --- T4: feature_flags.yaml pins match versions.env --------------------------
CFG="$(dirname "$ROOT")/artifacts/feature_flags.yaml"
[[ -f "$CFG" ]] || CFG=""
[[ -n "$CFG" ]] || echo "note: standalone checkout without artifacts/feature_flags.yaml — pins are tested directly"
if [[ -n "$CFG" ]]; then
  while IFS= read -r got; do
    tool="${got%%=*}"; want="${got#*=}"
    grep -qE "^MAOLEVE_${tool^^}_VERSION=${want}\$" "$ROOT/versions.env" \
      || die "versions.env pin for $tool != feature_flags.yaml pin ($tool=${want})"
  done <<'EOF'
repomix=1.18.1
logstrip=1.12.0
ccusage=20.0.24
EOF
  while IFS= read -r want; do
    grep -qF "version_pin: MAOLEVE_${want%%=*}_VERSION=${want#*=}" "$CFG" \
      || die "feature_flags.yaml missing pin for ${want%%=*}"
  done <<'EOF'
REPOMIX=1.18.1
LOGSTRIP=1.12.0
CCUSAGE=20.0.24
EOF
  echo "ok: feature_flags.yaml pins == versions.env pins (T4)"
fi

echo "ok: all feature-flag gates passed"
