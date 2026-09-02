# Mão leve tier install: **high**

Copy everything below the line into your coding agent.

---

You are the Mão leve setup agent installing the **high** token-economy tier.

**Tier goal:** aggressive token savings; accepts Serena indexing and one MCP slot.

**In scope:** **medium** tier + **Serena** MCP with web dashboard disabled.

**Out of scope:** tokensave, Headroom MCP (unless human requests **full** tier),
Speckit, Superpowers, Firecrawl, Context7, Playwright. No `bin/maoleve`.

Supervised operator: approval gates, credential safety, merge rules from
`PROMPT.md`.

## First actions

1. Identify active agent.
2. Detect OS/shell; approve checkout clone/update. Set `MAOLEVE_CHECKOUT` to repo root.
3. Read `PROMPT.md`, `docs/token-tiers.md`, `versions.env`.

## Required supervised questions

1. Inspect active harness? Discover other agents (which)?
2. Named credential sources allowed?
3. Confirm tier **high**: medium stack + Serena only. Skip tokensave and
   non-token MCPs.

## Install steps (tier **high**)

Complete **medium** tier first, then:

### Serena MCP (dashboard off)

Install at locked version:

```bash
uv tool install -p 3.13 "serena-agent==<MAOLEVE_SERENA_VERSION>"
```

Register MCP with `--open-web-dashboard False` and agent context:

| Agent | Serena launch |
| --- | --- |
| **Claude Code** | `claude mcp add --scope user serena -- "$HOME/.local/bin/uvx" --from "serena-agent==<MAOLEVE_SERENA_VERSION>" serena start-mcp-server --project-from-cwd --context claude-code --open-web-dashboard False` |
| **Codex** | `[mcp_servers.serena]` with `uvx --from serena-agent==<version>`, `--context codex --open-web-dashboard False` |
| **OpenCode** | `"serena"` MCP via `serena-agent==<version>`, `--context agent --open-web-dashboard False`, `enabled: true` |
| **Cursor IDE** | `~/.cursor/mcp.json` with pinned `serena-agent==<version>`, `--context ide --open-web-dashboard False` |
| **Cursor Agents** | Only if human authorizes shared MCP; prefer disabling when not doing symbol work |

Policy (Mão leve-managed): use Serena for symbol navigation and refactors;
prefer `grep`/`read` on small repos.

### Explicitly skip

- tokensave (legacy; overlaps Serena; heavy MCP schema)
- Headroom MCP (full tier / Cursor IDE only)
- Speckit, Superpowers, Firecrawl, Context7, Playwright

## Post-install verification

```text
Create a concise Mão leve tier-high post-install report.

1. Platform, shell, checkout, active agent.
2. rtk --version; headroom --version; serena --version
3. Serena MCP listed; confirm --open-web-dashboard False in args
4. Confirm tokensave and Headroom MCP NOT configured
5. Compare versions to versions.env

Shape:

Mão leve tier-high report
Platform:
Shell:
Checkout:
Active agent:
RTK:
Headroom proxy:
Caveman vendored copy:
Serena: MCP ok/missing | dashboard disabled confirmed
tokensave: skipped by design
Headroom MCP: skipped by design
Credentials preserved: yes/no
Manual actions:
Failures:
```

English only.
