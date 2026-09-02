# Activate tier: **high**

Copy everything below the line at the **start of this chat** (or type
`/maoleve-high`, `start maoleve high`, or `maolevehigh`).

---

**Mão leve tier: high — this chat only.**

Apply the **high** token-economy stack for **this conversation only**.

## Enable for this chat

Everything in **medium**, plus:

| Layer | Action |
| --- | --- |
| **Serena MCP** | Use Serena for symbol-level navigation, `find_symbol`, references, and surgical edits on medium/large codebases. Prefer Serena over whole-file reads when symbols suffice. Dashboard must stay off. |

## Manual pre-steps (human)

1. **Headroom proxy** — same as **fast** (start wrap/proxy for this session).
2. **Serena MCP** — ensure Serena is registered and running for this agent with
   `--open-web-dashboard False`. If not registered, ask approval then register
   (install prompt prepared the binary only):

   | Agent | Registration hint |
   | --- | --- |
   | **Claude Code** | `claude mcp add --scope user serena -- uvx --from serena-agent==<version> serena start-mcp-server --project-from-cwd --context claude-code --open-web-dashboard False` |
   | **Codex** | `[mcp_servers.serena]` with pinned `serena-agent`, `--context codex --open-web-dashboard False` |
   | **OpenCode** | `"serena"` MCP entry, `--context agent --open-web-dashboard False` |
   | **Cursor IDE** | `~/.cursor/mcp.json`, `--context ide --open-web-dashboard False` |
   | **Cursor Agents** | Only if human authorizes; prefer disabling when not doing symbol work |

Use versions from `versions.env`.

## Do not enable for this chat

- Headroom MCP (full tier / Cursor IDE only)
- Non–token-economy MCP servers (Playwright, etc.)
- Extra MCP servers beyond Serena

## MCP budget

**1** MCP at idle (Serena). Keep tool-schema tax low; disable Serena when doing
non-code work if the human prefers.

On small repos, prefer grep/read over Serena indexing overhead.

Confirm tier **high** is active, then proceed.
