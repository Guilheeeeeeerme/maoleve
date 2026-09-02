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

Work as a supervised operator: identify platform, explain each planned action,
obtain human approval before checkout mutation, configuration inspection,
installation, or change. Report installed, reused, skipped, manual, and failed
items at the end.

## First actions

1. Identify the active supported agent: Codex, OpenCode, Cursor Agents
   (`cursor-agent`), Cursor IDE, or Claude Code. Do not assume from directory
   names or environment variables.
2. Detect OS, shell, and package manager. Ubuntu Linux is primary tested;
   continue on compatible Linux or macOS when possible.
3. Ask where Mão leve should live if no checkout exists. Explain clone vs
   update and obtain approval before mutating the checkout. After approval:
   - missing checkout: `git clone https://github.com/Guilheeeeeeerme/maoleve.git <dir>`
   - existing checkout: inspect status; update only without discarding user changes
   Never use `git reset --hard`, `git checkout --`, or destructive cleanup.
4. Set `MAOLEVE_CHECKOUT` to the repo root. Read `PROMPT.md`, `docs/token-tiers.md`,
   and `versions.env`.

## Required supervised questions

Ask explicitly; wait for answers. "skip" and "manual instructions" are valid.

1. May I inspect the active agent's existing harness configuration?
2. May I discover reusable configuration in other agents? Which agents are
   authorized? (One agent's permission does not extend to another.)
3. Which exact credential-bearing files, directories, or environment sources may
   I read? Discovery consent does not authorize credential reads.
4. Confirm **one-time install only**: prepare tools and templates; do **not**
   enable proxy, MCP, or always-on tier policy for this chat.

## Configuration merge rules

- Read existing configuration before editing.
- Preserve credentials, model choices, plugins, rules, hooks, unknown fields,
  formatting, and ordering.
- Add only absent Mão leve-managed entries; mark blocks with stable ownership
  metadata (`BEGIN MAOLEVE` / `END MAOLEVE`).
- Policy templates use **when selected / per-chat** wording — not always-on.
- For Cursor IDE: write `templates/cursor/maoleve.mdc` with `alwaysApply: false`.
- Show a diff or concise summary before ambiguous edits.
- Create a recoverable backup before repair or rewrite.
- Never print secret values.

## Install steps

Use versions from `versions.env` when installing binaries.

### 1. Vendored Caveman (do not use `npx skills add`)

```bash
mkdir -p "$HOME/.agents/skills/caveman"
cp -a "$MAOLEVE_CHECKOUT/.agents/skills/caveman/." "$HOME/.agents/skills/caveman/"
```

Mirror into each **authorized** agent skill directory when that runtime uses a
separate path (symlink with `ln -sfn` when possible):

| Agent | Also mirror to |
| --- | --- |
| Cursor IDE / Cursor Agents | `~/.cursor/skills/caveman/` |
| Codex | `~/.codex/skills/caveman/` |
| Claude Code | `~/.claude/skills/caveman/` |
| OpenCode | `~/.config/opencode/skills/caveman/` |

### 2. RTK

1. Install if missing: `curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/main/install.sh | sh`
2. Initialize hooks for each **authorized** agent (with approval):
   - **Claude Code:** `rtk init --global`
   - **Codex:** `rtk init --global --codex`
   - **OpenCode:** `rtk init --global --opencode`
   - **Cursor IDE / Cursor Agents:** `rtk init --global --agent cursor`
3. RTK hooks stay installed but the agent uses RTK **only when a tier activation
   prompt selects it for the current chat**.

### 3. Headroom (binary only — do not wrap or proxy yet)

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

| Agent | Surface | Template |
| --- | --- | --- |
| Codex | `AGENTS.md` | `templates/codex/AGENTS.md` |
| OpenCode | `AGENTS.md` | `templates/opencode/AGENTS.md` |
| Cursor Agents | project or agreed `AGENTS.md` | `templates/cursor-agent/AGENTS.md` |
| Cursor IDE | `.cursor/rules/maoleve.mdc` | `templates/cursor/maoleve.mdc` |
| Claude Code | `CLAUDE.md` | `templates/claude/CLAUDE.md` |

Tell the human: tier policy takes effect only after pasting an activation prompt
(`/maoleve-medium`, etc.) at the start of a chat.

### Explicitly skip during install

- Headroom proxy/wrap and Headroom MCP
- Serena (and any other) MCP registration
- Enabling `alwaysApply: true` on Cursor rules
- tokensave, Playwright MCP
- `bin/maoleve`, `install.sh`, blast-install paths

## Post-install verification

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
Next step: start a chat with /maoleve-<tier> or maoleve-<tier>
Credentials preserved: yes/no
Manual actions:
Failures:
```

Report installed, reused, skipped, manual, and failed items. English only.
