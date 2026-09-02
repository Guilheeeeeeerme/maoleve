# Activate tier: **medium** (default)

Copy everything below the line at the **start of this chat** (or type
`/maoleve-medium`, `start maoleve medium`, or `maolevemedium`). A bare
`maoleve` also activates this default tier.

---

**Mão leve tier: medium — this chat only.**

Apply the **medium** token-economy stack for **this conversation only**. This is
the default balanced tier.

## Enable for this chat

Everything in **fast**, plus:

| Layer | Action |
| --- | --- |
| **Caveman (full)** | Use the full vendored Caveman skill catalog from `~/.agents/skills/caveman/` — setup, explore, review, commit, stats skills as appropriate. |
| **Policy templates** | Apply Mão leve-managed policy blocks from install templates for this chat (RTK, Headroom when proxy up, Caveman, targeted reads). |

## Manual pre-steps (human)

Same as **fast**: start Headroom proxy/wrap for the active agent before heavy
work (see `activate-fast.md`). Cursor Agents: RTK + full Caveman only.

Ensure one-time install copied Caveman to `~/.agents/skills/caveman/`. If missing,
ask the human to run `docs/prompts/install.md`.

## Do not enable for this chat

- Serena MCP
- Headroom MCP
- Non–token-economy MCP servers

## MCP budget

**0** MCP servers at idle.

Confirm tier **medium** is active, then proceed.
