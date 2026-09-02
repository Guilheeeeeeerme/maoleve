# Mão leve tier install: **full**

Copy everything below the line into your coding agent.

---

You are the Mão leve setup agent installing the **full** token-economy tier.

**Tier goal:** maximum local token economy, consistent policy across all
authorized agents.

**In scope:** **high** tier + Headroom MCP on **Cursor IDE only** when proxy
base URL is not already configured + all policy templates for every authorized
agent.

**Out of scope:** tokensave, Speckit, Superpowers, Firecrawl, Context7,
Playwright. Do **not** use `bin/maoleve apply`, `install.sh`, or blast-install.

Follow `PROMPT.md` supervised operator rules entirely.

## First actions

1. Identify active agent and which additional agents the human authorizes.
2. Detect OS/shell; approve checkout clone/update. Set `MAOLEVE_CHECKOUT` to repo root.
3. Read `PROMPT.md`, `docs/token-tiers.md`, `versions.env`.

## Required supervised questions

1. Inspect harness for each authorized agent?
2. Discover other agents? Which specifically?
3. Named credential sources?
4. Confirm tier **full**: high stack + Cursor IDE Headroom MCP only if proxy URL
   not set. Skip tokensave and non-token MCPs.

## Install steps (tier **full**)

### 1. Complete **high** tier for each authorized agent

RTK, Headroom proxy (`--no-mcp` on Codex/OpenCode/Claude), vendored Caveman,
policy templates, Serena MCP with dashboard off.

### 2. Headroom MCP — Cursor IDE only (optional)

Add to `~/.cursor/mcp.json` **only if** Cursor is not already using Headroom
proxy base URL and the human approves:

```json
"headroom": {
  "command": "$HOME/.local/bin/headroom",
  "args": ["mcp", "serve", "--proxy-url", "http://127.0.0.1:8787"]
}
```

Never add Headroom MCP to Codex when proxy provider is active.

### 3. Multi-agent consistency

For each authorized agent, ensure:

| Agent | Proxy | MCP |
| --- | --- | --- |
| Codex | `headroom wrap codex --no-mcp` | Serena only |
| OpenCode | `headroom wrap opencode --no-mcp` | Serena only |
| Claude Code | `headroom wrap claude --no-mcp` | Serena only |
| Cursor IDE | proxy URL or wrap | Serena + optional Headroom MCP |
| Cursor Agents | skip wrap | Serena only if authorized; keep MCP count ≤2 |

### 4. Environment defaults (merge)

```bash
HEADROOM_MODE=token
HEADROOM_SAVINGS_PROFILE=coding
HEADROOM_TOOL_SEARCH=1
```

Merge into shell profile or agent env file; never print secrets.

### Explicitly skip

- tokensave, Playwright, Context7, Firecrawl, Speckit, Superpowers
- `bin/maoleve`, `maoleve apply`, `maoleve claude`

## Post-install verification

```text
Create a concise Mão leve tier-full post-install report.

1. Platform, shell, checkout, all authorized agents.
2. rtk --version; headroom --version; serena --version
3. Per agent: proxy status, MCP names only (no secrets)
4. Codex: Headroom proxy yes, Headroom MCP absent
5. tokensave absent everywhere
6. Compare versions to versions.env

Shape:

Mão leve tier-full report
Platform:
Shell:
Checkout:
Authorized agents:
  Codex: ...
  OpenCode: ...
  Cursor Agents: ...
  Cursor IDE: ...
  Claude Code: ...
Versions:
  tool | supported | installed | status
Token stack per agent:
  RTK / Headroom proxy / Caveman copy / Serena / Headroom MCP (Cursor only)
Skipped: tokensave, Speckit, Superpowers, Firecrawl, Context7, Playwright
Credentials preserved: yes/no
Manual actions:
Failures:
```

English only.
