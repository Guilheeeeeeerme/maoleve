#!/usr/bin/env bash
# maoleve.sh — Mão leve tooling: install | status | uninstall
# Deterministic, manifest-driven installer for the token-economy stack.
# versions.env is a MINIMUM floor: never downgrades user binaries.
set -euo pipefail
umask 077

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

MAOLEVE_HOME="${MAOLEVE_HOME:-${XDG_STATE_HOME:-$HOME/.local/state}/maoleve}"
MANIFEST="$MAOLEVE_HOME/manifest"

BEGIN_MARK="# BEGIN MAOLEVE"
END_MARK="# END MAOLEVE"
TIER_SKILLS=(low fast medium high full)
HOOK_AUTO_AGENTS=(claude-code opencode)              # hooks on by default
ALL_AGENTS=(codex opencode claude-code cursor-ide cursor-agent)
LOGSTRIP_OPT_AGENTS=(codex cursor-ide cursor-agent)  # rtk-unhooked fallback set

# ---------------------------------------------------------------- output

info()    { printf '     %s\n' "$1"; }
ok()      { printf '  ok   %s\n' "$1"; }
skip()    { printf '  skip %s\n' "$1"; }
warn()    { printf '  warn %s\n' "$1" >&2; }
fail()    { printf '  fail %s\n' "$1" >&2; }
section() { printf '\n== %s ==\n' "$1"; }

ask() { # $1 question  $2 default(y|n)
  local reply def="${2:-y}"
  while :; do
    printf '  %s [%s/n] ' "$1" "$( [[ $def == y ]] && echo Y || echo y )"
    read -r reply
    reply="${reply:-$def}"
    case "$reply" in
      [Yy]|[Yy][Ee][Ss]) return 0 ;;
      [Nn]|[Nn][Oo])     return 1 ;;
      *) warn "answer y or n" ;;
    esac
  done
}

# ---------------------------------------------------------------- agent tables

agent_dir() {
  case "$1" in
    codex) echo "$HOME/.codex" ;;
    opencode) echo "$HOME/.config/opencode" ;;
    claude-code) echo "$HOME/.claude" ;;
    cursor-ide|cursor-agent) echo "$HOME/.cursor" ;;
  esac
}

agent_skilldir() {
  case "$1" in
    codex) echo "$HOME/.codex/skills" ;;
    opencode) echo "$HOME/.config/opencode/skills" ;;
    claude-code) echo "$HOME/.claude/skills" ;;
    cursor-ide|cursor-agent) echo "$HOME/.cursor/skills" ;;
  esac
}

agent_template() {
  case "$1" in
    codex) echo "$REPO_ROOT/templates/codex/AGENTS.md" ;;
    opencode) echo "$REPO_ROOT/templates/opencode/AGENTS.md" ;;
    claude-code) echo "$REPO_ROOT/templates/claude/CLAUDE.md" ;;
    cursor-ide) echo "$REPO_ROOT/templates/cursor/maoleve.mdc" ;;
    cursor-agent) echo "$REPO_ROOT/templates/cursor-agent/AGENTS.md" ;;
  esac
}

agent_policy() {
  case "$1" in
    codex) echo "$HOME/.codex/AGENTS.md" ;;
    opencode) echo "$HOME/.config/opencode/AGENTS.md" ;;
    claude-code) echo "$HOME/.claude/CLAUDE.md" ;;
    cursor-ide) echo "$HOME/.cursor/rules/maoleve.mdc" ;;
    cursor-agent) echo "$PWD/AGENTS.md" ;;
  esac
}

agent_rtk_flags() {
  case "$1" in
    codex) echo "--codex" ;;
    opencode) echo "--opencode" ;;
    claude-code) echo "" ;;
    cursor-ide|cursor-agent) echo "--agent cursor" ;;
  esac
}

hooks_auto_on() {
  local a
  for a in "${HOOK_AUTO_AGENTS[@]}"; do [[ "$a" == "$1" ]] && return 0; done
  return 1
}

