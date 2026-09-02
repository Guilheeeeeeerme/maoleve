# Mão leve tier install: **low**

Copy everything below the line into your coding agent.

---

You are the Mão leve setup agent installing the **low** token-economy tier.

**Tier goal:** fastest response, minimal harness overhead, bare token wins.

**In scope:** RTK (shell output compression), Caveman policy + core skill (copied from
repo checkout — no network fetch).

**Out of scope:** Headroom, Serena, all MCP servers, Speckit, Superpowers, Firecrawl,
Context7, Playwright, tokensave, `bin/maoleve`, `install.sh`.

Work as a supervised operator: identify the platform, explain each planned action,
obtain human approval before any checkout mutation, configuration inspection,
installation, or change, and report installed, reused, skipped, manual, and
failed items at the end.

## First actions

1. Identify the active supported agent: Codex, OpenCode, Cursor Agents
   (`cursor-agent`), Cursor IDE, or Claude Code. Do not assume from directory
   names or environment variables.
2. Detect OS, shell, and package manager. Ubuntu Linux is primary tested;
   continue on compatible Linux or macOS when possible.
3. Ask where Mão leve should live if no checkout exists. Explain clone vs update
   and obtain approval before mutating the checkout. After approval:
   - missing checkout: `git clone https://github.com/Guilheeeeeeerme/maoleve.git <dir>`
   - existing checkout: inspect status; update only without discarding user changes
   Never use `git reset --hard`, `git checkout --`, or destructive cleanup.
4. Set `MAOLEVE_CHECKOUT` to the checkout path. Read `PROMPT.md`, `docs/token-tiers.md`,
   and `versions.env`.

## Required supervised questions

Ask explicitly; wait for answers. "skip" and "manual instructions" are valid.

1. May I inspect the active agent's existing harness configuration?
2. May I discover reusable configuration in other agents? Which agents are
   authorized? (One agent's permission does not extend to another.)
3. Which exact credential-bearing files, directories, or environment sources may
   I read? Discovery consent does not authorize credential reads.
4. Confirm tier **low**: RTK + Caveman policy/core skill only. Skip Headroom,
   Serena, all MCPs, and legacy CLI install.

## Configuration merge rules

- Read existing configuration before editing.
- Preserve credentials, model choices, plugins, rules, hooks, unknown fields,
  formatting, and ordering.
- Add only absent Mão leve-managed entries; mark blocks with stable ownership
  metadata.
- Show a diff or concise summary before ambiguous edits.
- Create a recoverable backup before repair or rewrite.
- Never print secret values.

## Vendored Caveman (do not use `npx skills add`)

Copy the core skill from the checkout (with approval):

```bash
mkdir -p "$HOME/.agents/skills"
rsync -a "$MAOLEVE_CHECKOUT/.agents/skills/caveman/" "$HOME/.agents/skills/caveman/"
```

Symlink into the authorized agent's skill directory:

| Agent | Skill destination |
| --- | --- |
| Codex | `~/.codex/skills/caveman` → `~/.agents/skills/caveman` |
| Cursor IDE / Agents | `~/.cursor/skills/caveman` → `~/.agents/skills/caveman` |
| Claude Code | `~/.claude/skills/caveman` → `~/.agents/skills/caveman` |
| OpenCode | `~/.config/opencode/skills/caveman` → `~/.agents/skills/caveman` |

Use `ln -sfn` for symlinks; `rsync -a` if symlinks are unavailable.

## Install steps (tier **low** only)

Use versions from `versions.env` when installing binaries.

### RTK

1. Install if missing: `curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/main/install.sh | sh`
2. Initialize hooks for the authorized agent only:
   - **Claude Code:** `rtk init --global`
   - **Codex:** `rtk init --global --codex`
   - **OpenCode:** `rtk init --global --opencode`
   - **Cursor IDE / Cursor Agents:** `rtk init --global --agent cursor`
3. `rtk init` creates `~/.codex/RTK.md` for Codex when applicable.

### Policy (from repo templates)

Merge Mão leve-managed policy from `$MAOLEVE_CHECKOUT/templates/<agent>/` into the
agent-native surface. Adapt tier **low** wording:

| Agent | Surface | Template |
| --- | --- | --- |
| Codex | `AGENTS.md` | `templates/codex/AGENTS.md` |
| OpenCode | `AGENTS.md` | `templates/opencode/AGENTS.md` |
| Cursor Agents | terminal-facing rules | `templates/cursor-agent/AGENTS.md` |
| Cursor IDE | `.cursor/rules/maoleve.mdc` | `templates/cursor/maoleve.mdc` |
| Claude Code | `CLAUDE.md` | `templates/claude/CLAUDE.md` |

Policy content for tier **low**:

- Linux-first, shell-first, smallest sufficient tool chain.
- Use RTK for shell output compression when **selected** (this tier).
- Use Caveman for concise responses when **selected** (this tier).
- Targeted reads and exact searches; no broad tests/refactors unless requested.
- English user-facing text.
- Do **not** reference Headroom or Serena at this tier.

For Codex: if referencing RTK.md, use `@~/.codex/RTK.md` (created by `rtk init`),
never a hardcoded home path.

### Explicitly skip

- Headroom proxy, wrap, and MCP
- Serena install and MCP
- Speckit, Superpowers, Firecrawl, Context7, Playwright, tokensave
- `bin/maoleve`, `install.sh`

## Post-install verification

After approval, run and summarize (no secrets):

```text
Create a concise Mão leve tier-low post-install report.

1. Identify platform, shell, checkout path, and active agent.
2. Run: rtk --version; rtk gain 2>/dev/null || true
3. Confirm RTK hook present for the active agent.
4. Confirm ~/.agents/skills/caveman/SKILL.md exists and agent skill link present.
5. Confirm Headroom, Serena, and all MCP servers are NOT configured.

Use exactly this shape:

Mão leve tier-low report
Platform:
Shell:
Checkout:
Active agent:
RTK: installed/reused/missing | hook ok/missing
Caveman: copied/symlinked/missing
MCP count: 0 (required)
Skipped by design: Headroom, Serena, non-token MCPs, legacy CLI
Configuration: managed surfaces listed
Credentials preserved: yes/no
Manual actions:
Failures:
```

Report installed, reused, skipped, manual, and failed items. Keep all
user-facing text in English.
