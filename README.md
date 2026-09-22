# Mão leve

<p align="center">
  <img src="assets/maoleve-mark.svg?v=2" alt="Mão leve mark" width="128">
</p>

<h2 align="center">Do more with less.</h2>

<p align="center">
  <code>maoleve</code> (<i>mow-LEH-vee</i>) is Portuguese for <i>mão leve</i> —
  literally, “light hand.”
</p>

<p align="center">
  A delicate, skillful touch for coding agents: remove excess without
  disturbing what matters.
</p>

<p align="center">
  <a href="#start-here">Start here</a> ·
  <a href="docs/token-tiers.md">Tier guide</a> ·
  <a href="docs/README.md">Full guide</a>
</p>

Mão leve is a **prompt-only** setup layer for coding agents. One-time install
prepares tooling on disk plus dormant policy; activation prompts apply a
token-economy tier per chat only. Everything installs through one deterministic
script (`scripts/maoleve.sh`) — no manual config edits, no surprise downgrades,
manifest-backed uninstall.

Tested primarily on Ubuntu Linux; compatible Linux and macOS are best-effort.

## Start here

1. **Install** — paste [`docs/prompts/install.md`](docs/prompts/install.md)
   once. It clones/locates the checkout and runs `scripts/maoleve.sh install`,
   which shows a single approval card and installs only what the agent session
   agrees to.
2. **Activate a tier each chat** — paste an activation prompt (or slash
   command) as the first message. Full pick guide with
   pros / cons / caveats and recommended tiers:
   [`docs/token-tiers.md`](docs/token-tiers.md).

| Tier | One-liner | Slash command | Activation prompt |
| --- | --- | --- | --- |
| **low** | RTK + Caveman, zero MCP | `/maoleve-low` | [activate-low.md](docs/prompts/activate-low.md) |
| **fast** | low + Headroom proxy | `/maoleve-fast` | [activate-fast.md](docs/prompts/activate-fast.md) |
| **medium** | fast + full Caveman (**default**) | `/maoleve-medium` | [activate-medium.md](docs/prompts/activate-medium.md) |
| **high** | medium + Serena MCP | `/maoleve-high` | [activate-high.md](docs/prompts/activate-high.md) |
| **full** | high + multi-agent consistency | `/maoleve-full` | [activate-full.md](docs/prompts/activate-full.md) |

Aliases without a slash work too: `maoleve-fast`, `start maoleve fast`.

## Right away if anything misbehaves

- Paste [`docs/prompts/status.md`](docs/prompts/status.md) to audit + doctor
  pass (read-only).
- Paste [`docs/prompts/uninstall.md`](docs/prompts/uninstall.md) to back out
  cleanly — it reverses exactly what install recorded with a confirmed
  *"Mão leve fully removed: yes."* verdict.

## What install configures

`scripts/maoleve.sh install` prepares the same stack on disk for your running
agent: dormant policy blocks (per-chat activation only), skill links, and the
token-economy binaries that are missing.

| Agent | Skill dir | Dormant policy block | rtk hooks |
| --- | --- | --- | --- |
| **Codex** | `~/.codex/skills/` | `~/.codex/AGENTS.md` | opt-in (`--hooks`) |
| **OpenCode** | `~/.config/opencode/skills/` | `~/.config/opencode/AGENTS.md` | auto |
| **Claude Code** | `~/.claude/skills/` | `~/.claude/CLAUDE.md` | auto |
| **Cursor IDE** | `~/.cursor/skills/` | `~/.cursor/rules/maoleve.mdc` | opt-in (`--hooks`) |
| **Cursor Agents** | `~/.cursor/skills/` | project `AGENTS.md` | opt-in (`--hooks`) |

Codex / Cursor hooks are **opt-in by default** because they were observed as a
crash source. `claude-code` / `opencode` get hooks on by default. Headroom
proxy/wrap, Serena MCP registration, and always-on rules are never enabled by
install — those are part of tier activation.

## The Mão leve approach

- **Respect your environment.** Existing versions are left alone when they are
  at or above the `versions.env` floor; below-floor versions are reported for
  manual upgrade; missing binaries are offered, never forced.
- **Save tokens without losing quality.** Tiers let you pick RTK/Headroom/Caveman/Serena layers per chat, with documented tradeoffs — not one big hammer.
- **Your configs stay yours.** Policy blocks are clearly marked, dormant, and
  reversibly merged. Uninstall reads what install wrote from the manifest; no
  guessing afterward.
- **Crash-safe defaults.** The riskiest layerings (rtk hooks injected into
  codex/cursor) are off unless you ask. A `doctor` pass in `status` detects and
  offers to repair known crash signals.

## Docs

- [Tier guide](docs/token-tiers.md)
- [Install prompt](docs/prompts/install.md)
- [Status / doctor prompt](docs/prompts/status.md)
- [Uninstall prompt](docs/prompts/uninstall.md)
- [Activation prompts](docs/token-tiers.md#workflow)
- [Version floor](versions.env)
- [Setup contract](docs/supervised-setup.md)