in_list() { # $1 item, rest list -> 0 when item present
  local it="$1" x
  shift
  for x in "$@"; do
    [[ "$x" == "$it" ]] && return 0
  done
  return 1
}

agent_installed() { [[ -d "$(agent_dir "$1")" ]]; }

flag_on() { # $1 flag value -> true when y or 1 (default must stay OFF)
  case "${1:-}" in y|Y|1) return 0 ;; *) return 1 ;; esac
}

detect_agents() {
  local a
  for a in "${ALL_AGENTS[@]}"; do agent_installed "$a" && printf '%s\n' "$a"; done
}

detect_active_agent() {
  if [[ -n "${MAOLEVE_ACTIVE_AGENT:-}" ]]; then echo "$MAOLEVE_ACTIVE_AGENT"; return 0; fi
  if [[ -n "${CLAUDECODE:-}" ]]; then echo claude-code; return 0; fi
  if [[ -n "${CODEX_HOME:-}" ]]; then echo codex; return 0; fi
  if [[ "${TERM_PROGRAM:-}" == *ursor* ]]; then
    command -v cursor-agent >/dev/null 2>&1 && { echo cursor-agent; return 0; }
    echo cursor-ide; return 0
  fi
  return 1
}

# ---------------------------------------------------------------- versions

load_versions() { # shellcheck disable=SC1091
  source "$REPO_ROOT/versions.env"
}

floor_of() {
  case "$1" in
    rtk) echo "$MAOLEVE_RTK_VERSION" ;;
    headroom) echo "$MAOLEVE_HEADROOM_VERSION" ;;
    serena) echo "$MAOLEVE_SERENA_VERSION" ;;
    repomix) echo "${MAOLEVE_REPOMIX_VERSION:-}" ;;
    logstrip) echo "${MAOLEVE_LOGSTRIP_VERSION:-}" ;;
    ccusage) echo "${MAOLEVE_CCUSAGE_VERSION:-}" ;;
  esac
}

tool_version() {
  { "$1" --version 2>/dev/null || true; } | head -n1 \
    | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1
}

norm_ver() { # pad missing components: X -> X.0.0 ; X.Y -> X.Y.0
  local v="$1"
  local dots="${v//[!.]/}"
  case "${#dots}" in
    0) echo "$v.0.0" ;;
    1) echo "$v.0" ;;
    *) echo "$v" ;;
  esac
}

