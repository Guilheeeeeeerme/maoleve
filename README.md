# Maoleve

Maoleve is a Linux-first harness for coding agents.

It is designed to be small, pinned, and boring:

- `Headroom` handles compression and proxying.
- `RTK` compresses shell output.
- `Caveman` keeps the agent terse.
- `Serena` stays on-demand for symbol-level work.
- Exact versions are pinned in `versions.env`.

## What This Repo Configures

Maoleve writes the following local configuration:

- `~/.bashrc` Maoleve block with commented secret placeholders and a source line for `~/.config/maoleve/env.sh`
- `~/.config/maoleve/env.sh` and `~/.config/maoleve/env.local.example`
- `~/.cursor/mcp.json`
- `~/.codex/config.toml`
- `~/.config/opencode/opencode.json`
- `~/.claude/CLAUDE.md`
- `~/.codex/AGENTS.md`
- `~/.config/opencode/AGENTS.md`
- `~/.cursor/rules/maoleve.mdc`

## Installable On Linux

These are installed automatically when available:

- `uv`
- `headroom`
- `serena`
- `rtk`

These are configured when already installed:

- `codex`
- `opencode`
- `cursor`
- `cursor-agent`
- `claude`

## Manual Only Or External

These are not silently installed by Maoleve because they are external GUI apps or depend on your account state:

- `Cursor` IDE and its `cursor-agent` launcher if they are not already present
- `Claude Code` if you have not installed the CLI yet
- `Node.js 18+` and `npx` for the Caveman installer and skills-based setups
- API keys for `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `CONTEXT7_API_KEY`, and `FIRECRAWL_API_KEY`

If you need `uv`, install it on Linux with the official script:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

If `claude` is missing, install Claude Code first:

```bash
npm install -g @anthropic-ai/claude-code
```

If `cursor` is missing, install Cursor from the official app for your distro or the downloaded Linux package.

If `node`/`npx` is missing and you want Caveman to install for Codex or Cursor, install Node.js 18+ first.

## Bootstrap

From a clone:

```bash
./install.sh
```

After install, apply the local harness:

```bash
maoleve tools
maoleve apply
maoleve claude
```

If you want the wrapper to fail closed on version drift:

```bash
maoleve versions
maoleve doctor
```

## Required Env

These are the variables the harness expects:

- `HEADROOM_PROJECT`
- `HEADROOM_MODE`
- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `CONTEXT7_API_KEY`
- `FIRECRAWL_API_KEY`

Maoleve writes commented placeholders into `~/.bashrc` and an editable example file at `~/.config/maoleve/env.local.example`.

## Agent Setup

### Cursor IDE And Cursor CLI

Maoleve writes `~/.cursor/mcp.json` with:

- `headroom`
- `serena`
- `tokensave`
- `context7`
- `firecrawl`
- `playwright`

Cursor CLI uses the same Cursor config surface as the IDE in this harness, so the same MCP file applies.

### Codex

Maoleve writes `~/.codex/config.toml` with:

- `model_provider = "headroom"`
- `headroom` as the local proxy
- `serena`
- `tokensave`
- `context7`
- `firecrawl`
- `playwright`

### OpenCode

Maoleve writes `~/.config/opencode/opencode.json` with:

- `headroom`
- `serena`
- `tokensave`
- `context7`
- `firecrawl`
- `playwright`
- the `caveman` plugin

### Claude Code

If `claude` is installed, `maoleve claude` will:

- install the `caveman` plugin
- add the local MCP servers it can manage
- install the `headroom` MCP path when available

If `claude` is not installed, the command prints the exact install hint instead of failing silently.

If you want the Caveman stack everywhere, the installer uses these official commands under the hood when available:

```bash
claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman
npx -y github:JuliusBrussee/caveman -- --only opencode
npx -y skills add JuliusBrussee/caveman -a codex --yes
npx -y skills add JuliusBrussee/caveman -a cursor --with-init --yes
```

## Policy

Default operating rules:

1. Use the cheapest sufficient path.
2. Prefer targeted reads and exact search.
3. Avoid broad tests and broad refactors unless explicitly requested.
4. Overwrite stale config instead of keeping conflicting variants.
5. Keep all user-facing text in English.

## Commands

```bash
maoleve prereqs
maoleve versions
maoleve install
maoleve apply
maoleve tools
maoleve claude
maoleve doctor
maoleve wrap codex
maoleve wrap opencode
maoleve wrap claude
maoleve setup cursor
maoleve prompt
```

`maoleve wrap cursor` prepares the Headroom Cursor path. `maoleve setup cursor` prints the Cursor-specific guidance if you want to apply settings manually.
