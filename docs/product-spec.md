# Mão leve Product Spec

## 1. Overview

Mão leve is a cross-platform, supervised setup layer for coding agents. It is
tested primarily on Ubuntu Linux and aims to work on compatible Linux and
macOS environments. It complements an existing harness: it adds a clearly
identifiable,
Mão leve-managed layer only where a human approves it. It does not replace a
user's workflow, credentials, or unrelated configuration.

Mão leve is not a general automation platform, secrets manager, cross-platform
installer, or a promise that every agent exposes the same configuration
surface.

## 2. Product Goal

The primary goal is prompt-driven, human-supervised onboarding for Codex,
OpenCode, Cursor Agents (`cursor-agent`), Cursor IDE, and Claude Code. A
human gives a supported agent the bootstrap prompt; that agent identifies
itself, verifies the supported platform, reads the repository's detailed
operational prompt, explains its plan, and asks before it inspects,
installs, configures, repairs, or reuses credentials.

The human remains responsible for approval of optional integrations,
cross-agent discovery, credential-bearing sources, ambiguous merges,
destructive operations, and recovery actions.

Mão leve must retain its version-lock policy: `versions.env` is the lock file.
Setup must refuse pinned-version drift rather than silently upgrading a
dependency or adopting `latest`.

## 3. Product Principles

- Existing harness configuration is primary; Mão leve is complementary.
- Prompt-driven supervised setup is the primary user flow.
- Ubuntu Linux is the primary tested platform. Other Linux distributions and
  macOS are best-effort targets; setup should continue when compatible and ask
  the human before proceeding around a platform-specific limitation.
- All integrations are independent and opt-in. No tool, plugin, MCP entry, or
  policy mode is enabled or recommended automatically.
- Agent-native formats and capabilities remain separate; shared policy does
  not imply interchangeable configuration.
- Targeted reads, narrow searches, and concise change summaries are preferred
  over broad collection or opaque automation.

## 4. Operating Modes

### 4.1 Supervised setup

This is the required onboarding mode. The setup agent:

1. Identifies the active supported agent and detects the operating system,
   shell, and relevant package manager.
2. Identifies whether a Mão leve checkout must be cloned or updated and
   describes that planned checkout action, including that it will use a
   user-local directory without discarding user changes.
3. Obtains the required approval before cloning or updating the checkout, then
   reads `PROMPT.md`, `README.md`, `docs/README.md`, this spec, and
   `versions.env` when present.
4. Merges only approved Mão leve-managed entries, validates them in the native
   agent context when possible, and reports installed, reused, skipped, manual,
   and failed items.

### 4.2 Optional task integrations

After explicit selection, an integration may support a specific task or native
agent policy layer. Selection is per integration and does not create approval
to inspect another agent, read credentials, or change unrelated configuration.

### 4.3 Manual path

A human may skip an integration or request manual instructions at every
decision point. Missing prerequisites must be reported as an exact variable or
manual step; setup must not request that a secret be exposed.

## 5. Supported Agents and Native Guidance

Mão leve supports these distinct targets. It writes an additive,
Mão leve-managed block only in an authorized target's native surface.

| Agent | Native guidance or configuration surface |
| --- | --- |
| Codex | `AGENTS.md` guidance for targeted reads, compact command output, and human approval before broad work. |
| OpenCode | `AGENTS.md` guidance plus only selected plugin or MCP entries. |
| Cursor Agents (`cursor-agent`) | Terminal-facing guidance compatible with Cursor Agents, without Cursor IDE-only assumptions. |
| Cursor IDE | Cursor rules file with concise project context and shell guidance. |
| Claude Code | `CLAUDE.md` guidance plus selected hook, MCP, or plugin entries. |

The active agent must be identified rather than inferred from a directory name
or environment variable. Cursor Agents and Cursor IDE are separate targets.

## 6. Optional Integrations

Each integration is optional, independently selected, and installed or
configured only after approval. `versions.env` remains authoritative for any
selected component with a pinned version.

| Integration | Purpose |
| --- | --- |
| Headroom | Context compression and model-call proxying. |
| RTK | Compact shell-command output. |
| Serena | Selective symbol lookup and code navigation. |
| Caveman | Concise technical response and workflow style. |
| Spectkit | Specification workflow support. |
| Superpowers | Agent workflow skills. |
| Firecrawl | Web search and structured content retrieval. |
| Context7 | Current library and framework documentation lookup. |

MCP configuration follows the same rule: add only selected entries in the
authorized agent's native configuration. Mão leve has no default MCP list or
automatic plugin installation contract.

Current lock coverage for optional integrations is declared by
`MAOLEVE_HEADROOM_VERSION`, `MAOLEVE_RTK_VERSION`,
`MAOLEVE_SERENA_VERSION`, and `MAOLEVE_CAVEMAN_PLUGIN_VERSION` in
`versions.env`. Their values must not be duplicated in this spec: the lock
file is authoritative. A lock entry does not select, recommend, install, or
enable its integration. Integrations without a lock entry remain optional but
require an approved, documented version decision before automated
installation.