ver_at_least() { # $1 floor $2 installed -> 0 when installed >= floor
  local f i
  local -a F I
  IFS=. read -r -a F <<< "$1"
  IFS=. read -r -a I <<< "$2"
  local n
  for n in 0 1 2; do
    local a="${F[n]:-0}" b="${I[n]:-0}"
    a="${a//[!0-9]/}" ; b="${b//[!0-9]/}"
    : "${a:=0}" ; : "${b:=0}"
    (( 10#$b > 10#$a )) && return 0
    (( 10#$b < 10#$a )) && return 1
  done
  return 0
}

check_tool() { # -> missing | unknown | satisfied:X | behind:X
  if ! command -v "$1" >/dev/null 2>&1; then echo missing; return 0; fi
  local installed floor
  installed="$(tool_version "$1")"
  [[ -z "$installed" ]] && { echo unknown; return 0; }
  floor="$(floor_of "$1")"
  installed="$(norm_ver "$installed")" ; floor="$(norm_ver "$floor")"
  if ver_at_least "$floor" "$installed"; then echo "satisfied:$installed"
  else echo "behind:$installed"; fi
}

# ---------------------------------------------------------------- lock

acquire_lock() {
  mkdir -p "$MAOLEVE_HOME"
  if command -v flock >/dev/null 2>&1; then
    exec 9>"$MAOLEVE_HOME/.lock"
    flock -n 9 || { fail "another maoleve operation is in progress"; return 1; }
  fi
}

# ---------------------------------------------------------------- manifest
# flat file, key=value lines; list values space-separated on one line.

manifest_set() { # $1 key $2 value
  local key="$1" value="$2" tmp
  mkdir -p "$MAOLEVE_HOME"
  [[ -f "$MANIFEST" ]] || : > "$MANIFEST"
  grep -v "^${key}=" "$MANIFEST" > "$MAOLEVE_HOME/.m.tmp" || true
  printf '%s=%s\n' "$key" "$value" >> "$MAOLEVE_HOME/.m.tmp"
  mv "$MAOLEVE_HOME/.m.tmp" "$MANIFEST"
}

manifest_get() {
  local key="$1" line
  [[ -f "$MANIFEST" ]] || { printf ''; return 0; }
  line="$(grep "^${key}=" "$MANIFEST" 2>/dev/null | tail -n1)" || true
  printf '%s' "${line#*=}"
}

manifest_action() { # $1 sub  $2 key  $3 item
  local cmd="$1" key="$2" item="${3:-}" old line tail=()
  old="$(manifest_get "$key")"
  case "$cmd" in
    add)
      for line in $old; do [[ "$line" == "$item" ]] && return 0; done
      manifest_set "$key" "$old $item"
      ;;
    drop)
      for line in $old; do [[ "$line" == "$item" ]] || tail+=("$line"); done
      manifest_set "$key" "${tail[*]}"
      ;;
    clear) manifest_set "$key" "" ;;
  esac
}

# ---------------------------------------------------------------- checkout

resolve_checkout() {
  [[ -d "$REPO_ROOT/templates" ]] && return 0
  fail "no Mão leve checkout found (templates/ missing beside script)"
  return 1
}

# ---------------------------------------------------------------- skills

install_skills() {
  local key="$1" skilldir src dest tier
  skilldir="$(agent_skilldir "$key")"
  local srcs=("$REPO_ROOT/.agents/skills/caveman")
  local dests=("$skilldir/caveman")
  if flag_on "${MAOLEVE_ENABLE_REPOMIX:-}"; then
    srcs+=("$REPO_ROOT/.agents/skills/repomix") ; dests+=("$skilldir/maoleve-repomix")
  fi
  if flag_on "${MAOLEVE_ENABLE_CCUSAGE:-}"; then
    srcs+=("$REPO_ROOT/templates/skills/maoleve-ccusage") ; dests+=("$skilldir/maoleve-ccusage")
  fi
  for tier in "${TIER_SKILLS[@]}"; do
    srcs+=("$REPO_ROOT/templates/skills/maoleve-$tier")
    dests+=("$skilldir/maoleve-$tier")
  done
  local i
  for i in "${!srcs[@]}"; do
    src="${srcs[i]}" ; dest="${dests[i]}"
    if [[ "$src" == *"/.agents/skills/repomix" && "$key" == cursor-* && "${MAOLEVE_ALL_AGENTS:-}" != y ]]; then
      skip "repomix skill for $key needs --all-agents (guard: cursor config stays dormant)"
      continue
    fi
    [[ -e "$src" ]] || { warn "missing source: $src"; continue; }
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      skip "$dest already linked"
      continue
    fi
    mkdir -p "$(dirname "$dest")"
    if ln -sfn "$src" "$dest" 2>/dev/null && [[ -e "$dest" ]]; then
      ok "skill: $dest -> $src"
    else
      rm -rf "$dest"
      cp -a "$src" "$dest" && ok "skill: $dest (copied)" || { warn "cannot install $dest"; continue; }
    fi
    manifest_action add skills "$dest"
  done
}

remove_skills() {
  local dest
  for dest in $(manifest_get skills); do
    if [[ -L "$dest" ]]; then
      rm -f "$dest" && ok "unlinked: $dest"
    elif [[ -d "$dest" ]]; then
      rm -rf "$dest" && ok "removed: $dest"
    elif [[ -e "$dest" ]]; then
      rm -f "$dest" && ok "removed: $dest"
    fi
  done
  manifest_action clear skills
}

# ---------------------------------------------------------------- policy

merge_policy() {
  local key="$1" target template
  target="$(agent_policy "$key")"
  template="$(agent_template "$key")"
  [[ -f "$template" ]] || { warn "template missing: $template"; return 1; }
  mkdir -p "$(dirname "$target")"
  if [[ -f "$target" ]] && grep -qF "$BEGIN_MARK" "$target"; then
    skip "policy block already present: $target"
    return 0
  fi
  info "merging dormant policy into $target"
  {
    if [[ -f "$target" ]]; then
      cat "$target"
      tail -c1 "$target" 2>/dev/null | grep -q \(.*[[:graph:]]\) && printf '\n'
    fi
    printf '%s\n' "$BEGIN_MARK"
    cat "$template"
    printf '%s\n' "$END_MARK"
  } > "$target.maotmp" && mv "$target.maotmp" "$target"
  manifest_action add policy_files "$target"
}

remove_policy() {
  local key="$1" target
  target="$(agent_policy "$key")"
  [[ -f "$target" ]] || return 0
  grep -qF "$BEGIN_MARK" "$target" || return 0
  info "removing policy block from $target"
  python3 - "$target" <<'PY'
import sys, pathlib
p = pathlib.Path(sys.argv[1])
lines = p.read_text().splitlines(keepends=True)
out, in_block = [], False
for line in lines:
    s = line.strip()
    if not in_block and s.startswith("# BEGIN MAOLEVE"):
        in_block = True; continue
    if in_block and s.startswith("# END MAOLEVE"):
        in_block = False; continue
    if not in_block:
        out.append(line)
content = "".join(out)
if content.strip():
    p.write_text(content)
else:
    p.unlink()
PY
}

# ---------------------------------------------------------------- fs safety

safe_rm_rf() { # refuses to rm empty/root-ish or out-of-scope paths (GAP-06 pathcheck)
  local p="$1"
  case "$p" in
    ""|/|/home|"$HOME"|"$MAOLEVE_HOME")
      fail "refusing unsafe rm -rf: ${p:-<empty>}"
      return 1
      ;;
  esac
  if [[ -L "$p" ]]; then           # rm -rf on a symlink: remove only the link
    rm -f "$p"
    return 0
  fi
  rm -rf -- "${p%/}"               # trailing slash would dereference a leading symlink
}

