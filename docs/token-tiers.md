# Token economy tiers

Mão leve is **prompt-only**: pick a tier, paste the matching install prompt into
your coding agent. No `maoleve` CLI required. Vendored assets (Caveman skill,
policy templates) live in this repo and are **copied** into agent-native paths.

Supported agents: **Codex**, **OpenCode**, **Cursor IDE**, **Cursor Agents**
(`cursor-agent`), and **Claude Code**.

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

| Tier | Tools enabled | Expected token savings (indicative) | Latency tradeoff | MCP at idle |
| --- | --- | --- | --- | --- |
| **low** | RTK, Caveman policy + vendored skill copy | **Input:** 60–90% on shell output (RTK). **Output:** ~30–65% when Caveman applies. | **Lowest.** RTK hook &lt;10 ms/command; no proxy or MCP. | **0** |
| **fast** | low + Headroom **proxy** (wrap) | **Input:** +15–40% on tool/API traffic via proxy. Shell savings unchanged. | **Low–medium.** Proxy startup ~1–3 s once; no MCP tool-schema tax. | **0** |
| **medium** | fast + full Caveman skill copy + policy templates from repo | **Output:** full Caveman skill catalog. **Input:** proxy + RTK as in fast. | **Medium** (same as fast). | **0** |
| **high** | medium + **Serena** MCP (`--open-web-dashboard False`) | **Input:** symbol-level reads vs whole files on large repos. | **Medium–high.** LSP indexing at project attach. | **1** (Serena) |
| **full** | high + Headroom MCP on **Cursor IDE only** (if not using proxy URL) + all policy templates | Combined proxy + optional on-demand MCP compression on Cursor. | **Highest** acceptable for max savings. | **≤2** |

## Vendored copy layout

Copy from the Mão leve checkout (`CHECKOUT`) — do not use `npx skills add` when
these paths exist:

| Repo path | Copy to (per authorized agent) |
| --- | --- |
| `.agents/skills/caveman/` | `~/.agents/skills/caveman/` (all agents) |
| same | `~/.cursor/skills/caveman/` (Cursor IDE / Agents) |
| same | `~/.codex/skills/caveman/` (Codex) |
| same | `~/.claude/skills/caveman/` (Claude Code) |
| `templates/codex/AGENTS.md` | `~/.codex/AGENTS.md` (merge; Codex) |
| `templates/opencode/AGENTS.md` | `~/.config/opencode/AGENTS.md` (OpenCode) |
| `templates/claude/CLAUDE.md` | `~/.claude/CLAUDE.md` (Claude Code) |
| `templates/cursor/maoleve.mdc` | `~/.cursor/rules/maoleve.mdc` (Cursor IDE) |
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

**Not in scope:** tokensave (legacy, heavy MCP schema), Speckit, Superpowers,
Firecrawl, Context7, Playwright.

## Headroom surface per agent

| Agent | Headroom (fast+) | MCP |
| --- | --- | --- |
| **Codex** | `headroom wrap codex --no-mcp` + proxy provider | Never Headroom MCP |
| **OpenCode** | `headroom wrap opencode --no-mcp` | Serena only at high+ |
| **Claude Code** | `headroom wrap claude --no-mcp` | Serena only at high+ |
| **Cursor IDE** | `headroom wrap cursor` or proxy base URL | Headroom MCP at full only if needed |
| **Cursor Agents** | Skip wrap | Serena at high+ if authorized; prefer bare MCP budget |

## Install prompts

| Tier | Prompt |
| --- | --- |
| low | [install-low.md](./prompts/install-low.md) |
| fast | [install-fast.md](./prompts/install-fast.md) |
| medium | [install-medium.md](./prompts/install-medium.md) |
| high | [install-high.md](./prompts/install-high.md) |
| full | [install-full.md](./prompts/install-full.md) |

## Version lock

Treat [`versions.env`](../versions.env) as the supported-version baseline. Warn
on semver-breaking drift; do not upgrade blindly.

## Legacy CLI

[`DEPRECATED.md`](../DEPRECATED.md) — `bin/maoleve` and blast-install paths are
not used by tier prompts.
