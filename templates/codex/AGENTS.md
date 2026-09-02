# Mão leve Policy

Apply **only when a Mão leve tier is activated** for the current chat
(`/maoleve-<tier>`, `start maoleve <tier>`, `maoleve<tier>`, or the matching
activation prompt). A bare `maoleve` means the default **medium** tier.
Treat `start maoleve <tier>` and `maoleve<tier>` as activation requests too.

- Keep the harness Linux-only and shell-first.
- Prefer the smallest sufficient tool chain.
- Use Headroom for context compression and proxying when selected for this chat.
- Use RTK for shell output compression when selected for this chat.
- Use Caveman for terse model output, compact reviews, and commit text when selected for this chat.
- Use Serena only when selected for this chat for symbol-level navigation or memory.
- Do not run broad tests or broad refactors unless explicitly requested.
- Start with targeted reads and exact searches before anything larger.
- Overwrite stale local config for this repo; do not preserve irrelevant legacy setup.
- Keep all user-facing text in English.

@~/.codex/RTK.md


<!-- headroom:rtk-instructions -->
# RTK (Rust Token Killer) - Token-Optimized Commands

When running shell commands **and RTK is selected for this chat**, prefix with
`rtk`. This reduces context usage by 60-90% with zero behavior change. If rtk
has no filter for a command, it passes through unchanged.

## Key Commands
```bash
# Git (59-80% savings)
rtk git status          rtk git diff            rtk git log

# Files & Search (60-75% savings)
rtk ls <path>           rtk read <file>         rtk grep <pattern>
rtk find <pattern>      rtk diff <file>

# Test (90-99% savings) — shows failures only
rtk pytest tests/       rtk cargo test          rtk test <cmd>

# Build & Lint (80-90% savings) — shows errors only
rtk tsc                 rtk lint                rtk cargo build
rtk prettier --check    rtk mypy                rtk ruff check

# Analysis (70-90% savings)
rtk err <cmd>           rtk log <file>          rtk json <file>
rtk summary <cmd>       rtk deps                rtk env

# GitHub (26-87% savings)
rtk gh pr view <n>      rtk gh run list         rtk gh issue list

# Infrastructure (85% savings)
rtk docker ps           rtk kubectl get         rtk docker logs <c>

# Package managers (70-90% savings)
rtk pip list            rtk pnpm install        rtk npm run <script>
```

## Rules
- When RTK is selected for this chat, prefix command chains: `rtk git add . && rtk git commit -m "msg"`
- For debugging, use raw command without rtk prefix
- `rtk proxy <cmd>` runs command without filtering but tracks usage
<!-- /headroom:rtk-instructions -->
