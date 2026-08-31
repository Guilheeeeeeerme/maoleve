# Maoleve

Maoleve is a Linux-first harness for coding agents.

It is intentionally small:

- `Headroom` handles compression and proxying when available.
- `RTK` compresses shell output when available.
- `Caveman` keeps responses terse.
- `Serena` stays on-demand for symbol-level work.
- Exact binary versions are pinned in `versions.env`.

The default policy is simple:

1. Use the cheapest sufficient path.
2. Prefer targeted reads and exact search.
3. Avoid broad tests and broad refactors unless explicitly requested.
4. Overwrite stale config instead of keeping conflicting variants.

## Prerequisites

Required for installation:

- `bash`
- `git`
- `curl`
- standard coreutils such as `mkdir`, `ln`, `cp`, `chmod`, `sed`, and `awk`

Recommended if you want the full harness:

- `headroom`
- `rtk`
- `codex`
- `opencode`
- `cursor-agent`
- `cursor`
- `claude`
- `serena`
- `caveman`

## Install

From a clone:

```bash
./install.sh
```

From GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/Guilheeeeeeerme/maoleve/main/install.sh | bash
```

## What the installer does

- Checks prerequisites and prints what is available.
- Installs the repo into `~/.local/share/maoleve`.
- Installs a `maoleve` command into `~/.local/bin`.
- Writes shared policy links for Claude, OpenCode, Codex, and Cursor rules.
- Overwrites old harness links and config when rerun.
- Refuses to run wrapped agents if a pinned binary drifts from `versions.env`.

## Usage

```bash
maoleve prereqs
maoleve versions
maoleve doctor
maoleve wrap codex
maoleve wrap opencode
maoleve wrap claude
maoleve setup cursor
maoleve prompt
```

`maoleve wrap cursor` prepares the Headroom Cursor path. `maoleve setup cursor` prints the generated Cursor guidance.

## Prompt fallback

If you prefer the agent to self-configure, paste the text from `PROMPT.md` into the agent session and point it at this repository.
