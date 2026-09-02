# Mão leve tier install: **medium** (default)

Copy everything below the line into your coding agent.

---

You are the Mão leve setup agent installing the **medium** token-economy tier.

**Tier goal:** balanced token economy vs latency — default for most projects.

**In scope:** **fast** tier (RTK, Headroom proxy, Caveman policy) + **full
Caveman skill copy** from the Mão leve checkout and policy templates from
`templates/`.

**Out of scope:** Serena, tokensave, Headroom MCP, Speckit, Superpowers,
Firecrawl, Context7, Playwright MCP. Do not run `bin/maoleve`, `install.sh`,
or `npx skills add`.

Supervised operator rules from `PROMPT.md` apply throughout.

## First actions

1. Identify active agent (Codex, OpenCode, Cursor Agents, Cursor IDE, Claude Code).
2. Detect OS/shell; approve checkout clone/update non-destructively.
3. Set `MAOLEVE_CHECKOUT` to the Mão leve repo root. Read `PROMPT.md`, `docs/token-tiers.md`,
   `versions.env`.

## Required supervised questions

1. Inspect active harness configuration? (yes/no)
2. Discover other agents? Which are authorized?
3. Named credential sources allowed?
4. Confirm tier **medium**: RTK + Headroom proxy + vendored Caveman + policy
   templates. Skip Serena, tokensave, and non-token MCPs.

## Install steps (tier **medium**)

Complete **fast** tier steps (RTK + Headroom proxy + light Caveman policy), then:

### Copy vendored Caveman (required)

```bash
mkdir -p "$HOME/.agents/skills/caveman"
cp -a "$MAOLEVE_CHECKOUT/.agents/skills/caveman/." "$HOME/.agents/skills/caveman/"
```

For each **authorized** agent, mirror when that runtime uses a separate skill dir:

| Agent | Also copy to |
| --- | --- |
| Cursor IDE / Cursor Agents | `~/.cursor/skills/caveman/` |
| Codex | `~/.codex/skills/caveman/` |
| Claude Code | `~/.claude/skills/caveman/` |

### Copy policy templates (merge, do not overwrite user harness)

| Agent | Template → target |
| --- | --- |
| Codex | `templates/codex/AGENTS.md` → `~/.codex/AGENTS.md` |
| OpenCode | `templates/opencode/AGENTS.md` → `~/.config/opencode/AGENTS.md` |
| Claude Code | `templates/claude/CLAUDE.md` → `~/.claude/CLAUDE.md` |
| Cursor IDE | `templates/cursor/maoleve.mdc` → `~/.cursor/rules/maoleve.mdc` |
| Cursor Agents | `templates/cursor-agent/AGENTS.md` → project `AGENTS.md` or agreed path |

Mark merged blocks `BEGIN MAOLEVE` / `END MAOLEVE`. Show diff before ambiguous edits.

### Headroom reminder

- **Codex / OpenCode / Claude:** proxy/wrap with `--no-mcp`. No Headroom MCP.
- **Cursor Agents:** RTK + policy + vendored Caveman; skip Headroom wrap.

### Explicitly skip

- tokensave, Serena, Headroom MCP, Speckit, Superpowers, Firecrawl, Context7,
  Playwright, legacy `maoleve apply`

## Post-install verification

```text
Create a concise Mão leve tier-medium post-install report.

1. Platform, shell, checkout, active agent.
2. rtk --version; headroom --version
3. Confirm Caveman copied to ~/.agents/skills/caveman (and agent mirror paths).
4. Confirm Serena, tokensave, Headroom MCP NOT configured.
5. Compare tool versions to versions.env.

Shape:

Mão leve tier-medium report
Platform:
Shell:
Checkout:
Active agent:
RTK:
Headroom proxy:
Caveman vendored copy: ok/missing
Policy templates: merged/skipped
Serena: skipped by design
tokensave: skipped by design
Headroom MCP: skipped by design
Credentials preserved: yes/no
Manual actions:
Failures:
```

English only. Report installed/reused/skipped/manual/failed.
