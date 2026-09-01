# Maoleve

Maoleve is an Ubuntu-supported, supervised setup layer for coding agents. It
helps you add a small, token-efficient harness without taking control of an
existing setup.

Start by pasting the bootstrap prompt from [docs/README.md](docs/README.md)
into a supported agent. The agent identifies itself and the platform, explains
each proposed action, and waits for approval before it clones or updates the
checkout, inspects configuration, reads a credential source, installs
anything, or makes a change.

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
See [docs/README.md](docs/README.md) for the copyable bootstrap prompt and
the native configuration policy for each agent.

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