sweep_stale_locks() { # GAP-06: crashed install can orphan lock/manifest-temp files
  # probe the lock with flock instead of pgrep -f (pgrep would false-match agents running from this repo)
  if command -v flock >/dev/null 2>&1 && [[ -f "$MAOLEVE_HOME/.lock" ]]; then
    exec 9>>"$MAOLEVE_HOME/.lock" || true
    if ! flock -n 9 2>/dev/null; then
      warn "maoleve lock held by a live process — not sweeping"
      return 1
    fi
  fi
  rm -f -- "$MAOLEVE_HOME/.lock" "$MAOLEVE_HOME/.m.tmp"
}

# ---------------------------------------------------------------- hooks

install_hook() {
  local key="$1" flags
  flags="$(agent_rtk_flags "$key")"
  info "installing rtk hooks for $key"
  if rtk init -g $flags >/dev/null 2>&1; then
    manifest_action add hook_agents "$key"
    ok "rtk hooks: $key"
  else
    warn "rtk init failed for $key"
  fi
}

remove_hook() {
  local key="$1" flags
  flags="$(agent_rtk_flags "$key")"
  info "removing rtk hooks for $key"
  rtk init -g $flags --uninstall >/dev/null 2>&1 \
    || warn "rtk init --uninstall errored for $key"
}

# ---------------------------------------------------------------- install

