# Supervised setup (shared)

All Mão leve prompts (`install.md`, `verify.md`, `uninstall.md`, tier
activation) use **this file** for discovery, the **single approval card**, and
merge rules. Do not invent a different question sequence per prompt.

## Discovery (before asking)

Run **non-destructive** checks first. Use results to pre-fill the approval
card — do not ask the human to repeat what you can detect.

1. **Platform:** OS, shell, package manager (`apt`, `brew`, etc.).
2. **Active agent:** infer from the session (Cursor IDE, Cursor Agents /
   `cursor-agent`, Codex, OpenCode, Claude Code). Do not guess from directory
   names alone; combine session context with harness paths.
3. **Harness presence** (directory or config file exists):

   | Agent | Signal |
   | --- | --- |
   | Codex | `~/.codex/` |
   | OpenCode | `~/.config/opencode/` |
   | Claude Code | `~/.claude/` |
   | Cursor IDE | `~/.cursor/` |
   | Cursor Agents | `cursor-agent` on `PATH` or project `AGENTS.md` |

4. **Checkout:** `MAOLEVE_CHECKOUT`, then the current repository, then an
   explicitly chosen path under `${XDG_DATA_HOME:-$HOME/.local/share}/maoleve`.
   Never assume or create `~/maoleve`. Note clone vs update and whether the tree
   is dirty.
5. **Binaries:** `rtk --version`, `headroom --version`, `serena --version`
   vs `versions.env` (warn on drift; do not refuse).
6. **Mão leve state per detected agent:** Caveman mirror, RTK hook, dormant
   policy (`BEGIN MAOLEVE` / `maoleve.mdc`), existing backups.

Never read or print secret values during discovery. MCP/config inspection is
**structure only** (server names, hook keys, file paths).

## Single approval card

Present **one** summary table, then wait for a single reply. Valid replies:
`approve`, `edit: …`, `skip`, or `manual`.

```text
Mão leve setup — confirm or edit

Phase:        <install | verify | uninstall | activate-<tier>>
Checkout:     <path | use current | clone XDG data path | update existing | skip>
Agents:       <comma-separated from defaults below>
Config access: structure only (no secret values)  [default: yes]
Scope:        <one line: e.g. dormant install; no proxy/MCP/always-on>

Detected:
  Platform: … | Active agent: …
  Harnesses: …
  Binaries: rtk … | headroom … | serena …
  Already installed: …

Defaults:
  Agents = active agent + every harness row above that exists on disk.
  Cursor Agents policy → <workspace-root>/AGENTS.md unless you specify another path.

Reply approve, or edit what differs.
```

**Phase-specific scope lines (fixed — do not re-ask as separate questions):**

| Phase | Scope line |
| --- | --- |
| install | Dormant binaries, Caveman, policy templates; no proxy, MCP, or always-on rules |
| verify | Read-check-fix; no tier activation or proxy/MCP enablement |
| uninstall | Remove install.md artifacts only; binaries optional (see below) |
| activate | Apply tier for **this chat only** |

**Uninstall only:** add one row to the card: `Remove binaries: no (default)`.
Change to `yes` only if the human edits it to `yes` for RTK, Headroom, and/or
Serena explicitly.

**Install / verify:** config access defaults to **structure only**. Do not ask
a separate credentials question unless the human requests reading
`env.local`, `auth.json`, or similar — then require explicit `edit:` naming
each source.

Do **not** ask separate questions for “inspect active agent”, “inspect other
agents”, or “credential sources” when the card already covers agents and
structure-only access. One card replaces them.

## After approval

- **Checkout mutation** (clone/fetch) only after `approve` or an `edit:` that
  includes checkout.
- **Configure only listed agents.** One agent on the card does not imply another.
- **Idempotent:** reuse or skip when version and `BEGIN MAOLEVE` markers match;
  repair only gaps.
- Never `git reset --hard`, `git checkout --`, or destructive cleanup.

## Configuration merge

- Read existing files before editing; backup before repair (`*.bak-maoleve-*`).
- Preserve credentials, models, plugins, rules, hooks, unknown fields, order.
- Add only absent Mão leve entries inside stable markers:

  ```text
  <!-- BEGIN MAOLEVE -->
  …
  <!-- END MAOLEVE -->
  ```

  Cursor IDE uses dedicated `~/.cursor/rules/maoleve.mdc` with
  `alwaysApply: false` (whole file is Mão leve-owned).

- **RTK coexistence:** if `rtk init` already added `@RTK.md` or hooks, keep
  them; append policy below or beside, do not duplicate RTK blocks.
- **OpenCode:** merge `instructions` in `opencode.json` to include
  `~/.config/opencode/AGENTS.md` when missing; do not touch unrelated MCP.
- **Cursor Agents:** merge into project `AGENTS.md` at workspace/git root unless
  the card specifies another path.
- Policy wording stays **when selected / per-chat** — never always-on.
- Show a short diff or bullet summary before ambiguous edits.
- Never print secret values.

## RTK install URL

Upstream `main` branch may 404. Use this pattern:

```bash
install_rtk() {
  for branch in master main; do
    url="https://raw.githubusercontent.com/rtk-ai/rtk/${branch}/install.sh"
    if curl -fsSL "$url" -o /tmp/rtk-install.sh; then
      sh /tmp/rtk-install.sh && return 0
    fi
  done
  echo "RTK install failed: neither master nor main install.sh reachable" >&2
  return 1
}
```

Prefer the version in `versions.env`; warn if the installed semver drifts.

## Completion report

Every phase ends with a short English report: platform, checkout, authorized
agents, per-component installed/reused/skipped/manual/failed, credentials
preserved (yes/no), next step. Shape is defined in each prompt file.
