---
name: maoleve-ccusage
description: On-demand local token accounting (ccusage, opt-in via MAOLEVE_ENABLE_CCUSAGE). Run on demand only — never a daemon, never in-path, never telemetry-bearing.
disable-model-invocation: true
---

# ccusage — run-on-demand usage accounting (opt-in)

Opt-in only: installed when `MAOLEVE_ENABLE_CCUSAGE=y` at install time.
Run-on-demand observability: zero cost is added to agent turns because the CLI
is never invoked in-path and runs no daemon.

## Invocation

Pinned version is `versions.env` (`MAOLEVE_CCUSAGE_VERSION`, lock file — warn
on drift, never auto-upgrade). Node >= 18 is the npx prerequisite.

Local/offline scan of agent-written JSONL logs already on disk:

```
npx -y ccusage@MAOLEVE_CCUSAGE_VERSION daily --offline
```

Substitute the pinned literal (e.g. `ccusage@20.0.24`).

## Rules

- ALWAYS pass `--offline`. The upstream README documents one cloud path; it must never be reached.
- Local-only: reads Claude Code, OpenCode, Codex local JSONL logs (other analyzers are unverified — report unverified before relying on them).
- No daemon, no background process, no telemetry; a plain markdown/JSON table of recorded actuals.
- Sessions-only state: nothing is added to committed agent config files.
- If the scan fails (no JSONL found, npx unusable), stop and say so; do not retry silently or reach for the cloud path.
