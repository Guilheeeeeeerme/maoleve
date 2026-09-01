# Maoleve guided setup

Maoleve is an Ubuntu-supported, supervised setup layer for coding agents. A
human remains in control: the setup agent explains its plan, asks before it
inspects or changes anything, and reports what it installed, reused, skipped,
left for manual setup, or could not complete.

For current setup instructions, this guide and the repository's
[operational prompt](../PROMPT.md) take precedence over older product-planning
material. `versions.env` is the version lock: setup must refuse version drift
rather than silently upgrading a pinned dependency.

## Start with a supported agent

Paste this prompt into one supported agent. It is plain text for the agent;
do not run it as a shell command.

```text
Set up Maoleve in supervised mode. Identify which supported agent you are,
verify Linux/Ubuntu support, then clone or update Maoleve in a user-local
directory without discarding my changes. Read PROMPT.md in that checkout and
follow it exactly. Before any inspection, installation, configuration change,
credential read, repair, or reinstall, explain the action and ask for my
approval.
```

Inspect the complete [operational prompt](../PROMPT.md) before using it if you
want to review every question and boundary. The setup agent reads that file
after it clones or updates the repository, along with this guide and the
repository README.

Ubuntu is the only guaranteed platform. On another Linux distribution or
outside Linux, the agent must stop and ask how to proceed.

## Supported agents and their native configuration

Maoleve supports these agents. It adds a marked, Maoleve-managed layer in the
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

Each integration is independent. Maoleve asks about every item below before
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

Your existing harness wins. Maoleve adds an identifiable owned layer; it does
not replace your workflow.

- The agent reads existing configuration before proposing an edit.
- Existing model choices, plugins, rules, commands, hooks, unknown fields,
  formatting, and ordering remain intact whenever possible.
- It adds only approved Maoleve entries that are absent. On a later run, it
  updates only entries already marked as Maoleve-managed.
- A setting that resembles a Maoleve setting is not proof that Maoleve owns
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

Maoleve must never delete or replace existing credentials. Credentials are
never Maoleve-owned, and recovery deletion excludes them.

Discovery is not adoption. Finding a component or credential in an authorized
source does not authorize its use for a newly selected integration. The agent
must obtain separate approval, confirm its source and intended use, and report
a missing credential as the exact variable or manual step without asking you
to reveal the secret.

## Repair and clean reinstall

Recovery applies only to selected Maoleve-managed components. Before repair or
clean reinstall, the agent creates a recoverable backup and follows this
order:

1. Diagnose the problem and show non-secret evidence.
2. Repair the existing Maoleve-managed configuration.
3. With approval, reinstall the Maoleve-managed package, plugin, or files.
4. If necessary, remove and recreate only the Maoleve-owned component.
5. Re-merge preserved user configuration and validate the result.

**Warning:** Maoleve recovery never removes an entire agent configuration
directory. Any broader user-led cleanup is outside Maoleve recovery scope and
requires separate handling, including its own explicit confirmation and
backup. Maoleve does not modify unrelated tools or global preferences during
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
- [Product spec (planning reference)](./product-spec.md)
