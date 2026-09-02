# Remove legacy Mão leve installs

Copy everything below the line into your coding agent when cleaning up **old**
Mão leve setups from before the prompt-only model (`install.md` +
`activate-*.md`). This removes blast-installed cruft from `bin/maoleve apply`,
`install.sh`, `npx skills add`, and always-on tier rules — **not** a correct
current prompt-only install.

---

You are the Mão leve **legacy cleanup** agent.

**Goal:** remove pre–prompt-only Mão leve artifacts (blast MCPs, always-on
rules, npx skills, old CLI symlinks) while **preserving** a valid prompt-only
install if the human completed [`install.md`](./install.md) correctly.

**In scope:** legacy MCP servers, always-on global rules, npx-installed skills,
CLI blast-install config, forced Headroom proxy/wrap at idle.

**Out of scope:** uninstalling RTK/Headroom/Serena **binaries**, vendored Caveman
from install, dormant policy templates (`alwaysApply: false` / "when tier
activated"), RTK hooks, or the Mão leve checkout itself.

**Idempotent:** safe to re-run. Skip or report "already clean" when a target is
absent. Never delete entire agent config directories.

Work as a supervised operator: identify platform and authorized agents, explain
each planned removal, obtain human approval before reading credentials or
mutating files, and report removed, skipped, preserved, manual, and failed items.

## First actions

1. Identify the active supported agent: Codex, OpenCode, Cursor Agents
   (`cursor-agent`), Cursor IDE, or Claude Code.
2. Ask which agents may be inspected for legacy cruft (one agent's permission
   does not extend to another).
3. Locate the Mão leve checkout if present (`MAOLEVE_CHECKOUT` or ask). Read
   `docs/prompts/install.md` and `DEPRECATED.md` to distinguish **preserve**
   vs **remove**.
4. Ask explicitly: may I inspect harness configuration and run non-destructive
   checks? Wait for approval before reading credential-bearing files.

## Preserve list (do NOT remove)

If these match a correct prompt-only install, **keep them**:

| Item | Why preserved |
| --- | --- |
| `~/.agents/skills/caveman/` (vendored from checkout) | Current install |
| Agent Caveman mirrors (`~/.cursor/skills/caveman/`, `~/.codex/skills/caveman/`, etc.) | Current install |
| `~/.cursor/rules/maoleve.mdc` with `alwaysApply: false` | Dormant tier policy |
| Mão leve blocks in `AGENTS.md` / `CLAUDE.md` with "when tier activated" | Dormant tier policy |
| RTK hooks from `rtk init` | Used only when tier activated |
| RTK, Headroom, Serena binaries | Reused by tier activation |
| `~/.config/maoleve/env.sh` non-secret defaults | Optional install artifact |
| Mão leve checkout directory | Source of prompts and templates |

When unsure whether a file is legacy or current, show evidence and ask before
deleting.

## Legacy targets (remove with approval)

### 1. Blast-installed MCP servers

Remove idle MCP entries the old CLI or manual blast-install added. Inspect:

| Agent | Config surface |
| --- | --- |
| Cursor IDE | `~/.cursor/mcp.json` |
| Claude Code | `claude mcp list`, `~/.claude/` MCP config |
| Codex | `~/.codex/config.toml` — `[mcp_servers.*]` sections |
| OpenCode | `~/.config/opencode/opencode.json` — `mcp` object |
| Cursor Agents | project or user MCP config if present |

**Remove** (unless human explicitly keeps them):

- tokensave
- Playwright
- Speckit
- Superpowers
- Firecrawl
- Context7
- Headroom MCP (when registered globally — belongs at **full** tier only)
- Serena (when registered globally — belongs at **high/full** activation only)

**Preserve:** empty MCP config or MCP count **0** at idle after cleanup.

Merge-preserving edits only — do not wipe unrelated MCP the human uses for other
projects.

### 2. Always-on global rules

Scan and offer removal of rules that force tier behavior globally:

| Pattern | Typical path |
| --- | --- |
| `token-savings.mdc` with `alwaysApply: true` | `~/.cursor/rules/` |
| `superpowers-mcp-router.mdc` with `alwaysApply: true` | `~/.cursor/rules/` |
| Duplicate `maoleve.mdc` / Caveman blocks with `alwaysApply: true` | `~/.cursor/rules/` |
| Unconditional "always use RTK/Caveman/Headroom" in global AGENTS/CLAUDE | agent policy files |

**Preserve:** `maoleve.mdc` with `alwaysApply: false` and "when tier activated"
wording from current install.

### 3. npx / remote skills (not vendored copy)

Remove skills installed via `npx skills add` or remote package installs when
a vendored copy from the Mão leve checkout exists or should replace them:

- `~/.agents/skills/*` from npx (except vendored `caveman/` from install)
- `~/.cursor/skills/*` from npx (except vendored `caveman/`)
- `~/.codex/skills/*`, `~/.claude/skills/*`, `~/.config/opencode/skills/*`
  from npx (except vendored `caveman/`)
- OpenCode Caveman **plugin** at `~/.config/opencode/plugins/caveman/` (legacy;
  prompt-only install uses vendored skills)

Do **not** remove vendored `caveman/` trees copied during install.

### 4. Old CLI artifacts

From deprecated `bin/maoleve apply` / `install.sh` era:

| Artifact | Action |
| --- | --- |
| Symlinks from checkout → home config (whole-file replace) | Replace with merge from templates per install.md, or remove symlink if duplicate |
| `~/.local/bin/maoleve` | Remove only if human confirms legacy CLI unused |
| `~/.local/share/maoleve/` state symlinks | Remove if only legacy launcher used them |
| `~/.config/maoleve/config.env` forcing always-on proxy | Trim or remove Mão leve-owned always-on keys with approval |
| `~/.bashrc` `BEGIN MAOLEVE` block sourcing forced proxy | Offer to trim to non-secret env only, or remove block if unwanted |

**Preserve:** `versions.env` reference, checkout clone, dormant merged policy.

### 5. Forced Headroom proxy / wrap at idle

**Remove** when present without an active tier:

- Codex `openai_base_url` / `[model_providers.headroom]` forcing local proxy
- Cursor IDE proxy base URL in settings
- Global `headroom wrap` auto-start in shell profile
- Headroom MCP registered outside **full** tier on Cursor IDE

**Preserve:** Headroom binary; proxy is enabled per chat via `activate-fast+.md`.

### 6. Legacy per-tier install prompts

If the human still has bookmarks or saved prompts for removed files
(`install-low.md`, `install-medium.md`, etc.), note they are obsolete — use
**install + activate** instead. No file deletion required.

## Cleanup ladder (approval required)

For each legacy item found:

1. Show non-secret evidence (path, key name, MCP server id).
2. Classify: **remove**, **preserve** (prompt-only), or **ask human**.
3. Create backup before config edits.
4. Apply minimal merge-preserving removal.
5. Re-check MCP count at idle (target **0**) and dormant policy intact.

Do **not** run `git reset --hard`, delete whole `~/.cursor` or `~/.codex`
trees, or uninstall RTK/Headroom/Serena binaries unless the human explicitly
requests full tool removal (out of scope for this prompt).

## Report shape

```text
Mão leve legacy cleanup report
Platform:
Agent:
Authorized agents:
Checkout:

MCP removed: [list or none]
MCP preserved (non-Mão-leve): [list or none]
MCP at idle: N (target 0)
Always-on rules removed: [list or none]
Dormant policy preserved: yes/no — paths
npx skills removed: [list or none]
Vendored caveman preserved: yes/no
CLI artifacts removed: [list or none]
Headroom idle proxy removed: yes/no
Skipped (already clean):
Manual follow-up:
Failures:

Next step: new chat → docs/prompts/verify.md, then daily /maoleve-<tier>
```

English only. If nothing legacy remains, say so and suggest verify.md to confirm
prompt-only install health.

**Not for current uninstall:** this prompt does not remove a correct prompt-only
install. For a clean machine test, use your local purge script (e.g.
`~/scripts purge`) outside this repository.
