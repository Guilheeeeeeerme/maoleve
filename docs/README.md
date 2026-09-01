# Mão leve guided setup

Mão leve is a cross-platform, supervised setup layer for coding agents. It is
tested primarily on Ubuntu Linux and aims to work on compatible Linux and
macOS environments. A human remains in control: the setup agent identifies
the platform, explains its plan, and asks before it clones or updates the checkout, inspects or
changes configuration, installs anything, or reads credentials. It then
reports what it installed, reused, skipped, left for manual setup, or could
not complete.

For current setup instructions, this guide and the repository's
[operational prompt](../PROMPT.md) take precedence over older product-planning
material. `versions.env` is the supported-version baseline: setup warns on
semver-breaking drift instead of refusing to run or silently upgrading a dependency.

## Start with a supported agent

Paste this prompt into one supported agent. It is plain text for the agent;
do not run it as a shell command.

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

Inspect the complete [operational prompt](../PROMPT.md) before using it if you
want to review every question and boundary. The setup agent reads that file
after it clones or updates the repository, along with this guide and the
repository README.

Ubuntu Linux is the primary tested environment. Other Linux distributions and
macOS are best-effort targets: the agent should continue when commands and
configuration surfaces are compatible, and ask before proceeding around a
platform-specific limitation.

## Supported agents and their native configuration

Mão leve supports these agents. It adds a marked, Mão leve-managed layer in the
native surface of only the agents you authorize; formats and capabilities are
not interchangeable.

| Agent | Native rule or configuration surface |
| --- | --- |
| Codex | `AGENTS.md` guidance, with its native configuration kept separate. |
| OpenCode | `AGENTS.md` guidance plus only selected plugin or MCP entries. |
| Cursor Agents (`cursor-agent`) | Terminal-facing guidance compatible with Cursor Agents, without assuming Cursor IDE-only features. |
| Cursor IDE | Cursor rules file with concise project context and shell guidance. |
| Claude Code | `CLAUDE.md` guidance plus selected hook, MCP, or plugin entries. |

The setup agent first identifies the active agent instead of guessing from a
directory name or environment variable. It then asks whether it may inspect
that active agent's harness configuration.

## Optional integrations

Each integration is independent. Mão leve asks about every item below before
installing or configuring it; you may select it, skip it, or request manual
instructions. No optional integration is enabled merely because it exists.

| Integration | Purpose |
| --- | --- |
| Headroom | Context compression and model-call proxying. |
| RTK | Compact shell-command output. |
| Serena | Selective symbol lookup and code navigation. |
| Caveman | Concise technical response and workflow style. |
| Spectkit | Optional specification workflow support. |
| Superpowers | Optional agent workflow skills. |
| Firecrawl | Optional web search and structured content retrieval. |
| Context7 | Optional current library and framework documentation lookup. |

MCP servers are subject to the same choice. The agent configures only selected
MCP entries, and only in the authorized agent's native configuration.

## Complementary configuration, not replacement

Your existing harness wins. Mão leve adds an identifiable owned layer; it does
not replace your workflow.

- The agent reads existing configuration before proposing an edit.
- Existing model choices, plugins, rules, commands, hooks, unknown fields,
  formatting, and ordering remain intact whenever possible.
- It adds only approved Mão leve entries that are absent. On a later run, it
  updates only entries already marked as Mão leve-managed.
- A setting that resembles a Mão leve setting is not proof that Mão leve owns
  it. Stable markers or equivalent ownership metadata are required.
- When a format cannot be merged safely, the agent pauses for human
  confirmation before any backup-and-rewrite flow. It never silently
  overwrites a configuration file.

For an ambiguous edit, the agent shows a diff or concise human-visible change
summary before proceeding.

## Discovery and credentials

Inspecting the active agent and inspecting other agents are separate
permissions. The agent asks before it reads the active harness configuration.
It must then separately ask whether it may discover reusable configuration in
other agents, and which specific agents are authorized: Codex, OpenCode,
Cursor Agents (`cursor-agent`), Cursor IDE, and Claude Code. Permission for
one agent does not extend to another.

Credential-bearing files, directories, environment configuration, and
variable sources require further explicit authorization, named per source.
The agent never prints secret values, replaces real values with placeholders,
or copies secrets unnecessarily. It prefers references to existing environment
variables.

Mão leve must never delete or replace existing credentials. Credentials are
never Mão leve-owned, and recovery deletion excludes them.

Discovery is not adoption. Finding a component or credential in an authorized
source does not authorize its use for a newly selected integration. The agent
must obtain separate approval, confirm its source and intended use, and report
a missing credential as the exact variable or manual step without asking you
to reveal the secret.

## Repair and clean reinstall

Recovery applies only to selected Mão leve-managed components. Before repair or
clean reinstall, the agent creates a recoverable backup and follows this
order:

1. Diagnose the problem and show non-secret evidence.
2. Repair the existing Mão leve-managed configuration.
3. With approval, reinstall the Mão leve-managed package, plugin, or files.
4. If necessary, remove and recreate only the Mão leve-owned component.
5. Re-merge preserved user configuration and validate the result.

**Warning:** Mão leve recovery never removes an entire agent configuration
directory. Any broader user-led cleanup is outside Mão leve recovery scope and
requires separate handling, including its own explicit confirmation and
backup. Mão leve does not modify unrelated tools or global preferences during
repair.

## What completion looks like

After validation in the selected agent's native context when possible, the
setup agent reports each item as installed, reused, skipped, manual, or
failed. This report should also identify the approved agents and integrations,
preserved configuration, and any action still requiring human input.

Related repository material:

- [Repository README](../README.md)
- [Operational prompt](../PROMPT.md)
- [Version lock](../versions.env)
- [Current product contract](./product-spec.md)
