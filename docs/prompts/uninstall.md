# Mão leve uninstall

Copy everything below the line into your coding agent when you want to **remove
a prompt-only Mão leve install** — the same artifacts [`install.md`](./install.md)
creates. This undoes dormant policies, vendored Caveman copies, RTK hooks, and
optional install-time env defaults.

---

You are the Mão leve setup agent performing a **prompt-only uninstall**.

**Goal:** reverse a one-time install from [`install.md`](./install.md) so the
machine no longer has Mão leve-managed dormant policy, vendored Caveman trees,
or RTK hooks. Binaries (RTK, Headroom, Serena) are removed only when the human
explicitly approves.

**In scope:** Mão leve-managed policy blocks, Caveman vendored copies and
mirrors (including symlinks), RTK hooks per authorized agent, optional
`~/.config/maoleve/env.sh` defaults added during install.

**Out of scope:** always-on tier rules not created by install, npx skills
unrelated to install, deleting entire agent config directories, removing the
Mão leve checkout, removing unrelated MCP or rules the human uses for other
projects.

**Idempotent:** safe to re-run. For each component, detect what is present;
**skip** when already absent. Never delete whole config files — remove only
Mão leve-owned blocks, symlinks, hooks, and skill trees from install.

Follow [`docs/supervised-setup.md`](../supervised-setup.md): run **discovery**,
present the **single approval card** (phase = uninstall), then remove artifacts
only after `approve` or `edit:`. Report removed, skipped, preserved, manual,
and failed items at the end.

## First actions

1. Run discovery from `docs/supervised-setup.md`.
2. Present the approval card; default agents = active + detected harnesses unless
   the human names the install set. Include `Remove binaries: no` unless edited.
3. Locate checkout if present; read `docs/prompts/install.md`, `PROMPT.md`, and
   `versions.env` to distinguish remove vs preserve.

## Supported agents — uninstall coverage

Reverse **each agent the human authorized during install**. One agent's
permission does not extend to another. For every authorized agent, uninstall
applies the rows below.

| Agent | Caveman mirror | RTK hooks | Policy merge target | Template reference |
| --- | --- | --- | --- | --- |
| **Codex** | `~/.codex/skills/caveman/` | `rtk init --global --codex --uninstall` | `~/.codex/AGENTS.md` | `templates/codex/AGENTS.md` |
| **OpenCode** | `~/.config/opencode/skills/caveman/` | `rtk init --global --opencode --uninstall` | `~/.config/opencode/AGENTS.md` | `templates/opencode/AGENTS.md` |
| **Claude Code** | `~/.claude/skills/caveman/` | `rtk init --global --uninstall` | `~/.claude/CLAUDE.md` | `templates/claude/CLAUDE.md` |
| **Cursor IDE** | `~/.cursor/skills/caveman/` | `rtk init --global --agent cursor --uninstall` | `~/.cursor/rules/maoleve.mdc` | `templates/cursor/maoleve.mdc` |
| **Cursor Agents** | `~/.cursor/skills/caveman/` | `rtk init --global --agent cursor --uninstall` | project `AGENTS.md` (or path human confirms) | `templates/cursor-agent/AGENTS.md` |

Shared for all authorized agents:

- `~/.agents/skills/caveman/` — canonical vendored copy (step 1)
- RTK hooks (step 2) — remove only Mão leve init artifacts
- Headroom and Serena binaries (steps 3–4) — optional; human must approve each

Cursor IDE and Cursor Agents are **separate targets** — uninstall both only when
both were authorized during install.

## Configuration removal rules

- Read existing configuration before editing.
- Preserve credentials, model choices, plugins, rules, hooks, unknown fields,
  formatting, and ordering outside Mão leve-owned blocks.
- Remove only blocks marked with stable ownership metadata (`BEGIN MAOLEVE` /
  `END MAOLEVE`) or files that are exclusively Mão leve install symlinks/copies
  (e.g. `maoleve.mdc` from install template).
- If a file is a symlink to `$MAOLEVE_CHECKOUT/templates/...`, remove the symlink
  only — do not delete the checkout template.
- Show a diff or concise summary before ambiguous edits.
- Create a recoverable backup before removal or rewrite.
- Never print secret values.

## Uninstall steps

Perform in order. Skip steps when targets are already absent.

### 1. Vendored Caveman (reverse install step 1)

Remove Mão leve vendored trees copied or symlinked during install. Do **not**
remove Caveman installed by other means unless the human confirms.

For each **authorized** agent, remove the mirror path if it points at or copies
from `$MAOLEVE_CHECKOUT/.agents/skills/caveman/`:

| Agent | Mirror path |
| --- | --- |
| Codex | `~/.codex/skills/caveman/` |
| OpenCode | `~/.config/opencode/skills/caveman/` |
| Claude Code | `~/.claude/skills/caveman/` |
| Cursor IDE | `~/.cursor/skills/caveman/` |
| Cursor Agents | `~/.cursor/skills/caveman/` (shared with Cursor IDE when both authorized) |

