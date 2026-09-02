# Mão leve guided setup

Mão leve is a supervised, **prompt-only** setup layer for coding agents. Pick a
token-economy tier, paste the install prompt, approve each step. No custom CLI
required.

Tested primarily on Ubuntu Linux; compatible Linux and macOS are best-effort.
The setup agent identifies the platform, explains its plan, and asks before it
clones or updates the checkout, inspects or changes configuration, installs
anything, or reads credentials.

For current instructions, this guide, [`docs/token-tiers.md`](token-tiers.md), and
[`PROMPT.md`](../PROMPT.md) take precedence over older product-planning material.
`versions.env` is the supported-version baseline: setup warns on semver-breaking
drift instead of refusing to run or silently upgrading.

## Pick a tier, paste a prompt

1. Read the [tier comparison](token-tiers.md) and choose **low**, **fast**,
   **medium** (default), **high**, or **full**.
2. Open the matching install prompt and copy everything below the line into
   your coding agent.

| Tier | Prompt |
| --- | --- |
| low | [install-low.md](prompts/install-low.md) |
| fast | [install-fast.md](prompts/install-fast.md) |
| medium | [install-medium.md](prompts/install-medium.md) |
| high | [install-high.md](prompts/install-high.md) |
| full | [install-full.md](prompts/install-full.md) |

Each prompt is self-contained: agent identification, approval gates, checkout
clone/update, vendored Caveman skill copy from the repo, binary install only
when the tier requires it, agent-native configuration, and a verification report.

Do **not** run `install.sh` or `bin/maoleve apply` for new setups. See
[`DEPRECATED.md`](../DEPRECATED.md).

## Supported agents and their native configuration

Mão leve adds a marked, Mão leve-managed layer in the native surface of only the
agents you authorize.

| Agent | Native rule or configuration surface |
| --- | --- |
| Codex | `AGENTS.md` guidance, with its native configuration kept separate. |
| OpenCode | `AGENTS.md` guidance plus only selected plugin or MCP entries. |
| Cursor Agents (`cursor-agent`) | Terminal-facing guidance compatible with Cursor Agents, without assuming Cursor IDE-only features. |
| Cursor IDE | Cursor rules file with concise project context and shell guidance. |
| Claude Code | `CLAUDE.md` guidance plus selected hook, MCP, or plugin entries. |

The setup agent first identifies the active agent instead of guessing from a
directory name or environment variable.

## Token-economy tools (in scope)

| Tool | Tiers | Role |
| --- | --- | --- |
| RTK | all | Compact shell-command output |
| Caveman | all (full skill set from medium+) | Concise technical response style; skills copied from repo |
| Headroom | fast+ | Context compression and model-call proxying |
| Serena | high, full | Symbol-level code navigation (MCP, dashboard off) |

Caveman skills are **vendored** from `.agents/skills/caveman*` in the checkout —
not fetched with `npx skills add`.

## Out of scope (all tiers)

Speckit, Superpowers, Firecrawl, Context7, Playwright MCP, and tokensave are
not part of tier prompts unless you explicitly request them outside this flow.

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

Inspecting the active agent and inspecting other agents are separate
permissions. Credential-bearing sources require explicit authorization, named
per source. The agent never prints secret values.

Discovery is not adoption. Finding a component or credential in an authorized
source does not authorize its use for a newly selected integration.

## Repair

Recovery applies only to selected Mão leve-managed components. Re-run the
appropriate tier prompt to realign after drift or partial installs.

## What completion looks like

The tier prompt's verification block defines completion. The agent reports each
item as installed, reused, skipped, manual, or failed.

Related repository material:

- [Repository README](../README.md)
- [Operational prompt](../PROMPT.md)
- [Token economy tiers](token-tiers.md)
- [Version lock](../versions.env)
- [Deprecated CLI](../DEPRECATED.md)
