# Mão leve Policy

Apply **only when a Mão leve tier is activated** for the current chat
(`/maoleve-<tier>` or `docs/prompts/activate-<tier>.md`).

- Keep the harness Linux-only and shell-first.
- Prefer the smallest sufficient tool chain.
- Use Headroom for context compression and proxying when selected for this chat.
- Use RTK for shell output compression when selected for this chat.
- Use Caveman for terse model output, compact reviews, and commit text when selected for this chat.
- Use Serena only when selected for this chat for symbol-level navigation or memory.
- Do not run broad tests or broad refactors unless explicitly requested.
- Start with targeted reads and exact searches before anything larger.
- Treat `versions.env` as the lock file; warn on drift instead of upgrading blindly.
- Overwrite stale local config for this repo; do not preserve irrelevant legacy setup.
- Keep all user-facing text in English.
