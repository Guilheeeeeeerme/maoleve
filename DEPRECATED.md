# Deprecated: shell installer and `maoleve` CLI

**Canonical setup:**

1. **Once:** [`docs/prompts/install.md`](docs/prompts/install.md) — prepare tools
   and templates (no global proxy/MCP/rules).
2. **Each chat:** [`docs/prompts/activate-<tier>.md`](docs/prompts/) or
   `/maoleve-<tier>` — see [`docs/token-tiers.md`](docs/token-tiers.md).

| Legacy | Status |
| --- | --- |
| `install.sh` | Clone-only helper; does not configure agents |
| `bin/maoleve` | Legacy launcher; do not use for new setups |
| `maoleve apply` / `maoleve tools` / `maoleve claude` | Blast-install paths; conflict with supervised flow |

## Why prompts replaced the CLI

- Per-integration opt-in instead of writing six MCP servers to every agent
- Merge-preserving edits with human approval at each step
- Tier-scoped **per-chat activation** (low → full) without hidden always-on defaults
- Vendored assets (Caveman skills, policy templates) copied from this repo

## Migration

1. Run one-time install: [docs/prompts/install.md](docs/prompts/install.md)
2. Start each chat with `/maoleve-medium` (or another tier) or paste
   `docs/prompts/activate-<tier>.md`
3. Remove legacy MCP entries (tokensave, Playwright) if `maoleve apply` ran
   previously — activation prompts list what to keep

Legacy per-tier install prompts (`install-low.md`, etc.) are removed.
