# Maoleve

Maoleve is an Ubuntu-supported, supervised setup layer for coding agents. It
helps you add a small, token-efficient harness without taking control of an
existing setup.

## Start here

Open your coding agent, paste this prompt, and follow its questions:

```text
Set up Maoleve in supervised mode.

1. Identify which supported agent you are: Codex, OpenCode, Cursor Agents
   (cursor-agent), Cursor IDE, or Claude Code.
2. Verify Linux/Ubuntu support. Ubuntu is the only guaranteed platform. Stop
   and ask me how to proceed on another Linux distribution or outside Linux.
3. Explain where Maoleve will live and whether you will clone or update it.
   Ask for my approval before changing anything.
4. After I approve, clone this repository if it is missing:
   https://github.com/Guilheeeeeeerme/maoleve.git
   If it already exists, inspect its status and update it only without
   discarding my changes. Never use destructive cleanup.
5. Enter the Maoleve checkout and read `PROMPT.md`. Follow that prompt exactly.
   It contains the complete setup questions, merge rules, credential safety,
   supported-agent guidance, optional integrations, repair rules, and final
   report format.
6. Before every configuration inspection, credential-source read, installation,
   repair, reinstall, or configuration change, explain the action and ask for
   my approval. Preserve my existing harness and credentials.
```

This prompt is self-contained: paste it directly into the agent you want to
configure. Full operational rules live in [`PROMPT.md`](PROMPT.md).

`versions.env` is the version lock. Setup must refuse pinned-version drift
rather than upgrade a dependency silently.

## Supported agents

Maoleve supports these distinct native surfaces:

- Codex
- OpenCode
- Cursor Agents (`cursor-agent`)
- Cursor IDE
- Claude Code

Cursor Agents and Cursor IDE are separate targets. The setup agent never
assumes that an IDE-only setting applies to terminal-facing Cursor Agents.
See [docs/README.md](docs/README.md) for the same prompt plus the native
configuration policy for each agent.

## Supervised, complementary setup

Existing harness configuration and credentials remain yours. Maoleve adds an
identifiable, Maoleve-managed layer only for agents and integrations you
approve.

- It reads relevant existing configuration before proposing an edit.
- It preserves every existing credential categorically: credentials are never
  deleted, replaced, or exposed.
- It preserves existing model choices, plugins, rules, commands, hooks, and
  unknown fields. It preserves formatting and ordering whenever possible.
- It adds approved Maoleve entries only when absent, then updates only entries
  marked as Maoleve-managed on later runs.
- If safe merging is not possible, it pauses for approval before a recoverable
  backup-and-rewrite flow. It never silently overwrites a configuration file.

Credential discovery requires explicit, source-by-source permission. Finding
an integration or credential does not authorize adopting it.

## Optional integrations

Every integration is opt-in. Maoleve does not recommend or enable any
integration automatically. The setup agent asks independently about:

- Headroom — context compression and model-call proxying
- RTK — compact shell-command output
- Serena — selective symbol lookup and code navigation
- Caveman — concise technical responses and workflow style
- Spectkit — specification workflow support
- Superpowers — agent workflow skills
- Firecrawl — web search and structured content retrieval
- Context7 — current library and framework documentation

MCP entries follow the same rule: configure only selected entries in the
authorized agent's native surface. Maoleve does not promise a default MCP
list, automatic plugin install, or a shared configuration format across all
agents.

## Environment and credentials

Some selected integrations may need environment variables or account-specific
setup. Before reading any environment configuration, credential-bearing file,
directory, or variable source, the setup agent asks which exact source it may
inspect. It does not print, replace, or copy secret values unnecessarily, and
prefers references to existing environment variables.

If something is missing, the agent reports the exact variable or manual step
without asking you to disclose a secret.

## Installation, repair, and validation

Use the [guided setup documentation](docs/README.md) and
[operational prompt](PROMPT.md) as current instructions. Do not treat older
product-planning material or a shell command as authorization to configure all
agents or integrations automatically.

For a selected Maoleve-managed component, recovery follows this order:

1. Diagnose with non-secret evidence.
2. Repair managed configuration.
3. Reinstall the managed package, plugin, or files after approval.
4. Recreate only the Maoleve-owned component if necessary.
5. Re-merge preserved user configuration and validate it.

Recovery never deletes an entire agent configuration directory or existing
credentials. At completion, the agent reports approved agents and
integrations, what it installed, reused, skipped, left manual, or could not
complete, and what configuration it preserved.

## Related documentation

- [Guided setup and bootstrap prompt](docs/README.md)
- [Operational prompt](PROMPT.md)
- [Version lock](versions.env)
- [Current product contract](docs/product-spec.md)
