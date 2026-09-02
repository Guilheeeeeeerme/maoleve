# Token economy tiers

Mão leve is **prompt-only**: run **one-time install** once, then activate a tier
at the start of each chat. No `maoleve` CLI required. Vendored assets (Caveman
skills, policy templates) are **copied** during install but apply **per chat**
only when you paste an activation prompt.

Supported agents: **Codex**, **OpenCode**, **Cursor IDE**, **Cursor Agents**
(`cursor-agent`), and **Claude Code**.

## Workflow

1. **Once:** paste [`docs/prompts/install.md`](./prompts/install.md) — prepares
   RTK, Headroom, Serena binaries, Caveman copy, dormant policy templates.
   Does **not** enable proxy, MCP, or always-on rules. Idempotent on re-run.
2. **Verify (new chat):** paste [`docs/prompts/verify.md`](./prompts/verify.md)
   — audit status, confirm MCP 0 at idle, fix gaps with approval.
3. **Each chat:** paste a tier activation prompt (or use slash commands below).

## Slash commands and aliases

| Tier | Slash command | Alias (no slash) | Activation prompt |
| --- | --- | --- | --- |
| **low** | `/maoleve-low` | `maoleve-low` | [activate-low.md](./prompts/activate-low.md) |
| **fast** | `/maoleve-fast` | `maoleve-fast` | [activate-fast.md](./prompts/activate-fast.md) |
| **medium** | `/maoleve-medium` | `maoleve-medium` | [activate-medium.md](./prompts/activate-medium.md) |
| **high** | `/maoleve-high` | `maoleve-high` | [activate-high.md](./prompts/activate-high.md) |
| **full** | `/maoleve-full` | `maoleve-full` | [activate-full.md](./prompts/activate-full.md) |

Paste the activation file body below its title line, or type the slash command /
alias as the first message. The agent applies that tier **for the current chat
only** — not globally.

**Default tier:** **medium** if you do not specify.

## Tier semantics

| Tier | Intent | When to choose |
| --- | --- | --- |
| **low** | Fastest responses, minimal harness overhead | Short sessions, small repos, latency-sensitive work |
| **fast** | Speed-first with automatic traffic compression | Daily coding where proxy startup is acceptable |
| **medium** | Balanced token economy vs latency (**default**) | Most projects |
| **high** | Aggressive savings; accepts Serena indexing + MCP overhead | Medium/large codebases, multi-file refactors |
| **full** | Maximum local token stack, consistent policy | Long sessions, cost-sensitive power users |

## Comparison

Estimates come from upstream benchmarks (RTK, Headroom, Caveman, Serena).
Real savings depend on repo size, session length, and agent behavior.

| Tier | Stack (this chat) | Expected token savings (indicative) | Latency tradeoff | MCP at idle |
| --- | --- | --- | --- | --- |
| **low** | RTK + Caveman | **Input:** 60–90% on shell output (RTK). **Output:** ~30–65% when Caveman applies. | **Lowest.** RTK hook &lt;10 ms/command; no proxy or MCP. | **0** |
| **fast** | low + Headroom **proxy** (wrap) | **Input:** +15–40% on tool/API traffic via proxy. Shell savings unchanged. | **Low–medium.** Proxy startup ~1–3 s once; no MCP tool-schema tax. | **0** |
| **medium** | fast + full Caveman skills + policy | **Output:** full Caveman skill catalog. **Input:** proxy + RTK as in fast. | **Medium** (same as fast). | **0** |
| **high** | medium + **Serena** MCP (`--open-web-dashboard False`) | **Input:** symbol-level reads vs whole files on large repos. | **Medium–high.** LSP indexing at project attach. | **1** (Serena) |
| **full** | high + multi-agent consistency; Headroom MCP on **Cursor IDE only** if needed | Combined proxy + optional on-demand MCP compression on Cursor. | **Highest** acceptable for max savings. | **≤2** |

## Research: practical stack combinations (2025–2026)

Findings from public benchmarks and MCP guidance — not academic targets.

### Layered input + output (recommended baseline)

