# Activate tier: **full**

Copy everything below the line at the **start of this chat** (or type `/maoleve-full` or `maoleve-full`).

---

**Mão leve tier: full — this chat only.**

Apply the **full** token-economy stack for **this conversation only**.

## Enable for this chat

Everything in **high**, plus:

| Layer | Action |
| --- | --- |
| **Multi-agent consistency** | When the human works across Codex, OpenCode, Claude Code, Cursor IDE, or Cursor Agents in one session, keep the same tier semantics: RTK + proxy + Caveman + Serena; document per-agent skips (e.g. Cursor Agents no wrap). |
| **Headroom MCP (Cursor IDE only)** | On-demand MCP compression in Cursor IDE **only if** the human enabled it and proxy base URL is not already set. Never add Headroom MCP to Codex when proxy provider is active. |

## Manual pre-steps (human)

1. **Headroom proxy** — start wrap/proxy per agent (see `activate-fast.md`).
2. **Serena MCP** — running with dashboard off (see `activate-high.md`).
3. **Headroom MCP (optional, Cursor IDE only)** — if approved and not using proxy
   URL alone, add to `~/.cursor/mcp.json`:

   ```json
   "headroom": {
     "command": "$HOME/.local/bin/headroom",
     "args": ["mcp", "serve", "--proxy-url", "http://127.0.0.1:8787"]
   }
   ```

## MCP budget

**≤2** MCP at idle (typically Serena + optional Headroom on Cursor IDE).
Codex/OpenCode/Claude: Serena only; Headroom via proxy, not MCP.

## Do not enable for this chat

- tokensave, Playwright MCP, blast-install MCP lists
- Headroom MCP on Codex when proxy is configured

Confirm tier **full** is active, then proceed.
