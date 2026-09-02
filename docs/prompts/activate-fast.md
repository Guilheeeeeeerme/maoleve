# Activate tier: **fast**

Copy everything below the line at the **start of this chat** (or type
`/maoleve-fast`, `start maoleve fast`, or `maolevefast`).

---

**Mão leve tier: fast — this chat only.**

Apply the **fast** token-economy stack for **this conversation only**.

## Enable for this chat

Everything in **low**, plus:

| Layer | Action |
| --- | --- |
| **Headroom proxy** | Route model traffic through Headroom compression when the human has started the proxy for this session. |

## Manual pre-steps (human)

Before or at chat start, the human should start Headroom proxy/wrap for their agent
(one of):

| Agent | Command |
| --- | --- |
| **Codex** | `headroom wrap codex --no-mcp` (OpenAI-compatible proxy at `http://127.0.0.1:8787/v1`) |
| **OpenCode** | `headroom wrap opencode --no-mcp` |
| **Claude Code** | `headroom wrap claude --no-mcp` |
| **Cursor IDE** | `headroom wrap cursor` or set model base URL to Headroom proxy |
| **Cursor Agents** | Skip wrap — use RTK + Caveman only; note skip in first reply |

Do **not** enable Headroom MCP at this tier.

## Do not enable for this chat

- Serena or other MCP servers
- Full Caveman skill catalog (medium+)
- Headroom MCP

## MCP budget

**0** MCP servers. Proxy only.

If proxy is not running, tell the human and continue with **low** behavior until
they start it.

Confirm tier **fast** is active, then proceed.