| Combination | What it optimizes | Practical note |
| --- | --- | --- |
| **RTK + Caveman** | Shell output (input) + agent prose (output) | Complementary streams; best **zero-MCP** baseline ([Codepointer replay](https://codepointer.substack.com/p/cutting-llm-token-costs-with-rtk)). |
| **RTK + Headroom proxy** | CLI output + in-flight API/tool payloads | Headroom wrap can register RTK hooks; proxy acts on wire, RTK on shell ([Headroom + RTK](https://github.com/RaiAnsar/mcp-gateway)). |
| **Above + Serena (high+)** | Symbol navigation vs whole-file reads | One MCP slot; pays off on medium/large repos; fixed schema overhead at session start ([Serena](https://github.com/oraios/serena)). |

### MCP budget and lazy loading

- Keep MCP tool definitions under ~**10–15%** of context; prefer **0–1 idle MCP**
  on low/medium/fast tiers ([MCP client best practices](https://modelcontextprotocol.io/docs/develop/clients/client-best-practices)).
- **Lazy / progressive discovery** (meta-tools, load-on-demand schemas) cuts idle
  schema tax ~85–97% vs eager loading when many servers exist ([mcp-tool-search](https://github.com/KGT24k/mcp-tool-search), [Tokenade lazy MCP](https://tokenade.net/en/articles/lazy-mcp-loading)).
- Mão leve default: **no MCP at install**; register Serena only when activating
  **high/full**; Headroom MCP only at **full** on Cursor IDE if needed.

### Per-session vs always-on rules

- **Always-on** system prompts and `alwaysApply` rules re-bill every turn (often
  as cache reads); tier policy should activate **per chat**, not globally
  ([THOL leaderboard](https://pi-infected.github.io/token-harness-optimizer-leaderboard/)).
- **Per-chat activation** (`/maoleve-medium`, etc.) matches how RTK/Caveman/Headroom
  are meant to be selected — install prepares binaries; activation selects layers.

### End-to-end cost caveat

Component-level savings (60–99% on a single grep) do not always reduce **billed
cost per completed task** if compression causes extra turns or cache invalidation
([PointFive arXiv 2607.12161](https://arxiv.org/abs/2607.12161), THOL). Validate
with provider invoices, not tool marketing alone.

### Mão leve tier → stack mapping

| Tier | Recommended combo |
| --- | --- |
| **low** | RTK + Caveman only |
| **fast** | low + Headroom proxy (`--no-mcp`) |
| **medium** | fast + full Caveman skills (default) |
| **high** | medium + Serena (dashboard off) |
| **full** | high + optional Headroom MCP on Cursor IDE; multi-agent consistency |

## Vendored copy layout

Copy from the Mão leve checkout (`CHECKOUT`) during **install** — do not use
`npx skills add` when these paths exist:

| Repo path | Copy to (per authorized agent) |
| --- | --- |
| `.agents/skills/caveman/` | `~/.agents/skills/caveman/` (all agents) |
| same | `~/.cursor/skills/caveman/` (Cursor IDE / Agents) |
| same | `~/.codex/skills/caveman/` (Codex) |
| same | `~/.claude/skills/caveman/` (Claude Code) |
| same | `~/.config/opencode/skills/caveman/` (OpenCode) |
| `templates/codex/AGENTS.md` | `~/.codex/AGENTS.md` (merge; dormant until activation) |
| `templates/opencode/AGENTS.md` | `~/.config/opencode/AGENTS.md` (OpenCode) |
| `templates/claude/CLAUDE.md` | `~/.claude/CLAUDE.md` (Claude Code) |
| `templates/cursor/maoleve.mdc` | `~/.cursor/rules/maoleve.mdc` (`alwaysApply: false`) |
| `templates/cursor-agent/AGENTS.md` | project `AGENTS.md` or agent policy path |

```bash
mkdir -p "$HOME/.agents/skills/caveman"
cp -a "$CHECKOUT/.agents/skills/caveman/." "$HOME/.agents/skills/caveman/"
```

## Tool roles (token economy only)

| Tool | Layer | Role |
| --- | --- | --- |
| **RTK** | Input (shell) | Compresses command output before it enters context. |
| **Headroom proxy** | Input (traffic) | Wrap/proxy compresses model traffic automatically. |
| **Headroom MCP** | Input (on-demand) | Cursor IDE only at **full** tier when proxy URL is not used. |
| **Caveman** | Output | Terse responses; skill copied from repo. |
| **Serena** | Input (navigation) | LSP symbol tools; dashboard must stay off. |

**Not in scope:** tokensave (legacy, heavy MCP schema), Playwright MCP.

## Headroom surface per agent

| Agent | Headroom (fast+) | MCP |
| --- | --- | --- |
| **Codex** | `headroom wrap codex --no-mcp` + proxy provider | Never Headroom MCP |
| **OpenCode** | `headroom wrap opencode --no-mcp` | Serena only at high+ |
| **Claude Code** | `headroom wrap claude --no-mcp` | Serena only at high+ |
| **Cursor IDE** | `headroom wrap cursor` or proxy base URL | Headroom MCP at full only if needed |
| **Cursor Agents** | Skip wrap | Serena at high+ if authorized; prefer bare MCP budget |

## Prompts

| Purpose | File |
| --- | --- |
| One-time setup | [install.md](./prompts/install.md) |
| Post-install audit (new chat) | [verify.md](./prompts/verify.md) |
| Remove legacy pre–prompt-only cruft | [uninstall-legacy.md](./prompts/uninstall-legacy.md) |
| Per-chat activation | [activate-low.md](./prompts/activate-low.md) … [activate-full.md](./prompts/activate-full.md) |

Legacy per-tier install prompts (`install-low.md`, etc.) are removed; use
**install + activate** instead.

## Version lock

Treat [`versions.env`](../versions.env) as the supported-version baseline. Warn
on semver-breaking drift; do not upgrade blindly.

## Measurement

Tool-reported savings (RTK, Headroom stats) are diagnostic only. Validate with
provider-billed cost per completed task. Token reduction does not always reduce
cost if compression triggers extra turns.

## Legacy CLI

[`DEPRECATED.md`](../DEPRECATED.md) — `bin/maoleve` and blast-install paths are
not used by tier prompts.
