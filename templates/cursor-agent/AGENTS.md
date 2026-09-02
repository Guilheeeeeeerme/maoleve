# Mão leve Policy (Cursor Agents)

Terminal-facing policy for `cursor-agent`. Apply **only when a Mão leve tier is
activated** for the current chat (`/maoleve-<tier>` or
`start maoleve <tier>`, `maoleve<tier>`, or the matching activation prompt).
A bare `maoleve` means the default **medium** tier. Treat `start maoleve
<tier>` and `maoleve<tier>` as activation requests too. Do not assume Cursor IDE rules,
IDE-only MCP, or Cursor Settings UI.

- Keep the harness Linux-only and shell-first.
- Prefer the smallest sufficient tool chain.
- Use RTK for shell output compression when selected (prefix shell commands with `rtk`).
- Use Caveman for terse model output when selected.
- Use Headroom only when selected and applicable (Cursor Agents have no documented wrap).
- Use Serena only when selected for symbol-level navigation.
- Do not run broad tests or broad refactors unless explicitly requested.
- Start with targeted reads and exact searches before anything larger.
- Treat `versions.env` as the lock file; warn on drift instead of upgrading blindly.
- Keep all user-facing text in English.
