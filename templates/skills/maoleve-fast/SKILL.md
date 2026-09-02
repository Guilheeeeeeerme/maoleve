---
name: maoleve-fast
description: Activate Mão leve fast for this chat. Matches /maoleve-fast, start maoleve fast, or maolevefast.
disable-model-invocation: true
---

Activate Mão leve **fast** for this chat only. Confirm that fast is active, then
continue with the user's task.

Apply low, plus Headroom proxy compression when the human has started it:

- Codex: `headroom wrap codex --no-mcp`
- OpenCode: `headroom wrap opencode --no-mcp`
- Claude Code: `headroom wrap claude --no-mcp`
- Cursor IDE: `headroom wrap cursor` or its proxy URL
- Cursor Agents: skip wrap; use RTK and Caveman only, and say so

If proxy is unavailable, continue with low behavior. Do not enable Serena,
Headroom MCP, or any other MCP. This is per-chat state.
