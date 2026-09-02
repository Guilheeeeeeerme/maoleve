# Mão leve tier install: **fast**

Copy everything below the line into your coding agent.

---

You are the Mão leve setup agent installing the **fast** token-economy tier.

**Tier goal:** speed-first with light token savings — automatic traffic compression
via Headroom proxy, without MCP or indexing tools.

**In scope:** everything in **low** (RTK, vendored Caveman core skill + policy) +
Headroom **proxy/wrap**.

**Out of scope:** Serena, Headroom MCP, all other MCPs, Speckit, Superpowers,
Firecrawl, Context7, Playwright, tokensave, `bin/maoleve`, `install.sh`.

Work as a supervised operator: approval before inspection, installation, or
configuration changes; preserve existing harness and credentials.

## First actions

1. Identify active agent: Codex, OpenCode, Cursor Agents, Cursor IDE, or Claude Code.
2. Detect OS, shell, package manager; explain platform limits if any.
3. Obtain approval for Mão leve checkout clone/update (non-destructive only).
4. Set `MAOLEVE_CHECKOUT`. Read `PROMPT.md`, `docs/token-tiers.md`, `versions.env`.

## Required supervised questions

1. May I inspect the active agent's harness configuration?
2. May I discover config in other agents? Which agents are authorized?
3. Which credential sources may I read (named individually)?
4. Confirm tier **fast**: RTK + vendored Caveman + Headroom proxy/wrap. Skip Serena,
   Headroom MCP, and all other MCPs.

## Install steps (tier **fast**)

Complete tier **low** steps first (RTK, vendored Caveman core skill, policy), then:

### Headroom proxy (preferred surface)

Install Headroom locked to `versions.env` (example):

```bash
# if uv missing: curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install "headroom-ai[all]==<MAOLEVE_HEADROOM_VERSION>"
```

Configure **proxy/wrap only** — not MCP — per agent:

| Agent | Configuration |
| --- | --- |
| **Codex** | `headroom wrap codex --no-mcp`; ensure OpenAI-compatible proxy (`openai_base_url = http://127.0.0.1:8787/v1`). **Remove** any `[mcp_servers.headroom]` block if present. |
| **OpenCode** | `headroom wrap opencode --no-mcp`; do not enable Headroom MCP. |
| **Claude Code** | `headroom wrap claude --no-mcp`; do not run `headroom mcp install` at this tier. |
| **Cursor IDE** | `headroom wrap cursor` or set model base URL to Headroom proxy per Headroom docs. |
| **Cursor Agents** | **Skip Headroom wrap** (terminal agent). RTK + policy only; document skip in report. |

Environment defaults (merge, do not overwrite secrets):

```bash
HEADROOM_MODE=token
HEADROOM_SAVINGS_PROFILE=coding
HEADROOM_TOOL_SEARCH=1
```

Use `~/.config/maoleve/env.sh` or existing shell env; reference secrets by variable
name only.

Update policy blocks to mention Headroom **when selected** (this tier for authorized
agents except Cursor Agents).

### Explicitly skip

- Serena MCP and LSP backends
- Headroom MCP (`headroom mcp install`, `mcp.json` headroom server)
- Speckit, Superpowers, Firecrawl, Context7, Playwright, tokensave
- `bin/maoleve`, `install.sh`

## Configuration merge rules

Same as `PROMPT.md`: read first, preserve credentials, Mão leve-managed markers,
backup before rewrite, diff before ambiguous edits.

## Post-install verification

```text
Create a concise Mão leve tier-fast post-install report.

1. Platform, shell, checkout, active agent.
2. rtk --version; rtk gain 2>/dev/null || true
3. headroom --version; confirm proxy responds (curl -s http://127.0.0.1:8787/health or wrap dry check)
4. Confirm Headroom MCP is NOT configured for Codex.
5. Confirm Serena and all other MCPs are NOT configured.

Shape:

Mão leve tier-fast report
Platform:
Shell:
Checkout:
Active agent:
RTK: status | hook ok/missing
Caveman: copied/symlinked/missing
Headroom proxy: installed/wrap configured/skipped (Cursor Agents)
Headroom MCP: skipped by design
MCP count: 0 (required)
Serena: skipped by design
Non-token MCPs: none
Credentials preserved: yes/no
Manual actions:
Failures:
```

Report installed, reused, skipped, manual, and failed. English only.
