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

Mão leve is a supervised, **prompt-only** setup layer for coding agents. Pick a
token-economy tier, paste the install prompt into your agent, approve each step.
No custom CLI or blast install required.

Tested primarily on Ubuntu Linux; compatible Linux and macOS are best-effort.

## Start here

1. Read [Token economy tiers](docs/token-tiers.md) and pick a tier.
2. Open the matching [install prompt](docs/prompts/) and copy everything below
   the line into your coding agent.

| Tier | One-liner | Prompt |
| --- | --- | --- |
| **low** | RTK + Caveman policy, zero MCP | [install-low.md](docs/prompts/install-low.md) |
| **fast** | low + Headroom proxy | [install-fast.md](docs/prompts/install-fast.md) |
| **medium** | fast + full Caveman skills from repo (**default**) | [install-medium.md](docs/prompts/install-medium.md) |
| **high** | medium + Serena MCP | [install-high.md](docs/prompts/install-high.md) |
| **full** | high + multi-agent consistency, Headroom MCP on Cursor IDE if needed | [install-full.md](docs/prompts/install-full.md) |

> [!IMPORTANT]
> The agent will ask before inspecting configuration, reading credential
> sources, installing tools, repairing files, or making changes.

> **Supported versions:** `versions.env` is authoritative. Setup warns when
> installed versions may contain breaking changes, then continues.

### Generic bootstrap (optional)

If you prefer one entry prompt before choosing a tier:

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
5. Read docs/token-tiers.md and ask which tier I want: low, fast, medium,
   high, or full.
6. Follow the matching docs/prompts/install-<tier>.md exactly.
7. Before every configuration inspection, credential read, installation, or
   change, explain the action and ask for my approval.
```

</details>

## What it supports

Mão leve writes an additive, clearly marked layer into the native surface of
the agent you authorize.

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
**Serena** (high/full). Out of scope for tier prompts: Speckit, Superpowers,
Firecrawl, Context7, Playwright, tokensave.

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
Use tier install prompts instead. See [`DEPRECATED.md`](DEPRECATED.md).

## Documentation

- [Guided setup](docs/README.md)
- [Token economy tiers](docs/token-tiers.md)
- [Install prompts](docs/prompts/)
- [Operational prompt](PROMPT.md)
- [Version lock](versions.env)
