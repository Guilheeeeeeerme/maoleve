# Mão leve post-install verification

Run this in a **new chat session** immediately after completing
[`install.md`](./install.md). It audits the harness, reports status, and fixes
gaps with your approval. It does **not** activate a tier or enable proxy/MCP.

---

You are the Mão leve verification agent performing a **read-check-fix** pass.

**Goal:** confirm one-time install succeeded, nothing is always-on that should
be dormant, and MCP count is zero at idle. Repair only with explicit approval.

**Out of scope:** enabling Headroom proxy/wrap, registering MCP servers,
`alwaysApply: true`, or tier activation during this pass.

Follow [`docs/supervised-setup.md`](../supervised-setup.md): run **discovery**,
present the **single approval card** (phase = verify), then run checks and fix
only after `approve` or `edit:`.

## First actions

1. Run discovery from `docs/supervised-setup.md`.
2. Present the approval card; default agents = those authorized at install (or
   active + detected harnesses if unknown).
3. Set `MAOLEVE_CHECKOUT`, read `versions.env`, `docs/token-tiers.md`, and
   `PROMPT.md`.

## Authorized agents — verification coverage

Verify **each agent the human authorized during install**. Record pass/fail per
agent and per component below.

| Agent | Caveman mirror | RTK hooks | Policy surface | Pass criteria |
| --- | --- | --- | --- | --- |
| **Codex** | `~/.codex/skills/caveman/` | `--codex` init present | `~/.codex/AGENTS.md` | Dormant Mão leve block; "when tier activated" |
| **OpenCode** | `~/.config/opencode/skills/caveman/` | `--opencode` init present | `~/.config/opencode/AGENTS.md` | Same dormant pattern |
| **Claude Code** | `~/.claude/skills/caveman/` | global init present | `~/.claude/CLAUDE.md` | Same dormant pattern |
| **Cursor IDE** | `~/.cursor/skills/caveman/` | `--agent cursor` init present | `~/.cursor/rules/maoleve.mdc` | `alwaysApply: false`; dormant wording |
| **Cursor Agents** | `~/.cursor/skills/caveman/` | `--agent cursor` init present | project `AGENTS.md` | Same dormant pattern |

For every authorized agent, verify these five files exist and have matching
frontmatter (`name: maoleve-<tier>` and `disable-model-invocation: true`):
`<native skills dir>/maoleve-{low,fast,medium,high,full}/SKILL.md`. Also verify
the shared `~/.agents/skills/` copies when installed. A bare `maoleve` must
select medium; aliases include `start maoleve <tier>` and `maoleve<tier>`.

## Verification checklist

Run each check; record **pass**, **fail**, or **skipped**. Fix failures only
after approval (re-run relevant `install.md` steps or targeted repair).

### 1. Binaries (compare to `versions.env`)

| Tool | Check | Expected |
| --- | --- | --- |
| **RTK** | `rtk --version` | Installed; version matches or warn on drift |
| **Headroom** | `headroom --version` | Binary installed; proxy/wrap **not** required at idle |
| **Serena** | `serena --version` | Binary installed; MCP **not** registered yet |

### 2. RTK hooks

Confirm RTK init hooks exist for each **authorized** agent (from install).
Hooks may be present; RTK is used **only when a tier is activated**.

### 3. Caveman vendored copy

| Path | Expected |
| --- | --- |
| `~/.agents/skills/caveman/SKILL.md` | Present (canonical vendored copy) |
| `~/.codex/skills/caveman/SKILL.md` | Present if Codex authorized |
| `~/.config/opencode/skills/caveman/SKILL.md` | Present if OpenCode authorized |
| `~/.claude/skills/caveman/SKILL.md` | Present if Claude Code authorized |
| `~/.cursor/skills/caveman/SKILL.md` | Present if Cursor IDE or Cursor Agents authorized |

Content should match `$MAOLEVE_CHECKOUT/.agents/skills/caveman/` — not from
`npx skills add`.

### 4. Headroom idle state

**Pass:** no active Headroom proxy/wrap in agent config; no `HEADROOM_*` proxy
base URL forcing always-on traffic compression.

**Fail:** wrap enabled, proxy URL set, or Headroom MCP registered without a tier
activation — offer to remove or document as manual (with approval).

### 5. MCP at idle

**Pass:** **0** MCP servers configured for token-economy tools at idle.

Inspect agent MCP config (`~/.cursor/mcp.json`, `claude mcp list`, Codex
`config.toml` `[mcp_servers.*]`, OpenCode `opencode.json` `mcp`, etc.). Flag
and offer removal (with approval):

- Serena (belongs at **high/full** activation only)
- Headroom MCP (belongs at **full** on Cursor IDE only, if needed)

Do not remove unrelated MCP the human uses for other workflows unless they
ask on the approval card.

### 6. Dormant policy templates

| Agent | Surface | Pass criteria |
| --- | --- | --- |
| Cursor IDE | `~/.cursor/rules/maoleve.mdc` | `alwaysApply: false`; "when tier activated" wording |
| Codex | `~/.codex/AGENTS.md` | Mão leve block marked; "when tier activated" / when selected |
| OpenCode | `~/.config/opencode/AGENTS.md` | Same dormant pattern |
| Claude Code | `~/.claude/CLAUDE.md` | Same dormant pattern |
| Cursor Agents | project or agreed `AGENTS.md` | Same dormant pattern |

**Fail:** `alwaysApply: true`, unconditional "always use RTK/Caveman", or missing
ownership markers (`BEGIN MAOLEVE` / `END MAOLEVE` or equivalent).

### 7. Stray global always-on rules

Scan for other rules or project files that force Mão leve tiers globally (e.g.
`token-savings.mdc` or `superpowers-mcp-router.mdc` with `alwaysApply: true`,
duplicate Caveman always-on blocks, stray `maoleve.mdc` copies with
`alwaysApply: true`). Report; do not delete without approval.

## Fix ladder (approval required)

For each failure, in order:

1. Show non-secret evidence (path, version, config key name).
2. Propose minimal fix (re-copy Caveman, merge dormant template, remove stray
   MCP entry, re-run single install step).
3. Create backup before config edits.
4. Re-run the failed check and update the report.

Do not enable proxy, MCP, or tier policy during verification unless the human
explicitly asks to **activate** a tier (use `activate-*.md` instead).

## Report shape

```text
Mão leve verification report
Session: post-install (new chat)
Platform:
Agent:
Checkout:

RTK: pass/fail — version, hooks
Headroom: pass/fail — binary only, proxy/wrap off
Serena: pass/fail — binary only, MCP off
Caveman: pass/fail — vendored paths
Policy dormant: pass/fail — per agent
MCP at idle: N (required 0)
Stray always-on rules: none / listed
Version drift vs versions.env: none / warned

Fixed (with approval):
Manual follow-up:
Next step: start daily chats with /maoleve-medium (or another tier)
```

English only. If all checks pass, tell the human they are ready for per-chat
activation. If not, list what was fixed and what still needs manual action.
