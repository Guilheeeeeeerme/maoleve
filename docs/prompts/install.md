# Mão leve one-time install

Copy everything below the line into your coding agent **once** per machine (or when
repairing the harness). This prepares binaries, vendored skills, and policy
templates. It does **not** turn on compression layers, proxy, MCP, or always-on
rules — activate a tier at the start of each chat instead.

---

You are the Mão leve setup agent performing a **one-time install**.

**Goal:** prepare the token-economy stack on disk so the human can activate a tier
per chat with `/maoleve-<tier>` or `maoleve-<tier>` (see `docs/token-tiers.md`).

**In scope:** checkout clone/update, RTK + Headroom + Serena binaries (pinned to
`versions.env`), vendored Caveman skill copy, policy templates merged as
**dormant** Mão leve-managed blocks (per-chat activation only).

**Out of scope:** enabling Headroom proxy/wrap in agent config, registering MCP
servers, `alwaysApply` rules, starting proxies, legacy `bin/maoleve` /
`install.sh`, tokensave, Playwright MCP.

**Idempotent:** safe to re-run. For each component, detect what is already
installed or merged; **reuse or skip** when versions match `versions.env` and
dormant policy markers are correct. Install or repair only what is missing or
broken. Never enable proxy, MCP, or always-on tier rules on a re-run.

Follow [`docs/supervised-setup.md`](../supervised-setup.md): run **discovery**,
present the **single approval card** (phase = install), then execute only after
`approve` or `edit:`. Report installed, reused, skipped, manual, and failed
items at the end.

## First actions

1. Run discovery from `docs/supervised-setup.md` (platform, active agent,
   harness dirs, checkout, binaries, existing Mão leve state).
2. Present the approval card with defaults: agents = active + detected harnesses;
   checkout = clone `~/maoleve` if missing else update existing; config access
   = structure only.
3. After approval, set `MAOLEVE_CHECKOUT` to the repo root. Read `PROMPT.md`,
   `docs/token-tiers.md`, and `versions.env`.
4. Checkout mutation only after approval:
   - missing: `git clone https://github.com/Guilheeeeeeerme/maoleve.git <dir>`
   - existing: inspect status; update only without discarding user changes
   Never use `git reset --hard`, `git checkout --`, or destructive cleanup.

## Supported agents — install coverage

Configure **each agent the human authorizes**. One agent's permission does not
extend to another. For every authorized agent, install applies the rows below.

| Agent | Caveman mirror | RTK hooks | Policy merge target | Template |
| --- | --- | --- | --- | --- |
| **Codex** | `~/.codex/skills/caveman/` | `rtk init --global --codex` | `~/.codex/AGENTS.md` | `templates/codex/AGENTS.md` |
| **OpenCode** | `~/.config/opencode/skills/caveman/` | `rtk init --global --opencode` | `~/.config/opencode/AGENTS.md` | `templates/opencode/AGENTS.md` |
| **Claude Code** | `~/.claude/skills/caveman/` | `rtk init --global` | `~/.claude/CLAUDE.md` | `templates/claude/CLAUDE.md` |
| **Cursor IDE** | `~/.cursor/skills/caveman/` | `rtk init --global --agent cursor` | `~/.cursor/rules/maoleve.mdc` | `templates/cursor/maoleve.mdc` |
| **Cursor Agents** | `~/.cursor/skills/caveman/` | `rtk init --global --agent cursor` | project `AGENTS.md` (or path human confirms) | `templates/cursor-agent/AGENTS.md` |

Shared for all authorized agents:

- `~/.agents/skills/caveman/` — canonical vendored copy (step 1)
- RTK, Headroom, Serena binaries (steps 2–4) — same versions from `versions.env`
- Optional non-secret defaults in `~/.config/maoleve/env.sh` (Headroom vars by name only)

Cursor IDE and Cursor Agents are **separate targets** — configure both only when
both are authorized.

## Configuration merge rules

Use the merge rules in [`docs/supervised-setup.md`](../supervised-setup.md).
Preserve existing RTK `@RTK.md` references and hooks added by `rtk init`.

## Install steps

Use versions from `versions.env` when installing binaries.

### 1. Vendored Caveman (do not use `npx skills add`)

Skip if `~/.agents/skills/caveman/SKILL.md` exists and matches the checkout
(compare checksum or diff); otherwise copy:

```bash
mkdir -p "$HOME/.agents/skills/caveman"
cp -a "$MAOLEVE_CHECKOUT/.agents/skills/caveman/." "$HOME/.agents/skills/caveman/"
```

Mirror into each **authorized** agent skill directory (symlink with `ln -sfn`
when possible). See the coverage table above for the full per-agent list:

| Agent | Mirror path |
| --- | --- |
| Codex | `~/.codex/skills/caveman/` |
| OpenCode | `~/.config/opencode/skills/caveman/` |
| Claude Code | `~/.claude/skills/caveman/` |
| Cursor IDE | `~/.cursor/skills/caveman/` |
| Cursor Agents | `~/.cursor/skills/caveman/` (shared with Cursor IDE when both authorized) |

