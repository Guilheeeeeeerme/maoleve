# Token economy tiers

Mão leve is **prompt-only**: run **one-time install** once (`install.md`), then
activate a tier at the start of each chat. Install writes policy blocks and
skills but **never** turns on proxy, MCP, or always-on rules — tier activation
applies only to the current chat.

**Tier choice is yours.** Nothing is pre-selected: a bare `maoleve` means the
default **medium**, and every activation prompt below is what tells the agent
what to apply for that chat only.

## Choosing a tier

| Tier | Who should pick it | Pick it when |
| --- | --- | --- |
| **low** | Latency-first, fragile agents | Codex / Cursor until hooks are proven stable |
| **fast** | Daily coding with a proxy budget | You accept 1–3 s proxy startup |
| **medium** | Most users (**default**) | Balanced savings/latency |
| **high** | Medium/large repos | Symbol navigation pays for its indexing cost |
| **full** | Long sessions, cost-sensitive | You accept max overhead for max savings |

**Recommended:** `medium` with `claude-code` or `opencode` (hooks are stable
there); `low` with `codex` or `cursor-*` until you have verified the agent
stays stable with hooks enabled (`--hooks` flag on install).

## Tier defs

### low — RTK + Caveman, zero MCP, no proxy

- ✅ Pros: lowest latency; no proxy, no MCP, no extra processes. RTK saves 60–90 % on shell output.
- ⚠️ Cons: no context compression on tool/API traffic; no traffic compression means heavy tool results still land in context as-is.
- ✔️ Caveats: none observed; no known crash signature.

### fast — low + Headroom wrap/proxy

- ✅ Pros: +15–40 % on tool/API traffic; no MCP schema tax.
- ⚠️ Cons: 1–3 s proxy/wrap startup per session.
- ✔️ Caveats: wrap mode rebinds the running agent; if the proxy dies mid-session, responses stop until it restarts.

### medium — fast + full Caveman policy (**default**)

- ✅ Pros: fastest combined input/output savings at no MCP cost.
- ⚠️ Cons: same proxy caveats as fast.
- ✔️ Caveats: none beyond fast.

### high — medium + Serena MCP

- ✅ Pros: symbol-level reads cut inputs on large repos.
- ⚠️ Cons: LSP indexing cost at project attach; one MCP schema at idle.
- ✔️ Caveats: skip on small repos — indexing overhead overtakes symbol savings.

### full — high + multi-agent consistency

- ✅ Pros: deepest local stack for long sessions.
- ⚠️ Cons: highest accepted latency; Headroom MCP applies on Cursor IDE only.
- ✔️ Caveats: recommended if you have measured that the deeper layers pay off in your workflows; otherwise medium/high is the sweet spot.

## Stack per tier

| Tier | Stack |
| --- | --- |
| low | RTK + Caveman |
| fast | low + Headroom wrap (`--no-mcp`) |
| medium | fast + full Caveman templates |
| high | medium + Serena (`--open-web-dashboard False`) |
| full | high + Headroom MCP on Cursor IDE if needed |

## Headroom surface per agent

| Agent | Wrap/proxy (fast+) | MCP |
| --- | --- | --- |
| Codex | `headroom wrap codex --no-mcp` + proxy provider | never |
| OpenCode | `headroom wrap opencode --no-mcp` | Serena only at high+ |
| Claude Code | `headroom wrap claude --no-mcp` | Serena only at high+ |
| Cursor IDE | `headroom wrap cursor` | Headroom MCP only at full, if needed |
| Cursor Agents | skip wrap | Serena at high+ |

## rtk hook defaults per agent

| Agent | hooks on install |
| --- | --- |
| claude-code, opencode | on |
| codex, cursor-ide, cursor-agent | off — pass `--hooks` to enable (known crash source: dangling rtk references in these agents' configs) |

If your agent started crashing after install, run `status.md` or `uninstall.md`
before anything else; the doctor pass pins the cause.

## Version floor

`versions.env` is the **minimum** supported version, not a pin. Install offers to
add missing binaries, leaves your newer versions alone, warns when a binary is
below the floor, and never silently downgrades.

## Measuring

Tool-reported savings are diagnostic only; judge by provider-billed cost per
task. Compression can pay for itself or trigger extra turns — validate with
invoices, not tool marketing.
