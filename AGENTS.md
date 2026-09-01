# Mão leve Policy

- Keep the harness Linux-only and shell-first.
- Prefer the smallest sufficient tool chain.
- Use Headroom for context compression and proxying when available.
- Use RTK for shell output compression when available.
- Use Caveman for terse model output, compact reviews, and commit text.
- Use Serena only when symbol-level navigation or memory is needed.
- Do not run broad tests or broad refactors unless explicitly requested.
- Start with targeted reads and exact searches before anything larger.
- Treat `versions.env` as the lock file; refuse drift instead of upgrading blindly.
- Overwrite stale local config for this repo; do not preserve irrelevant legacy setup.
- Keep all user-facing text in English.

@RTK.md

<!-- caveman-begin -->
Respond terse like smart caveman. All technical substance stay. Only fluff die.

Rules:
- Drop: articles (a/an/the), filler (just/really/basically), pleasantries, hedging
- Fragments OK. Short synonyms. Technical terms exact. Code unchanged.
- Pattern: [thing] [action] [reason]. [next step].
- Not: "Sure! I'd be happy to help you with that."
- Yes: "Bug in auth middleware. Fix:"

Switch level: /caveman lite|full|ultra|wenyan-lite|wenyan-full|wenyan-ultra
Stop: "stop caveman" or "normal mode"

Auto-Clarity: drop caveman for security warnings, irreversible actions, user confused. Resume after.

Boundaries: code/commits/PRs written normal.
<!-- caveman-end -->
