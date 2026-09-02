# Mão leve guided setup

Mão leve is a supervised, **prompt-only** setup layer for coding agents. Run
**one-time install** once, then activate a tier at the start of each chat. No
custom CLI required.

Tested primarily on Ubuntu Linux; compatible Linux and macOS are best-effort.
The setup agent identifies the platform, explains its plan, and asks before it
uses or creates a checkout, inspects or changes configuration, installs
anything, or reads credentials.

For current instructions, this guide, [`docs/token-tiers.md`](token-tiers.md), and
[`PROMPT.md`](../PROMPT.md) take precedence over older product-planning material.
`versions.env` is the supported-version baseline: setup warns on semver-breaking
drift instead of refusing to run or silently upgrading.

## Two-step workflow

### 1. One-time install

Paste [`docs/prompts/install.md`](prompts/install.md) into your coding agent once
per machine (or when repairing). It:

- Uses the current checkout, or an approved checkout under
  `${XDG_DATA_HOME:-$HOME/.local/share}/maoleve`
- Installs RTK, Headroom, and Serena binaries (pinned to `versions.env`)
- Copies vendored Caveman and Mão leve tier skills and merges **dormant** policy templates
- Does **not** enable proxy, MCP, or always-on rules

Re-run safely; already-installed components are reused or skipped.

### 2. Verify (new chat)

Paste [`docs/prompts/verify.md`](prompts/verify.md) in a **fresh chat** after
install. It audits RTK hooks, Caveman copy, dormant policies, MCP at idle (0),
and stray always-on rules — and repairs with approval.

### 3. Per-chat activation

At the start of each chat, paste an activation prompt or use a slash command:

| Tier | Slash command | Alias | Activation prompt |
| --- | --- | --- | --- |
| low | `/maoleve-low` | `maoleve-low`, `start maoleve low`, `maolevelow` | [activate-low.md](prompts/activate-low.md) |
| fast | `/maoleve-fast` | `maoleve-fast`, `start maoleve fast`, `maolevefast` | [activate-fast.md](prompts/activate-fast.md) |
| medium (default) | `/maoleve-medium` | `maoleve-medium`, `start maoleve medium`, `maolevemedium`, or bare `maoleve` | [activate-medium.md](prompts/activate-medium.md) |
| high | `/maoleve-high` | `maoleve-high`, `start maoleve high`, `maolevehigh` | [activate-high.md](prompts/activate-high.md) |
| full | `/maoleve-full` | `maoleve-full`, `start maoleve full`, `maolevefull` | [activate-full.md](prompts/activate-full.md) |

Activation tells the agent which compression layers, proxy, and MCP to use **for
that chat only**. Manual pre-steps (e.g. `headroom wrap`, starting Serena MCP)
are documented in the activation prompts.

## Supported agents and install coverage

| Agent | Caveman / tier skills | RTK hooks | Dormant policy surface |
| --- | --- | --- | --- |
| Codex | `~/.codex/skills/{caveman,maoleve-*}/` | `rtk init --global --codex` | `~/.codex/AGENTS.md` |
| OpenCode | `~/.config/opencode/skills/{caveman,maoleve-*}/` | `rtk init --global --opencode` | `~/.config/opencode/AGENTS.md` |
| Claude Code | `~/.claude/skills/{caveman,maoleve-*}/` | `rtk init --global` | `~/.claude/CLAUDE.md` |
| Cursor IDE | `~/.cursor/skills/{caveman,maoleve-*}/` | `rtk init --global --agent cursor` | `~/.cursor/rules/maoleve.mdc` |
| Cursor Agents | `~/.cursor/skills/{caveman,maoleve-*}/` | `rtk init --global --agent cursor` | project `AGENTS.md` |

All authorized agents also receive `~/.agents/skills/caveman/` and the five
`maoleve-*` tier skills plus RTK,
Headroom, and Serena binaries. See [install.md](prompts/install.md) for merge
rules and idempotent re-run behavior.

## Supported agents and their native configuration

Mão leve adds a marked, Mão leve-managed layer in the native surface of only the
agents you authorize. Policy applies **when a tier is activated**, not globally.

| Agent | Native rule or configuration surface |
| --- | --- |
| Codex | `AGENTS.md` guidance, with its native configuration kept separate. |
| OpenCode | `AGENTS.md` guidance plus only selected plugin or MCP entries. |
| Cursor Agents (`cursor-agent`) | Terminal-facing guidance compatible with Cursor Agents, without assuming Cursor IDE-only features. |
| Cursor IDE | Cursor rules file (`alwaysApply: false`) with concise project context and shell guidance. |
| Claude Code | `CLAUDE.md` guidance plus selected hook, MCP, or plugin entries. |

The setup agent first identifies the active agent instead of guessing from a
directory name or environment variable.

## Token-economy tools (in scope)

| Tool | Tiers (when activated) | Role |
| --- | --- | --- |
| RTK | all | Compact shell-command output |
| Caveman | all (full skill set from medium+) | Concise technical response style; skills copied from repo |
| Headroom | fast+ | Context compression and model-call proxying |
| Serena | high, full | Symbol-level code navigation (MCP, dashboard off) |

Caveman skills are **vendored** from `.agents/skills/caveman*` in the checkout —
not fetched with `npx skills add`.

## Out of scope

Playwright MCP and other non–token-economy MCP are not part of Mão leve tier
flows unless you explicitly request them outside this harness.

## Complementary configuration, not replacement

Your existing harness wins. Mão leve adds an identifiable owned layer; it does
not replace your workflow.

- The agent reads existing configuration before proposing an edit.
- Existing model choices, plugins, rules, commands, hooks, unknown fields,
  formatting, and ordering remain intact whenever possible.
- It adds only approved Mão leve entries that are absent. On a later run, it
  updates only entries already marked as Mão leve-managed.
- When a format cannot be merged safely, the agent pauses for human
  confirmation before any backup-and-rewrite flow.

## Discovery and credentials

Use the **single approval card** in [`supervised-setup.md`](supervised-setup.md).
Default config access is structure only (no secret values). Credential-bearing
sources require explicit `edit:` on the card naming each file.

Discovery is not adoption. Finding a component in a harness does not authorize
using it for a new integration unless it is on the approved agent list.

## Repair

Re-run [`install.md`](prompts/install.md) to realign binaries and templates.
Re-run [`verify.md`](prompts/verify.md) in a new chat to audit and fix drift.
Re-paste an activation prompt to restore tier behavior for a chat.

## Uninstall

To remove a prompt-only install (reverse [`install.md`](prompts/install.md)),
paste [`uninstall.md`](prompts/uninstall.md) in a new chat. It removes dormant
policies, vendored Caveman copies, and RTK hooks — idempotent and supervised.

## What completion looks like

**Install:** tools on disk, MCP count 0, policy dormant.

**Verify:** verification report all pass (or fixes applied with approval).

**Activation:** agent confirms tier for the current chat and follows that stack.

Related repository material:

- [Repository README](../README.md)
- [Supervised setup flow](supervised-setup.md)
- [Operational prompt](../PROMPT.md)
- [Token economy tiers](token-tiers.md)
- [Version lock](../versions.env)
