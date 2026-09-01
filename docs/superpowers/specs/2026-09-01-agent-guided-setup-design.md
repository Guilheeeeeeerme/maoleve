# Agent-Guided Maoleve Setup Design

**Date:** 2026-09-01
**Status:** Design approved in conversation; awaiting written-spec review
## Goal

Replace the old automatic-default setup story with a supervised, prompt-driven
onboarding flow. A human pastes a short bootstrap prompt into one supported
coding agent. That agent clones Maoleve, reads the detailed operational prompt,
asks which integrations to use, and applies only complementary, user-approved
changes.

## Scope

Initial supported agents:

- Codex
- OpenCode
- Cursor Agents (`cursor-agent`)
- Cursor IDE
- Claude Code

Initial optional integrations:

- Headroom
- RTK
- Serena
- Caveman
- Spectkit
- Superpowers
- Firecrawl
- Context7

No integration is recommended or enabled automatically. The user may select
each integration independently, skip it, or request manual instructions.

## User Flow

The bootstrap prompt is intentionally short. It instructs the active agent to:

1. identify the current agent and verify Linux/Ubuntu support;
2. clone or update Maoleve in a user-local directory;
3. read the repository's detailed setup prompt;
4. explain the planned actions to the supervising human;
5. inspect the active agent's existing harness configuration;
6. ask whether it may inspect other agents for reusable configuration;
7. ask which specific agents may be inspected;
8. ask about each optional integration individually;
9. merge approved configuration and install only approved components;
10. validate the result and report installed, reused, skipped, manual, and
    failed items.

The human remains in the loop for permissions, ambiguous merges, destructive
operations, credential reuse, and recovery actions.

## Complementary Configuration Contract

Maoleve treats the user's existing harness as the primary configuration. It
adds a clearly identifiable Maoleve-managed layer instead of replacing the
user's workflow.

For every supported agent, the agent must:

- read existing configuration before proposing changes;
- preserve existing credentials, model choices, plugins, rules, commands,
  hooks, and unknown fields;
- add only approved Maoleve entries that are absent;
- update only entries previously marked as Maoleve-managed;
- avoid changing unrelated formatting or ordering when possible;
- show a diff or concise change summary before ambiguous edits;
- create a recoverable backup before a repair or clean reinstall.

Maoleve-managed blocks must use stable markers or an equivalent ownership
metadata mechanism. The agent must never infer ownership merely because a
setting resembles a Maoleve setting.

If a file format cannot be merged safely, the agent must stop and ask the human
whether to use a backup-and-rewrite flow. It must not silently overwrite the
file.

## Credential and Cross-Agent Discovery Rules

Credential handling is preservation-first:

- never delete or replace an existing credential;
- never replace a real value with a placeholder;
- never print credential values in output, diffs, backups shown to the user, or
  documentation;
- use an existing credential only after confirming its source and intended
  integration;
- ask before reading credential-bearing files or environment configuration in
  another agent's directory;
- ask which agents are authorized for discovery; authorization for one agent
  does not authorize all agents;
- prefer references to existing environment variables over copying secret
  values into agent-specific files;
- if a required credential is missing, report the exact variable or manual step
  without inventing or prompting the agent to expose a secret.

The agent must distinguish discovery from adoption: finding a configured key in
an authorized source does not automatically authorize using it for a newly
selected integration.

## Installation and Recovery Boundaries

Maoleve may install or repair only components the user selected and only within
the documented Maoleve-managed scope. It must not modify unrelated tools or
global user preferences.

When an approved Maoleve component is missing or broken, the recovery ladder is:

1. diagnose and show evidence;
2. repair the existing Maoleve-managed configuration;
3. reinstall the Maoleve-managed package/plugin/files if the human approves;
4. remove and recreate only the Maoleve-owned component when a clean reinstall
   is necessary;
5. re-merge preserved user configuration and validate.

Clean reinstall never means deleting an entire agent configuration directory.
Any broader removal requires a separate explicit confirmation and a backup.

## Agent-Specific Guidance

Each agent receives a native policy layer, written as a Maoleve-managed block:

- Cursor IDE: Cursor rules file with concise context and shell guidance;
- Cursor Agents: compatible terminal-facing guidance without assuming IDE-only
  features;
- Codex: `AGENTS.md` guidance for targeted reads, compact command output, and
  user approval before broad work;
- OpenCode: `AGENTS.md` guidance plus only the selected plugin/MCP entries;
- Claude Code: `CLAUDE.md` guidance and selected hook/MCP/plugin entries.

All guidance must be additive and should optimize token use through:

- narrow searches and targeted reads;
- compressed shell output when RTK is selected;
- concise responses when Caveman is selected;
- selective symbol lookup when Serena is selected;
- selective MCP use for current documentation or web research;
- no broad tests, refactors, or context collection unless requested.

Agent-specific syntax and capabilities must be documented separately. Shared
policy text may be reused, but configuration formats must not be assumed to be
interchangeable.

## Documentation Changes

The documentation update will establish these sources of truth:

- `PROMPT.md`: detailed operational prompt read by the setup agent;
- `docs/README.md`: user onboarding, bootstrap prompt, permissions, merge
  behavior, supported agents, optional integrations, and recovery;
- `README.md`: concise project overview and link to the new onboarding flow;
- `docs/product-spec.md`: updated product contract and acceptance criteria.

The previous automatic-default language must be removed or explicitly labeled
historical. Existing implementation plans/specs remain historical records and
must not be presented as current user instructions.

## Validation

Documentation validation must confirm:

- all five supported agents use the exact same names throughout the docs;
- no document claims that optional tools are automatically enabled;
- credential-preservation and cross-agent authorization rules are consistent;
- complementary merge behavior is described in every relevant entry point;
- clean reinstall scope is limited to Maoleve-managed components;
- Linux/Ubuntu scope and version-lock policy remain explicit;
- bootstrap prompt points to the detailed prompt in the cloned repository;
- no stale command or configuration claim contradicts the new supervised flow.