If a mirror is a symlink to the checkout, `rm` the symlink only. If a directory
copy, remove the tree after confirming it matches install (not user-authored
skills).

Remove the canonical copy when present and install-sourced:

```bash
rm -rf "$HOME/.agents/skills/caveman"
```

Optionally remove extended catalog copies from the same install
(`~/.agents/skills/caveman-*`) only when the human confirms they came from the
Mão leve checkout copy — not from `npx skills add` or other projects.

### 2. RTK hooks (reverse install step 2)

For each **authorized** agent, remove RTK init artifacts when present (with
approval):

- **Claude Code:** `rtk init --global --uninstall`
- **Codex:** `rtk init --global --codex --uninstall`
- **OpenCode:** `rtk init --global --opencode --uninstall`
- **Cursor IDE:** `rtk init --global --agent cursor --uninstall`
- **Cursor Agents:** `rtk init --global --agent cursor --uninstall` (same target as Cursor IDE)

After uninstall, verify with `rtk init --show` (or agent-native hook inspection)
that Mão leve RTK hooks are gone. Do **not** remove RTK binary unless step 5
(binary removal) is explicitly approved.

Remove RTK reference blocks from agent policy files only when they are inside
Mão leve-managed sections or were added solely by install merge (show diff first).

### 3. Headroom (reverse install step 3)

**Default:** leave the Headroom binary installed unless the human approved binary
removal on the approval card (`Remove binaries: yes`).

If approved and `headroom` was installed via uv for Mão leve:

```bash
uv tool uninstall headroom-ai
```

Remove optional non-secret defaults from `~/.config/maoleve/env.sh` only when
the file contains Mão leve install defaults (`HEADROOM_MODE`, etc.) and no
unrelated user content would be lost — merge-preserving edit or remove file if
install-only. Never delete secret values; reference by variable name only.

Do **not** remove Headroom proxy/wrap or Headroom MCP here unless they were
enabled by a tier activation in the current session — those belong to
activation teardown, not install uninstall. If idle proxy/MCP from an old tier
session is found, report and offer separate cleanup with approval.

### 4. Serena (reverse install step 4)

**Default:** leave the Serena binary installed unless the human approved binary
removal.

If approved:

```bash
uv tool uninstall serena-agent
```

Do **not** remove Serena MCP registration here unless it was added during a
tier activation the human wants torn down — install.md does not register MCP.
Report stray Serena/Headroom MCP; offer removal only with explicit approval.

### 5. Dormant policy templates (reverse install step 5)

Remove Mão leve-managed policy merged from `$MAOLEVE_CHECKOUT/templates/<agent>/`
during install. Remove `BEGIN MAOLEVE` … `END MAOLEVE` blocks or the whole file
when the file is exclusively an install symlink/copy:

| Agent | Merge target | Action |
| --- | --- | --- |
| Codex | `~/.codex/AGENTS.md` | Remove Mão leve block or symlink to template |
| OpenCode | `~/.config/opencode/AGENTS.md` | Same |
| Claude Code | `~/.claude/CLAUDE.md` | Same |
| Cursor IDE | `~/.cursor/rules/maoleve.mdc` | Remove file or symlink |
| Cursor Agents | project `AGENTS.md` (confirm path) | Remove Mão leve block only |

For OpenCode, if install added an `instructions` entry pointing at merged
`AGENTS.md`, remove or restore only the Mão leve-owned entry — do not wipe
unrelated MCP or plugin settings.

### 6. Optional binary removal (RTK)

Only when the human explicitly approved removing RTK binary in supervised
questions. Follow upstream RTK uninstall instructions; do not guess paths.

### Explicitly skip during uninstall

- Always-on global rules not created by install.md merge
- Entire agent config directories
- The Mão leve checkout clone
- Unrelated user MCP, skills, or rules

## Post-uninstall (this session)

After approval, run and summarize (no secrets):

```text
Create a concise Mão leve prompt-only uninstall report.

1. Platform, shell, checkout path, authorized agents.
2. Caveman: canonical + mirrors removed/skipped
3. RTK hooks: removed/skipped per agent; binary removed/skipped
4. Headroom: binary removed/skipped; env defaults trimmed/skipped
5. Serena: binary removed/skipped
6. Policy: Mão leve blocks/symlinks removed per agent
7. Preserved (unrelated config, checkout, non-Mão-leve MCP)

Shape:

Mão leve uninstall report
Platform:
Shell:
Checkout:
Authorized agents:
Caveman: removed/skipped — paths
RTK hooks: removed/skipped per agent
RTK binary: removed/skipped/not requested
Headroom: binary removed/skipped; env defaults trimmed/skipped
Serena: binary removed/skipped/not requested
Policy templates: removed/skipped — per agent
Preserved (unrelated):
Skipped (already absent):
Manual actions:
Failures:
```

Report removed, skipped, preserved, manual, and failed items. English only.
