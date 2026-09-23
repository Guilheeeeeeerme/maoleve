---
name: maoleve-full
description: Activate Mão leve full for this chat. Matches /maoleve-full, start maoleve full, or maolevefull.
disable-model-invocation: true
---

Activate Mão leve **full** for this chat only. Confirm that full is active, then
continue with the user's task.

Apply high, plus consistent RTK, Headroom, Caveman, and Serena semantics across
Codex, OpenCode, Claude Code, Cursor IDE, and Cursor Agents. Document per-agent
skips; Cursor Agents skip Headroom wrap. On Cursor IDE only, Headroom MCP may be
enabled on demand when approved and when a proxy URL is not already in use.

Keep dashboard off, use versions from `versions.env`, and never add unrelated
MCP servers. This is per-chat state.

Opt-in output-filtering fallback (only when `MAOLEVE_ENABLE_LOGSTRIP=y` was
chosen at install time and only on agents without RTK hook integration — codex,
cursor-agent, cursor-ide): pipe long shell output through the pinned version once,
e.g. `cat <command output> | npx -y logstrip@MAOLEVE_LOGSTRIP_VERSION`, substituting the
pinned literal (e.g. `logstrip@1.12.0`). Never stack it on Claude Code or
OpenCode, where RTK already filters — double-compression is unmeasured. Honor
its noise flag: on a pure-noise stream it can return empty output; check it
against the raw stream before acting on an empty result.