cmd_install() {
  local requested=("$@") agents=() key active binaries_conscent="ask" state
  section "Mão leve install"

  resolve_checkout
  load_versions
  acquire_lock

  active="$(detect_active_agent || true)"
  if [[ -z "$active" && -n "${requested[0]:-}" ]]; then
    active="${requested[0]}"
  fi

  if [[ ${#requested[@]} -gt 0 ]]; then
    for key in "${requested[@]}"; do
      case "$key" in
        codex|opencode|claude-code|cursor-ide|cursor-agent) agents+=("$key") ;;
        *) fail "unknown agent: $key (vir: codex opencode claude-code cursor-ide cursor-agent)"; return 1 ;;
      esac
    done
  else
    mapfile -t agents < <(detect_agents)
    if [[ ${#agents[@]} -eq 0 ]]; then
      fail "no supported agent detected: codex opencode claude-code cursor-ide cursor-agent"
      info "hint: start your agent once, or pass the agent explicitly (maoleve.sh install claude-code)"
      return 1
    fi
  fi
  info "agents to configure: ${agents[*]}"
  info "skills for session agent: ${active:-none (pass --all-agents to mirror everywhere)}"
  [[ "${MAOLEVE_ALL_AGENTS:-}" == "y" ]] && info "skills: mirroring to all authorized agents (--all-agents)"

  # approval card
  echo
  printf '  Approval card\n'
  for key in "${agents[@]}"; do
    local hk policy
    policy="$(agent_policy "$key")"
    hooks_auto_on "$key" && hk="auto" || hk="opt-in (default off)"
    info "  $key   hooks:$hk   skill-dir:$(agent_skilldir "$key")   policy:$policy"
  done
  info "  out of scope, never touched: Headroom proxy/wrap · MCP registration · always-on rules · secrets · unrelated config"
  echo
  if ! ask "Install for these agents?" y; then
    info "aborted; nothing changed."
    return 0
  fi

  # binaries — one consent each; NEVER downgrade
  for name in rtk headroom serena; do
    state="$(check_tool "$name")"
    case "$state" in
      missing)
        case "${MAOLEVE_INSTALL_BINARIES:-ask}" in
          yes)
            info "installing $name (floor $(floor_of "$name"))"
            install_binary "$name" || warn "$name install failed"
            ;;
          skip) skip "$name (binary install disabled this run)" ;;
          *)
            if ask "install $name? (floor: $(floor_of "$name"))" y; then
              install_binary "$name" || warn "$name install failed"
            else
              skip "$name — install later with: maoleve.sh install"
            fi
            ;;
        esac
        ;;
      satisfied:*) ok "$name: ${state#satisfied:} (floor $(floor_of "$name")) — untouched" ;;
      behind:*)    warn "$name: ${state#behind:} is BELOW floor $(floor_of "$name") — please upgrade manually; we never downgrade" ;;
      unknown)     warn "$name: installed but version unreadable — left as-is" ;;
    esac
  done

  # opt-in adapters — flags default OFF; never force on, no binary install, no network
  local flagflag flagvar
  for flagflag in repomix logstrip ccusage; do
    flagvar="MAOLEVE_ENABLE_${flagflag^^}"
    if ! flag_on "${!flagvar:-}"; then
      skip "$flagflag (MAOLEVE_ENABLE_${flagflag^^} not set — default OFF)"
    elif ! command -v npx >/dev/null 2>&1; then
      warn "$flagflag: flag=y but npx missing (node >=18 floor) — adapter left dormant"
    else
      manifest_action add enabled_flags "$flagflag"
      ok "$flagflag: opt-in enabled, pinned $(floor_of "$flagflag") — npx wrapper on demand"
    fi
  done

  # skills
  if [[ "${MAOLEVE_ALL_AGENTS:-}" == "y" ]]; then
    for key in "${agents[@]}"; do install_skills "$key"; done
  elif [[ -n "$active" ]]; then
    install_skills "$active"
  else
    warn "no active session agent detected; skills not installed (pass --all-agents or call install from inside an agent session)"
  fi

  # dormant policy
  for key in "${agents[@]}"; do merge_policy "$key" || true; done

  # hooks
  if [[ -n "${MAOLEVE_HOOKS:-}" ]]; then
    local -a want_hooks
    IFS=, read -r -a want_hooks <<< "${MAOLEVE_HOOKS}"
    for key in "${agents[@]}"; do
      local h listed=0
      for h in "${want_hooks[@]}"; do
        [[ "$h" == "$key" ]] && { install_hook "$key"; listed=1; break; }
      done
      if (( ! listed )) && hooks_auto_on "$key" && command -v rtk >/dev/null 2>&1; then
        install_hook "$key"
      fi
    done
  else
    for key in "${agents[@]}"; do
      command -v rtk >/dev/null 2>&1 && hooks_auto_on "$key" && install_hook "$key"
    done
  fi

  # logstrip pipe fallback (flag-gated; strictly for agents rtk cannot hook)
  if flag_on "${MAOLEVE_ENABLE_LOGSTRIP:-}"; then
    local lskey
    for lskey in "${agents[@]}"; do
      if hooks_auto_on "$lskey" || has_hook "$lskey"; then
        skip "logstrip not stacked on $lskey (rtk hook present — no double compression: GAP-05)"
      elif in_list "$lskey" "${LOGSTRIP_OPT_AGENTS[@]}"; then
        manifest_action add logstrip_agents "$lskey"
        ok "logstrip pipe fallback registered: $lskey (tier/policy text only — no hook written)"
      else
        skip "logstrip not for $lskey (outside opt-in fallback set)"
      fi
    done
  fi

  manifest_set updated_at "$(date -u +%FT%TZ)"
  manifest_set agents "${agents[*]}"
  manifest_set checkout "$REPO_ROOT"
  manifest_set skill_agent "${active:-}"

  section "Install report"
  for key in "${agents[@]}"; do
    local sk policy2 hk2 dir
    dir="$(agent_policy "$key")"
    if [[ -f "$dir" ]] && grep -qF "$BEGIN_MARK" "$dir"; then policy2="merged"; else policy2="pending"; fi
    if [[ "${MAOLEVE_ALL_AGENTS:-}" == "y" || "$key" == "${active:-}" ]]; then
      [[ -e "$(agent_skilldir "$key")/caveman" ]] && sk="installed" || sk="missing"
    else
      sk="opt-in (--all-agents)"
    fi
    hk2="$(has_hook "$key" && echo installed || echo default)"
    ok "$key   policy:$policy2   skills:$sk   hooks:$hk2   opt-in-flag:$(manifest_get enabled_flags || true)"
  done
  info "floor policy: never downgraded; suggested bump on drift only"
  info "activation: at the start of each chat paste /maoleve-<tier>"
}

