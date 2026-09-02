# Deprecated: shell installer and `maoleve` CLI

**Canonical setup:** copy-paste install prompts under [`docs/prompts/`](docs/prompts/).
Pick a tier in [`docs/token-tiers.md`](docs/token-tiers.md), paste the prompt into
your coding agent, and follow its supervised steps.

| Legacy | Status |
| --- | --- |
| `install.sh` | Clone-only helper; does not configure agents |
| `bin/maoleve` | Legacy launcher; do not use for new setups |
| `maoleve apply` / `maoleve tools` / `maoleve claude` | Blast-install paths; conflict with supervised tiers |

## Why prompts replaced the CLI

- Per-integration opt-in instead of writing six MCP servers to every agent
- Merge-preserving edits with human approval at each step
- Tier-scoped installs (low → full) without hidden defaults
- Vendored assets (Caveman skills, policy templates) copied from this repo

## Migration

1. Choose a tier: [docs/token-tiers.md](docs/token-tiers.md)
2. Paste the matching `docs/prompts/install-<tier>.md` prompt into your agent
3. Remove legacy MCP entries (tokensave, Playwright, Context7, Firecrawl) if
   `maoleve apply` ran previously — the tier prompt lists what to keep
