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
  <a href="PROMPT.md">Operational prompt</a> ·
  <a href="docs/README.md">Full guide</a>
</p>

Mão leve is a cross-platform, supervised setup layer for coding agents. It is
tested primarily on Ubuntu Linux and aims to work on compatible Linux and macOS
environments without taking control of an existing setup.

## Start here

Open your coding agent, paste the prompt below, and follow its questions.

> [!IMPORTANT]
> The agent will ask before inspecting configuration, reading credential
> sources, installing tools, repairing files, or making changes.

<details open>
<summary><strong>Copy this prompt into your agent</strong></summary>

```text
Set up Mão leve in supervised mode.

1. Identify which supported agent you are: Codex, OpenCode, Cursor Agents
   (cursor-agent), Cursor IDE, or Claude Code.
2. Detect the operating system and shell. Ubuntu Linux is the primary tested
   environment; continue on compatible Linux or macOS when possible. If a
   platform-specific limitation appears, explain it and ask me how to proceed.
3. Explain where Mão leve will live and whether you will clone or update it.
   Ask for my approval before changing anything.
4. After I approve, clone this repository if it is missing:
   https://github.com/Guilheeeeeeerme/maoleve.git
   If it already exists, inspect its status and update it only without
   discarding my changes. Never use destructive cleanup.
5. Enter the Mão leve checkout and read `PROMPT.md`. Follow that prompt exactly.
   It contains the complete setup questions, merge rules, credential safety,
   supported-agent guidance, optional integrations, repair rules, and final
   report format.
6. Before every configuration inspection, credential-source read, installation,
   repair, reinstall, or configuration change, explain the action and ask for
   my approval. Preserve my existing harness and credentials.
```

</details>

This prompt is self-contained. The complete operational rules live in
[`PROMPT.md`](PROMPT.md).

> **Version lock:** `versions.env` is authoritative. Setup must refuse
> pinned-version drift instead of silently upgrading a dependency.

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

Cursor Agents and Cursor IDE are separate targets. Mão leve never assumes that
an IDE-only setting applies to terminal-facing Cursor Agents.

## The maoleve approach

### Your harness stays in charge

Existing harness configuration and credentials remain yours. Mão leve
complements your setup; it does not replace it.

- Reads relevant existing configuration before proposing an edit.
- Preserves every credential categorically: credentials are never deleted,
  replaced, or exposed.
- Preserves model choices, plugins, rules, commands, hooks, unknown fields,
  formatting, and ordering whenever possible.
- Adds approved Mão leve entries only when absent.
- Updates only entries marked as Mão leve-managed on later runs.
- Pauses for approval before any recoverable backup-and-rewrite flow when safe
  merging is not possible.
- Never silently overwrites a configuration file.

### Permission before discovery

Credential discovery requires explicit, source-by-source permission. The setup
agent asks whether it may inspect credentials in other agents and exactly which
agents are authorized.

Finding an integration or credential does not authorize adopting it. If a
selected integration is already configured, Mão leve preserves the existing
credential and merges around it.

## Optional integrations

Every integration is independent and opt-in. Mão leve does not recommend or
enable any integration automatically.

| Integration | Purpose |
| --- | --- |
| Headroom | Context compression and model-call proxying |
| RTK | Compact shell-command output |
| Serena | Selective symbol lookup and code navigation |
| Caveman | Concise technical responses and workflow style |
| Spectkit | Specification workflow support |
| Superpowers | Agent workflow skills |
| Firecrawl | Web search and structured content retrieval |
| Context7 | Current library and framework documentation |

MCP entries follow the same rule: configure only selected entries in the
authorized agent's native surface. There is no default MCP list, automatic
plugin install, or shared configuration format across all agents.

## Environment and credentials

Some selected integrations may need environment variables or account-specific
setup. Before reading any environment configuration, credential-bearing file,
directory, or variable source, the setup agent asks which exact source it may
inspect.

It does not print, replace, or copy secret values unnecessarily, and prefers
references to existing environment variables. If something is missing, it
reports the exact variable or manual step without asking you to disclose a
secret.

## Repair and validation

Use the [guided setup documentation](docs/README.md) and
[operational prompt](PROMPT.md) as current instructions. Do not treat older
product-planning material or a shell command as authorization to configure all
agents or integrations automatically.

For a selected Mão leve-managed component, recovery follows this order:

1. Diagnose with non-secret evidence.
2. Repair managed configuration.
3. Reinstall the managed package, plugin, or files after approval.
4. Recreate only the Mão leve-owned component if necessary.
5. Re-merge preserved user configuration and validate it.

Recovery never deletes an entire agent configuration directory or existing
credentials. At completion, the agent reports approved agents and
integrations, what it installed, reused, skipped, left manual, or could not
complete, and what configuration it preserved.

## Documentation

- [Guided setup and bootstrap prompt](docs/README.md)
- [Operational prompt](PROMPT.md)
- [Version lock](versions.env)
- [Current product contract](docs/product-spec.md)
