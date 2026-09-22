# Mão leve — supervised setup contract

Mão leve installs via `scripts/maoleve.sh`, never by free-form agent edits.
This doc records the merge contract the script implements, so the agent can
verify and explain without improvising.

## What the installer writes

- **Policy blocks** — only inside `# BEGIN MAOLEVE` … `# END MAOLEVE` markers
  (or a `maoleve.mdc` Cursor rule file); existing content is otherwise
  preserved verbatim, including formatting.
- **Skills** — symbolic links (fallback copies) into each authorized agent's
  native skill directory.
- **rtk hooks** — installed through `rtk init -g`, only for agents where the
  human approved: auto for `claude-code`/`opencode`, opt-in via `--hooks` for
  `codex`/`cursor-*` (known crash sources).
- **Manifest** — every touched path and hook target is recorded in
  `$MAOLEVE_HOME/manifest` (default `${XDG_STATE_HOME:-$HOME/.local/state}/maoleve/manifest`).
  `uninstall` reverses exactly the manifest.

## What the installer never does

- Never enables Headroom proxy/wrap, MCP registration, always-on policy, or
  `alwaysApply` rules — these happen per chat through a tier activation, not at
  install time.
- Never downgrades a binary. `versions.env` is the minimum floor; satisfied
  versions are left untouched, below-floor versions are reported for manual
  upgrade.
- Never reads, copies, or exposes secret values; credentials are referenced by
  variable name only.
- Never deletes whole config files unless the file consists entirely of
  Mão leve-owned content (then removal is safe).

## Failure mode

Any step that errors prints `warn` and the run continues; report says which
items failed. Re-running install is idempotent: existing blocks, skills, and
hooks are skipped or updated in place.