has_hook() {
  local h
  for h in $(manifest_get hook_agents); do [[ "$h" == "$1" ]] && return 0; done
  return 1
}

# ---------------------------------------------------------------- status

cmd_status() {
  section "Mão leve status"
  [[ -f "$REPO_ROOT/versions.env" ]] && load_versions

  local state name
  for name in rtk headroom serena; do
    state="$(check_tool "$name")"
    case "$state" in
      missing)     fail "$name: not installed" ;;
      satisfied:*) ok "$name: ${state#satisfied:} (floor $(floor_of "$name"))" ;;
      behind:*)    warn "$name: ${state#behind:} below floor $(floor_of "$name") — upgrade recommended" ;;
      unknown)     warn "$name: version unreadable" ;;
    esac
  done

  echo
  info "opt-in adapters: MAOLEVE_ENABLE_REPOMIX=${MAOLEVE_ENABLE_REPOMIX:-off}  MAOLEVE_ENABLE_LOGSTRIP=${MAOLEVE_ENABLE_LOGSTRIP:-off}  MAOLEVE_ENABLE_CCUSAGE=${MAOLEVE_ENABLE_CCUSAGE:-off}"
  info "  pins from versions.env (lock file — repo policy: warn on drift, never auto-upgrade): repomix $(floor_of repomix) · logstrip $(floor_of logstrip) · ccusage $(floor_of ccusage)"
  info "  on demand only: npx -y repomix@$(floor_of repomix) --stdout --compress --token-budget 4000 | npx -y ccusage@$(floor_of ccusage) daily --offline"

  echo
  if [[ -f "$MANIFEST" ]]; then
    ok "manifest: $MANIFEST"
    local k v
    while IFS='=' read -r k v; do
      [[ -n "$v" ]] && info "$k: $v"
    done < "$MANIFEST"
    info "uninstall reverses exactly these items."
  else
    info "no manifest: run install first (previous installs without manifest are not reversible)."
  fi

  echo
  info "policy blocks:"
  local key target found=0
  for key in "${ALL_AGENTS[@]}"; do
    target="$(agent_policy "$key")"
    [[ -f "$target" ]] || continue
    if grep -qF "$BEGIN_MARK" "$target" 2>/dev/null; then
      ok "$key: $target"
      found=$((found+1))
    else
      skip "$key: no block in $target"
    fi
  done
  (( found )) || info "(none found)"

  echo
  info "skills found:"
  for key in "${ALL_AGENTS[@]}"; do
    local sd tier
    sd="$(agent_skilldir "$key")"
    [[ -e "$sd/caveman" ]] && ok "$key: caveman"
    for tier in "${TIER_SKILLS[@]}"; do
      [[ -e "$sd/maoleve-$tier" ]] && info "$key: maoleve-$tier"
    done
  done

  # doctor
  echo
  section "doctor pass"
  local hits=0 sd
  for key in "${ALL_AGENTS[@]}"; do
    local cfg
    cfg="$(agent_dir "$key")"
    [[ -e "$cfg" ]] || continue
    if grep -rE 'rtk' "$cfg" >/dev/null 2>&1; then
      if ! command -v rtk >/dev/null 2>&1; then
        warn "$key: references rtk but binary missing — re-install rtk or 'maoleve.sh uninstall' to strip hooks"
        hits=$((hits+1))
      fi
    fi
  done
  for key in "${ALL_AGENTS[@]}"; do
    sd="$(agent_skilldir "$key")"
    if [[ -d "$sd/caveman" && -d "$HOME/.agents/skills/caveman" ]]; then
      info "$key: caveman duplicated in ~/.agents/skills and $sd (slower boot — remove one if unwanted)"
      hits=$((hits+1))
    fi
  done
  local lsrecorded
  lsrecorded="$(manifest_get logstrip_agents)"
  if [[ -n "$lsrecorded" ]] && ! flag_on "${MAOLEVE_ENABLE_LOGSTRIP:-}"; then
    warn "manifest records logstrip fallback for: $lsrecorded — but MAOLEVE_ENABLE_LOGSTRIP is off (drift — run 'maoleve.sh uninstall' to clean, never auto-fix)"
    hits=$((hits+1))
  fi
  (( hits == 0 )) && ok "no known crash signatures found."
}

