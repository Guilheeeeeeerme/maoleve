---
name: repomix
description: Pack a repository into one context-ready bundle on demand (repomix, opt-in via MAOLEVE_ENABLE_REPOMIX). Use for high-tier context retrieval when exploring unknown directories. MCP mode is optional and unregistered by default.
disable-model-invocation: true
---

# repomix — on-demand context packing (opt-in)

Opt-in only: this skill is installed when `MAOLEVE_ENABLE_REPOMIX=y` at install
time. It is a run-on-demand CLI, never a hook, daemon, or in-path wrapper.

## Invocation

Pinned version is `versions.env` (`MAOLEVE_REPOMIX_VERSION`, lock file — warn on
drift, never auto-upgrade). Node >= 18 is the npx prerequisite; cold-start
npx latency (~first-run download) is expected once per host.

Single command, standard output:

```
npx -y repomix@MAOLEVE_REPOMIX_VERSION --stdout --style markdown
```

Substitute the pinned literal (e.g. `repomix@1.18.1`).

## Token-budget fail-fast rule

- Pack against the narrowest path set (one or a few directories), never the whole repo.
- `--token-budget 4000` is a fail-fast cap of four thousand tokens; if the plan exceeds it, stop and narrow the scope instead of raising it silently.
- Plain `--stdout` is the default form (`--compress` costs ~0.002 fidelity on a full-repo run; picked here to enable a token budget estimate).
- The value of this adapter is **retrieval coverage below full tier**, not token reduction. Serena owns symbol retrieval; repomix fills unknown-directory scans Serena does not yet point at.

## MCP mode (optional, off by default)

`repomix --mcp` exposes a local stdio MCP server. This stack registers nothing
into any MCP server config; if you run it, keep it session-only and inside the
MCP/CLI/files envelope, and never commit it into committed agent config files.

## Fail-fast

If `npx` cannot proceed (no Node, no network for caches, or the run returns nothing), stop immediately and tell the user which floor is missing; do not retry silently.
