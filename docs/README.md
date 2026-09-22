# Mão leve guided setup

Mão leve is a supervised, **prompt-only** setup layer for coding agents. Run
**one-time install** once, then activate a tier at the start of each chat. No
custom CLI required — installs run through `scripts/maoleve.sh` in the checkout.

Tested primarily on Ubuntu Linux; compatible Linux and macOS are best-effort.
`versions.env` is the supported-version **floor**: the installer offers missing
binaries, leaves your newer versions untouched, warns on drift, and never
downgrades.

## Workflow

### 1. One-time install

Paste [`docs/prompts/install.md`](prompts/install.md) once per machine. It
locates or clones the checkout and runs `scripts/maoleve.sh install`, which:

- Detects the running agent and shows one approval card
- Installs only the binaries you agree to (missing ones; never downgrades)
- Links skills into the running agent's native skill dir (all agents with
  `--all-agents`)
- Merges **dormant**, marked policy blocks; enables rtk hooks where safe
  (`claude-code`, `opencode` — codex/cursor are opt-in via `--hooks`)
- Records everything in a manifest so uninstall reverses exactly that
- Never enables proxy, MCP, or always-on rules

Re-run safely: existing blocks, links, and hooks are skipped.

### 2. Activate a tier per chat

At the start of each chat paste an activation prompt or slash command:

| Tier | Slash command | Alias | Activation prompt |
| --- | --- | --- | --- |
| low | `/maoleve-low` | `maoleve-low`, `maolevelow` | [activate-low.md](prompts/activate-low.md) |
| fast | `/maoleve-fast` | `maoleve-fast`, `maolevefast` | [activate-fast.md](prompts/activate-fast.md) |
| medium (default) | `/maoleve-medium` | `maoleve-medium`, bare `maoleve` | [activate-medium.md](prompts/activate-medium.md) |
| high | `/maoleve-high` | `maoleve-high`, `maolevehigh` | [activate-high.md](prompts/activate-high.md) |
| full | `/maoleve-full` | `maoleve-full`, `maolevefull` | [activate-full.md](prompts/activate-full.md) |

Activation tells the agent which layers to use **for that chat only**.
Pick guidance with pros/cons/caveats and recommended defaults lives in
[`token-tiers.md`](token-tiers.md).

## Status, doctor, uninstall

- [`prompts/status.md`](prompts/status.md) — read-only audit plus a doctor pass
  for known crash signatures (e.g. dangling rtk hook references in codex/cursor
  configs, duplicate skill registrations).
- [`prompts/uninstall.md`](prompts/uninstall.md) — reverses exactly what the
  manifest recorded, then reports a definitive
  *"Mão leve fully removed: yes."* verdict. Binaries are kept unless you
  approve their removal at the end.

## Token-economy tools (in scope)

| Tool | Tiers (when activated) | Role |
| --- | --- | --- |
| RTK | all | Compact shell-command output |
| Caveman | all (full skill set from medium+) | Terse technical response style |
| Headroom | fast+ | Context compression and model-call proxy |
| Serena | high, full | Symbol-level navigation (MCP, dashboard off) |

Caveman skills are **vendored** from `.agents/skills/caveman*` in the checkout —
not fetched with `npx skills add`.

## Out of scope

Playwright MCP and other non–token-economy MCP are not part of Mão leve tier
flows unless you explicitly request them.

## Complementary configuration, not replacement

Your existing harness wins. Mão leve adds an identifiable owned layer; it does
not replace your workflow.

- The agent reads existing configuration before proposing an edit.
- Existing model choices, plugins, rules, commands, hooks, unknown fields,
  formatting, and ordering remain intact.
- It adds only approved Mão leve entries that are absent; later runs update only
  Mão leve-marked entries.
- When a format cannot be merged safely, the agent pauses for human
  confirmation before any backup-and-rewrite flow.

## Repair

Anything crashy after install? Run [`prompts/status.md`](prompts/status.md)
first; its doctor pass pinpoints known causes. Re-running
[`install.md`](prompts/install.md) realigns binaries and templates. To fully
back out, use [`prompts/uninstall.md`](prompts/uninstall.md).

## What completion looks like

**Install:** tools on disk, MCP count 0, policy dormant, manifest written.

**Status:** doctor pass shows no known crash signatures.