### 2. RTK

1. If `rtk --version` succeeds and matches `versions.env`, skip install; else run
   `"$MAOLEVE_CHECKOUT/scripts/install-rtk.sh"` (tries `master`, then `main`).
   Warn if installed semver drifts from `MAOLEVE_RTK_VERSION`.
2. Initialize hooks for each **authorized** agent when hooks are absent (with approval):
   - **Claude Code:** `rtk init --global`
   - **Codex:** `rtk init --global --codex`
   - **OpenCode:** `rtk init --global --opencode`
   - **Cursor IDE:** `rtk init --global --agent cursor`
   - **Cursor Agents:** `rtk init --global --agent cursor` (same RTK target as Cursor IDE)
3. RTK hooks stay installed but the agent uses RTK **only when a tier activation
   prompt selects it for the current chat**.

### 3. Headroom (binary only — do not wrap or proxy yet)

Skip if `headroom --version` matches `versions.env`; else install:

```bash
# if uv missing: curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install "headroom-ai[all]==<MAOLEVE_HEADROOM_VERSION>"
```

Optionally merge non-secret defaults into `~/.config/maoleve/env.sh` (create if
absent). Reference API keys by variable name only — never copy secret values:

```bash
HEADROOM_MODE=token
HEADROOM_SAVINGS_PROFILE=coding
HEADROOM_TOOL_SEARCH=1
```

Do **not** run `headroom wrap`, set proxy base URLs, or add Headroom MCP during
install. The human starts proxy/wrap when activating **fast+** tiers (see
`docs/prompts/activate-*.md`).

### 4. Serena (binary only — do not register MCP yet)

Skip if `serena --version` matches `versions.env`; else:

```bash
uv tool install -p 3.13 "serena-agent==<MAOLEVE_SERENA_VERSION>"
```

Do **not** run `claude mcp add`, edit `mcp.json`, or start Serena during install.
Registration happens when the human activates **high** or **full** (manual step
in the activation prompt).

### 5. Dormant policy templates

Merge Mão leve-managed policy from `$MAOLEVE_CHECKOUT/templates/<agent>/` into
each authorized agent's native surface. Templates already say tools apply
**when selected** for the active chat — do not change them to always-on.

| Agent | Merge target | Template |
| --- | --- | --- |
| Codex | `~/.codex/AGENTS.md` | `templates/codex/AGENTS.md` |
| OpenCode | `~/.config/opencode/AGENTS.md` | `templates/opencode/AGENTS.md` |
| Claude Code | `~/.claude/CLAUDE.md` | `templates/claude/CLAUDE.md` |
| Cursor IDE | `~/.cursor/rules/maoleve.mdc` | `templates/cursor/maoleve.mdc` |
| Cursor Agents | project `AGENTS.md` (confirm path with human) | `templates/cursor-agent/AGENTS.md` |

For OpenCode, ensure `opencode.json` references the merged `AGENTS.md` if the
runtime requires an `instructions` entry — merge only; do not overwrite unrelated
MCP or plugin settings.

Tell the human: tier policy takes effect only after pasting an activation prompt
(`/maoleve-medium`, etc.) at the start of a chat.

### Explicitly skip during install

- Headroom proxy/wrap and Headroom MCP
- Serena (and any other) MCP registration
- Enabling `alwaysApply: true` on Cursor rules
- tokensave, Playwright MCP
- `bin/maoleve`, `install.sh`, blast-install paths

## Post-install (this session)

After approval, run and summarize (no secrets):

```text
Create a concise Mão leve one-time install report.

1. Platform, shell, checkout path, authorized agents.
2. rtk --version; headroom --version; serena --version (or note skipped)
3. Confirm ~/.agents/skills/caveman/SKILL.md and agent mirrors.
4. Confirm Headroom wrap/proxy NOT configured.
5. Confirm Serena MCP NOT registered (MCP count 0 at idle).
6. Confirm policy templates merged with alwaysApply false (Cursor) and
   "when selected" wording.
7. Compare tool versions to versions.env.

Shape:

Mão leve install report
Platform:
Shell:
Checkout:
Authorized agents:
RTK: installed/reused | hooks present for authorized agents
Headroom: binary installed | proxy/wrap NOT enabled
Serena: binary installed | MCP NOT registered
Caveman: vendored copy ok/missing
Policy templates: merged dormant / skipped
MCP at idle: 0 (required)
Next step: new chat → docs/prompts/verify.md, then daily /maoleve-<tier>
Credentials preserved: yes/no
Manual actions:
Failures:
```

Report installed, reused, skipped, manual, and failed items. English only.

**Next (new chat):** tell the human to paste [`docs/prompts/verify.md`](./verify.md)
in a fresh session for a full audit and repair pass before daily tier activation.