## 7. Merge, Ownership, and Credential Requirements

Before proposing an edit, setup must read the relevant existing configuration.
It must preserve credentials, model choices, plugins, rules, commands, hooks,
unknown fields, formatting, and ordering whenever possible. It may add only
approved Mão leve entries that are absent; on later runs it may update only
entries already marked as Mão leve-managed.

Every managed block requires stable markers or equivalent ownership metadata.
Similarity to a Mão leve setting is never evidence of ownership. For ambiguous
edits, setup must show a diff or concise human-visible change summary. If a
format cannot be merged safely, it must stop and ask whether to use a
backup-and-rewrite flow; it must never silently overwrite the file.

Credential handling is preservation-first:

- Preserve every existing credential categorically: never delete, replace,
  print, expose in a diff or user-visible backup, or copy its value.
- Never replace a real value with a placeholder.
- Prefer references to existing environment variables over copying secret
  values into agent-specific files.
- Confirm a credential's source and intended integration before reuse.
- Report a missing credential as an exact variable or manual action without
  asking the human to disclose its value.

Discovery and adoption are separate permissions. Setup must ask before
inspecting the active agent's harness. It must separately ask whether it may
discover reusable configuration in other agents, and which exact agents are
authorized. Permission for one agent does not apply to another. Reading a
credential-bearing file, directory, environment configuration, or variable
source requires further explicit, source-by-source approval. Finding a
configured component or key never authorizes adopting it.

## 8. Installation and Recovery

The bootstrap prompt and `PROMPT.md` are the primary installation interface.
A shell installer may remain an implementation path only where its behavior is
accurate, documented, and supervised; it is not authorization to configure
all agents or integrations automatically.

Mão leve may install, repair, or reinstall only selected components within its
documented managed scope. For a selected missing or broken component, it must:

1. Diagnose and show non-secret evidence.
2. Repair existing Mão leve-managed configuration.
3. With human approval, reinstall the Mão leve-managed package, plugin, or
   files.
4. If necessary, remove and recreate only the Mão leve-owned component.
5. Re-merge preserved user configuration and validate.

Create a recoverable backup before repair or clean reinstall. A clean reinstall
never deletes, replaces, or recreates an entire agent configuration directory,
even with approval; it is limited to the Mão leve-owned component. Setup must
not modify unrelated tools or global user preferences.

## 9. Quality Bar

Mão leve meets its quality bar when:

- Ubuntu is identified as the primary tested environment, broader Linux and
  macOS support is documented as best-effort, and `versions.env` version-lock
  behavior is explicit and preserved.
- The five supported agents use the exact names in this spec and receive
  agent-native, additive guidance.
- Prompt-driven supervised setup is documented as the primary flow.
- Optional integrations, plugins, and MCP entries are selected independently,
  never automatically enabled, and described with accurate purpose.
- Existing configuration, unknown fields, formatting, ordering, and secrets
  are protected by the merge contract.
- Cross-agent discovery and credential-bearing reads require explicit,
  scoped authorization.
- Recovery is limited to Mão leve-managed components, includes backups, and
  re-merges preserved configuration.
- Completion reports approved agents and integrations plus installed, reused,
  skipped, manual, and failed items.

## 10. Acceptance Criteria

Mão leve is ready for implementation when the repository documentation and
setup behavior satisfy all of the following:

- A supported agent can follow the bootstrap prompt to the detailed
  `PROMPT.md` in a user-local checkout.
- Setup explains platform limitations and asks before proceeding when a
  command, path, package, or integration is incompatible; it refuses version
  drift instead of silently proceeding.
- The supervising human approves optional integration selection, configuration
  inspection, cross-agent discovery, credential-source reads, ambiguous merges,
  repair, and clean reinstall actions.
- Only marked Mão leve-managed entries are changed after initial setup; unknown
  fields and every existing credential remain preserved without deletion,
  replacement, exposure, or value copying.
- Unsafe merges stop for human direction, and recovery creates a backup before
  repair or clean reinstall.
- Recovery can remove and recreate only a Mão leve-owned component, never a
  whole agent configuration directory.
- Native guidance surfaces for Codex, OpenCode, Cursor Agents
  (`cursor-agent`), Cursor IDE, and Claude Code remain distinct.
- No acceptance criterion requires automatic default installation, a default
  integration stack, or broad configuration replacement.

## 11. Documentation Entry Points

Current user instructions are:

- [Guided setup and bootstrap prompt](./README.md)
- [Operational prompt](../PROMPT.md)
- [Repository overview](../README.md)
- [Version lock](../versions.env)

Older planning material is historical and must not override these supervised
setup instructions.

## 12. Open Questions

- Which Ubuntu LTS release should become the explicit tested baseline, and
  which Linux/macOS environments should be added to validation?
- Which shell-installer actions remain accurate enough to document as an
  optional implementation path?
- Should legacy TokenSave compatibility remain documented only where an
  existing selected integration still requires it?