# ---------------------------------------------------------------- uninstall

cmd_uninstall() {
  section "Mão leve uninstall"
  resolve_checkout || true
  acquire_lock

  if [[ ! -f "$MANIFEST" ]]; then
    warn "no manifest — best-effort sweep of standard Mão leve layout"
    local key sd tier sp opt
    for key in "${ALL_AGENTS[@]}"; do
      remove_policy "$key" || true
      sd="$(agent_skilldir "$key")"
      for tier in "${TIER_SKILLS[@]}"; do
        sp="$sd/maoleve-$tier"
        if [[ -e "$sp" ]]; then safe_rm_rf "$sp" && ok "removed: $sp"; fi
      done
      for opt in maoleve-repomix maoleve-ccusage; do
        if [[ -e "$sd/$opt" ]]; then safe_rm_rf "$sd/$opt" && ok "removed: $sd/$opt"; fi
      done
      if [[ -e "$sd/caveman" ]]; then
        safe_rm_rf "$sd/caveman" && ok "removed: $sd/caveman"
      fi
    done
    info "binaries untouched."
    info "stale lock sweep: $(sweep_stale_locks)"
    info "Mão leve fully removed: yes (best effort)."
    return 0
  fi

  if ! ask "Remove all items recorded in manifest? (binaries kept)" y; then
    info "aborted; nothing changed."
    return 0
  fi

  local key
  for key in $(manifest_get hook_agents); do remove_hook "$key"; done
  remove_skills
  for key in "${ALL_AGENTS[@]}"; do remove_policy "$key" || true; done

  # opt-in adapter state: skills already covered above; purge the opt-in keys
  for key in $(manifest_get logstrip_agents); do
    info "logstrip fallback for $key was pipe/policy text only — no hook file to strip"
  done
  manifest_action clear logstrip_agents
  manifest_action clear enabled_flags

  if ask "Also uninstall rtk / headroom / serena binaries? (other projects may use them)" n; then
    if command -v uv >/dev/null 2>&1; then
      uv tool uninstall headroom-ai 2>/dev/null || true
      uv tool uninstall serena-agent 2>/dev/null || true
    fi
    info "rtk not auto-removed; upstream uninstall via its own tooling"
  fi

  sweep_stale_locks || true
  rm -f "$MANIFEST"

  section "Uninstall report"
  ok "hooks cleared, skills removed, policy blocks stripped, opt-in keys purged, stale locks swept, manifest cleared."
  ok "Mão leve fully removed: yes."
}

