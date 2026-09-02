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
  <a href="docs/token-tiers.md">Tiers</a> ·
  <a href="PROMPT.md">Operational prompt</a> ·
  <a href="docs/README.md">Full guide</a>
</p>

Mão leve is a supervised, **prompt-only** setup layer for coding agents. Run
**one-time install** once, then activate a token-economy tier at the start of
each chat. No custom CLI or blast install required.

Tested primarily on Ubuntu Linux; compatible Linux and macOS are best-effort.

## Start here

### 1. One-time install

Paste [`docs/prompts/install.md`](docs/prompts/install.md) into your coding agent
once. It prepares RTK, Headroom, Serena, vendored Caveman skills, and dormant
policy templates — without enabling proxy, MCP, or always-on rules. Safe to
re-run; skips components already installed.

### 2. Verify (new chat)

Open a **new chat** and paste [`docs/prompts/verify.md`](docs/prompts/verify.md).
It checks binaries, dormant policies, MCP count at idle, and stray always-on
rules — and fixes gaps with your approval.

### 3. Uninstall (optional)

To remove a prompt-only install (reverse step 1), paste
[`docs/prompts/uninstall.md`](docs/prompts/uninstall.md) in a new chat. It undoes
dormant policies, vendored Caveman copies, and RTK hooks from `install.md` —
idempotent and supervised. It does not clean legacy blast-install cruft.

### 4. Activate a tier each chat

Paste an activation prompt or type a slash command as your first message:

| Tier | One-liner | Slash command | Activation prompt |
| --- | --- | --- | --- |
| **low** | RTK + Caveman, zero MCP | `/maoleve-low` | [activate-low.md](docs/prompts/activate-low.md) |
| **fast** | low + Headroom proxy | `/maoleve-fast` | [activate-fast.md](docs/prompts/activate-fast.md) |
| **medium** | fast + full Caveman (**default**) | `/maoleve-medium` | [activate-medium.md](docs/prompts/activate-medium.md) |
| **high** | medium + Serena MCP | `/maoleve-high` | [activate-high.md](docs/prompts/activate-high.md) |
| **full** | high + multi-agent consistency | `/maoleve-full` | [activate-full.md](docs/prompts/activate-full.md) |

Aliases without a slash work too: `maoleve-fast`, `maoleve-medium`, etc.

**Example daily flow**

```text
# First time only (any chat)
Paste docs/prompts/install.md → approve steps → install report

# Right after install (new chat)
Paste docs/prompts/verify.md → all checks pass

# Every coding session (first message)
/maoleve-medium
# or paste docs/prompts/activate-medium.md
```

> [!IMPORTANT]
> The agent will ask before inspecting configuration, reading credential
> sources, installing tools, repairing files, or making changes.

> **Supported versions:** `versions.env` is authoritative. Setup warns when
> installed versions may contain breaking changes, then continues.

### Generic bootstrap (optional)

<details>
<summary><strong>Copy this bootstrap prompt</strong></summary>

```text
Set up Mão leve in supervised mode.

1. Identify which supported agent you are: Codex, OpenCode, Cursor Agents
   (cursor-agent), Cursor IDE, or Claude Code.
2. Detect the operating system and shell. Ubuntu Linux is the primary tested
   environment; continue on compatible Linux or macOS when possible.
3. Explain where Mão leve will live and whether you will clone or update it.
   Ask for my approval before changing anything.
4. After I approve, clone this repository if it is missing:
   https://github.com/Guilheeeeeeerme/maoleve.git
   If it already exists, inspect its status and update it only without
   discarding my changes. Never use destructive cleanup.
5. Follow docs/prompts/install.md for one-time setup (tools on disk, no global
   proxy/MCP/rules).
6. Tell me to open a new chat and run docs/prompts/verify.md before daily use.
7. Before every configuration inspection, credential read, installation, or
   change, explain the action and ask for my approval.
8. When I start a new chat, I will activate a tier with /maoleve-<tier> or
   docs/prompts/activate-<tier>.md — apply that tier for the current chat only.
```

</details>

## What install configures (per agent)

Paste [`docs/prompts/install.md`](docs/prompts/install.md) once; authorize each
agent you use. Install prepares the same stack on disk for every authorized
agent — tier policy stays dormant until you activate a tier per chat.

| Agent | Caveman mirror | RTK hooks | Dormant policy surface |
| --- | --- | --- | --- |
| **Codex** | `~/.codex/skills/caveman/` | `rtk init --global --codex` | `~/.codex/AGENTS.md` |
| **OpenCode** | `~/.config/opencode/skills/caveman/` | `rtk init --global --opencode` | `~/.config/opencode/AGENTS.md` |
| **Claude Code** | `~/.claude/skills/caveman/` | `rtk init --global` | `~/.claude/CLAUDE.md` |
| **Cursor IDE** | `~/.cursor/skills/caveman/` | `rtk init --global --agent cursor` | `~/.cursor/rules/maoleve.mdc` (`alwaysApply: false`) |
| **Cursor Agents** | `~/.cursor/skills/caveman/` | `rtk init --global --agent cursor` | project `AGENTS.md` |

All authorized agents also get `~/.agents/skills/caveman/` (canonical copy) plus
RTK, Headroom, and Serena **binaries** (no proxy/MCP at idle). Cursor IDE and
Cursor Agents are separate targets — configure both only if you use both.

## What it supports

Mão leve writes an additive, clearly marked layer into the native surface of
the agent you authorize. Tier policy applies **when activated**, not globally.

| Coding agent | Native surface |
| --- | --- |
| Codex | `AGENTS.md`, Codex configuration |
| OpenCode | `AGENTS.md`, OpenCode configuration |
| Cursor Agents | `AGENTS.md`, `cursor-agent` configuration |
| Cursor IDE | Cursor rules and MCP configuration |
| Claude Code | `CLAUDE.md`, Claude configuration |

Cursor Agents and Cursor IDE are separate targets.

## Token economy only

In-scope tools: **Headroom**, **RTK**, **Caveman** (vendored from this repo),
**Serena** (high/full when activated). Out of scope: tokensave, Playwright MCP.

Caveman skills copy from `.agents/skills/caveman*` — not `npx skills add`.
See [vendored copy layout](docs/token-tiers.md#vendored-copy-layout).

## The Mão leve approach

### Your harness stays in charge

- Reads existing configuration before proposing an edit.
- Preserves credentials categorically — never deleted, replaced, or exposed.
- Adds approved Mão leve entries only when absent.
- Pauses for approval before recoverable backup-and-rewrite flows.
- Never silently overwrites a configuration file.

### Permission before discovery

Credential discovery requires explicit, source-by-source permission. Finding an
integration does not authorize adopting it.

## Legacy CLI

[`bin/maoleve`](bin/maoleve) and [`install.sh`](install.sh) are **deprecated**.
Use install + activation prompts instead. See [`DEPRECATED.md`](DEPRECATED.md).

## Documentation

- [Guided setup](docs/README.md)
- [Token economy tiers](docs/token-tiers.md)
- [Install prompt](docs/prompts/install.md)
- [Verify prompt](docs/prompts/verify.md)
- [Uninstall prompt](docs/prompts/uninstall.md)
- [Activation prompts](docs/prompts/)
- [Operational prompt](PROMPT.md)
- [Version lock](versions.env)