# ---------------------------------------------------------------- usage

usage() {
  cat <<EOF
maoleve.sh — Mão leve tooling

Usage:
  maoleve.sh install [--hooks a,b] [--all-agents] [agent ...]
  maoleve.sh status
  maoleve.sh uninstall

Agents: codex opencode claude-code cursor-ide cursor-agent

Defaults
  skills:    active agent only (--all-agents mirrors everywhere)
  rtk hooks: claude-code & opencode on when rtk present
             codex & cursor opt-in via --hooks (observed crash source)
  binaries:  versions.env = floor — install missing, never downgrade, warn on drift

Opt-in adapters (all default OFF; pinned in versions.env; node >=18 / npx)
  MAOLEVE_ENABLE_REPOMIX    high-tier context packing, token-budget fail-fast
  MAOLEVE_ENABLE_LOGSTRIP   pipe fallback only for codex/cursor (never on rtk agents)
  MAOLEVE_ENABLE_CCUSAGE    run-on-demand local usage scan: npx -y ccusage@20.0.24 daily --offline
EOF
}

# ---------------------------------------------------------------- main

case "${1:-help}" in
  install)
    shift
    OPT_SKIP= OPT_HOOKS= OPT_ALL= POS=()
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --all-agents) OPT_ALL=y; shift ;;
        --hooks) [[ $# -ge 2 && $2 != -* ]] && { OPT_HOOKS=$2; shift; } ; shift ;;
        --hooks=*) OPT_HOOKS="${1#*=}"; shift ;;
        *) POS+=("$1"); shift ;;
      esac
    done
    [[ "$OPT_ALL" == y ]] && export MAOLEVE_ALL_AGENTS=y
    [[ -n "$OPT_HOOKS" ]] && export MAOLEVE_HOOKS="$OPT_HOOKS"
    cmd_install ${POS[@]+"${POS[@]}"}
    ;;
  status)    cmd_status ;;
  uninstall) cmd_uninstall ;;
  help|-h|--help) usage ;;
  *) usage; fail "unknown command: $1"; exit 1 ;;
esac
