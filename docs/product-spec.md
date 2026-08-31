# Maoleve Product Spec

## 1. Overview

Maoleve is a Linux-first harness for AI coding agents.

The product exists to make agent workflows:

- cheaper in tokens
- more predictable
- easier to bootstrap
- easier to keep aligned across tools
- easier to reproduce on a fresh Ubuntu machine

Maoleve is not a general automation platform and not a broad developer productivity suite. It is a narrow control layer for agent setup, agent policy, MCP wiring, shell-output compression, and terse interaction style.

Current project date: August 31, 2026.

## 2. Product Goal

The primary goal is to provide one opinionated harness that can be applied consistently to:

- Cursor IDE
- Cursor CLI / `cursor-agent`
- Codex CLI
- OpenCode
- Claude Code

The harness should:

- minimize context waste
- minimize duplicated configuration
- normalize the same agent policy across tools
- install or configure what it can on Linux
- leave clear manual instructions when a dependency cannot be installed automatically
- fail closed on version drift instead of silently upgrading

## 3. Product Philosophy

Maoleve is intentionally strict.

The product should prefer:

- one source of truth over many local variants
- explicit pinning over floating `latest`
- shell-based automation over GUI fiddling
- targeted reads over broad scans
- small supported surface area over vague “works everywhere” claims
- reproducibility over cleverness

Maoleve should not try to be all things to all agents. If a capability is not useful for token-efficient coding, it should stay out of the default path.

## 4. Product Operating Modes

Maoleve should behave like a small set of intentional workflows, not a giant catch-all framework.

### 4.1 Default fast path

This is the normal path for everyday coding work.

Use:

- `Headroom` for compression and proxying when available
- `RTK` for command output compression
- `Caveman` for terse model responses
- `Serena` only when symbol-level understanding is needed

This path should be the cheapest sufficient path.

### 4.2 Symbol path

Use when the task depends on references, symbols, or local code memory.

Use:

- `Serena`
- targeted reads
- exact symbol lookup

Do not escalate to broad file reads if symbol-level lookup is enough.

### 4.3 Output-heavy shell path

Use when the task produces long CLI output.

Use:

- `RTK`
- narrow commands
- filtered command output

The goal is to keep model context small and avoid repeated noise.

## 4. What Maoleve Is For

Maoleve is for a user who wants:

- a small, repeated setup that can be applied to every coding agent
- token-saving defaults without having to manually re-encode policy in each tool
- a shell-first workflow on Linux
- the same harness behavior in terminal agents and editor agents
- a clear boundary between default efficiency tools and optional heavy workflow tools

## 5. What Maoleve Is Not For

Maoleve is not:

- a test framework
- a refactoring framework
- a build system
- a CI platform
- a general secrets manager
- a cross-platform installer with no constraints
- a desktop app replacement

It is also not trying to normalize every agent feature. The scope is specifically agent harness policy, token economy, and MCP/tool wiring.

## 6. Supported Agents

Maoleve currently targets these agents:

### 6.1 Cursor IDE

Cursor is treated as the interactive editor surface.

Maoleve configures:

- Cursor MCP wiring
- Cursor rules/policy files
- RTK shell hook integration
- Headroom-based compression path when available

Link:

- [Cursor](https://cursor.com)

### 6.2 Cursor CLI / `cursor-agent`

Cursor CLI is treated as the terminal-facing Cursor entrypoint.

Maoleve treats it as a sibling of the IDE and aims to keep the same harness policy available in both places.

Link:

- [Cursor CLI](https://cursor.com)

### 6.3 Codex CLI

Codex is a terminal coding agent with a prompt-policy surface and MCP support.

Maoleve configures:

- `~/.codex/config.toml`
- `~/.codex/AGENTS.md`
- RTK hooks
- Headroom as model provider when available

Links:

- [Codex CLI](https://github.com/openai/codex)

### 6.4 OpenCode

OpenCode is the agent most likely to carry the richest local customization in this project.

Maoleve configures:

- `~/.config/opencode/opencode.json`
- `~/.config/opencode/AGENTS.md`
- plugins
- skills
- commands
- RTK hooks
- Headroom, Serena, and other MCP servers

Links:

- [OpenCode](https://github.com/opencode-ai/opencode)

### 6.5 Claude Code

Claude Code is treated as a supported agent with the most explicit shell-hook path.

Maoleve configures:

- `~/.claude/CLAUDE.md`
- `~/.claude/settings.json` or equivalent Claude hook state
- RTK hooks
- Headroom MCP registration
- Caveman plugin installation

Links:

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)

## 7. Core Tooling Stack

Maoleve’s default stack is built from a small set of tools with distinct responsibilities.

### 7.1 Headroom

Headroom is the context-compression and proxy layer.

Use it for:

- compressing model context
- proxying model calls
- centralizing token-aware behavior
- sharing a consistent model provider across agents when possible

Maoleve treats Headroom as the most important global optimization layer.

Link:

- [Headroom](https://github.com/headroomlabs-ai/headroom)

### 7.2 RTK

RTK is the shell-output compression layer.

Use it for:

- `git`
- `cargo`
- `npm`
- `pnpm`
- test output
- verbose CLI output
- agent shell command rewriting

RTK exists to make shell output cheaper to read and cheaper to send back to the model.

Link:

- [RTK](https://github.com/rtk-ai/rtk)

### 7.3 Caveman

Caveman is the terse-language and compact-workflow layer.

Use it for:

- terser answers
- compact reviews
- compact commit messages
- “stop saying more than needed” mode
- agent-local brevity without losing technical substance

Caveman is intentionally opinionated and should not become the default if the user needs long-form explanation.

Link:

- [Caveman](https://github.com/JuliusBrussee/caveman)

### 7.4 Serena

Serena is the symbol-level code intelligence layer.

Use it for:

- symbol navigation
- reference finding
- targeted code understanding
- file-level and symbol-level context retrieval

Serena is intentionally on-demand. It should not be enabled just because it exists.

Link:

- [Serena](https://github.com/oraios/serena)

### 7.5 TokenSave

TokenSave is legacy compatibility and token-accounting support in this project’s history.

Maoleve keeps it only where the current setup still uses it.

Default policy:

- do not expand TokenSave into a second parallel optimization stack
- keep it only if an integration still needs it

Link:

- [TokenSave / usage layer](https://github.com/ryoppippi/ccusage)

## 8. Product Goals

Maoleve should do the following well:

### 8.1 Normalize agent policy

The same “cheapest sufficient path” policy should appear in every supported agent.

### 8.2 Reduce token waste

The harness should compress:

- shell output
- repeated boilerplate
- verbose agent chatter
- broad context that does not need to be sent

### 8.3 Reduce setup drift

The project should avoid the common failure mode where each agent has its own slightly different:

- MCP list
- secret expectations
- prompt policy
- optimization stack
- version pinning

### 8.4 Preserve user intent

Maoleve should not optimize itself into a bad default.

Examples:

- do not force broad tests
- do not force refactoring
- do not enable heavy methodology for everything
- do not make “latest” the default where stability matters

## 9. Non-Goals

Maoleve explicitly does not aim to:

- run your test suite automatically
- refactor code unless asked
- benchmark application code
- replace project-level CI
- provide a cloud service
- support every OS equally
- make every agent behave identically in every detail

## 10. Supported Operating System Scope

### 10.1 Current support target

Maoleve is tested only on Ubuntu.

Current support policy:

- Ubuntu is the only guaranteed OS family
- the project may run elsewhere, but that is not a promise
- if a feature depends on Ubuntu-specific behavior, it should be documented as such

### 10.2 What this means in practice

- installer logic should prefer bash and standard GNU tooling
- docs should describe Ubuntu-first paths
- package instructions should avoid implying macOS or Windows parity
- any non-Ubuntu use should be treated as best-effort until verified

### 10.3 Why this is important

The harness includes:

- shell hooks
- editor hooks
- PATH-based binaries
- local plugin files
- config files under `~/.config`

Those are easy to over-generalize. Ubuntu-only support keeps the product reliable and the docs honest.

## 11. Required Environment

The project expects the following environment variables in the user shell or in `~/.config/maoleve/env.local`:

- `HEADROOM_PROJECT`
- `HEADROOM_MODE`
- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `CONTEXT7_API_KEY`
- `FIRECRAWL_API_KEY`

The project also writes commented placeholders into `~/.bashrc` so the user can fill them later without losing the pattern.

### 11.1 Pinned version inputs

The harness is version-locked through `versions.env`.

Current pinned values:

- `MAOLEVE_HEADROOM_VERSION=0.32.1`
- `MAOLEVE_RTK_VERSION=0.43.0`
- `MAOLEVE_CODEX_VERSION=0.151.0`
- `MAOLEVE_OPENCODE_VERSION=1.18.25`
- `MAOLEVE_CURSOR_AGENT_VERSION=2026.07.23-e383d2b`
- `MAOLEVE_CURSOR_BINARY=/mnt/c/Users/ferre/AppData/Local/Programs/cursor/resources/app/bin/cursor`
- `MAOLEVE_TOKENSAVE_VERSION=7.6.2`
- `MAOLEVE_SERENA_VERSION=1.5.3`
- `MAOLEVE_CAVEMAN_PLUGIN_VERSION=0.1.0`

## 12. MCP Strategy

Maoleve uses MCP as a shared capability layer, not as a random extra feature.

### 12.1 Always-on / core MCPs

- `headroom`
- `serena`
- `tokensave` where still needed

### 12.2 Support MCPs

- `context7`
- `firecrawl`
- `playwright`

### 12.3 MCP policy

Each MCP server must have a purpose.

If an MCP does not improve the current coding task, it should not be part of the default path.

## 13. Configuration Surfaces

Maoleve writes and manages these surfaces:

- `~/.bashrc` Maoleve block
- `~/.config/maoleve/env.sh`
- `~/.config/maoleve/env.local.example`
- `~/.cursor/mcp.json`
- `~/.cursor/rules/maoleve.mdc`
- `~/.codex/config.toml`
- `~/.codex/AGENTS.md`
- `~/.config/opencode/opencode.json`
- `~/.config/opencode/AGENTS.md`
- `~/.claude/CLAUDE.md`
- `~/.claude/settings.json` or equivalent Claude hook state

## 14. Version Policy

Maoleve is pinned.

Version lock files:

- `versions.env`

Behavior:

- installed binaries must match the pinned version
- if they drift, the harness should refuse to proceed
- configuration should not silently adopt latest upstream versions

This policy exists because “latest” breaks harnesses in exactly the way this project is trying to prevent.

## 15. Installation Strategy

Maoleve should support two setup modes:

### 15.1 Shell install

Preferred install path:

```bash
curl -fsSL https://raw.githubusercontent.com/Guilheeeeeeerme/maoleve/main/install.sh | bash
```

This should:

- clone or update the repo
- install required Linux tools when possible
- configure agent files
- apply RTK hooks
- write shell placeholders and env files
- leave clear instructions for manual steps the OS or package manager cannot do

### 15.2 Prompt-driven self-setup

Alternative path:

- give the agent the repository link
- ask it to configure the harness
- use the same repo docs as source of truth

This path exists as fallback, not as the primary install story.

## 16. Product Behavior Expectations

When a user runs the harness, it should:

- choose the least expensive workable path
- compress shell output aggressively
- keep responses concise by default
- surface missing tools clearly
- avoid pretending a missing dependency is fine
- refuse version drift instead of papering over it
- keep repeated setup steps idempotent where possible

## 17. Quality Bar

The project is good only if:

- a fresh Ubuntu machine can be brought into a consistent state
- the same policy lands in all supported agents
- the user can see what is installed, what is pinned, and what is missing
- the harness stays small enough to reason about
- the docs stay honest about what is tested

## 18. Detailed User Outcomes

### 18.1 For a normal coding session

The user should be able to:

- open any supported agent
- get the same token-saving policy
- use shell commands without verbose noise
- ask for code work without extra setup friction

### 18.2 For a codebase with symbol-heavy work

The user should be able to:

- enable Serena
- find symbols and references quickly
- avoid reading whole files unnecessarily

### 18.3 For a messy output-heavy task

The user should be able to:

- rely on RTK for shell output compression
- keep logs readable
- avoid handing megabytes of output back to the model

### 18.4 For a short concise task

The user should be able to:

- use Caveman mode
- get short, technical answers
- avoid style drift between agents

## 19. Acceptance Criteria

Maoleve should be considered successfully implemented when:

- the repo documents the full harness clearly
- Ubuntu setup is explicit
- required env vars are documented
- supported agents are listed with their responsibilities
- Headroom, RTK, Caveman, Serena, and MCP usage is explained
- version pins are enforced
- manual-only steps are separated from auto-installable steps
- the setup is reproducible from a clean Ubuntu install

## 20. Official Links

Core links:

- [Maoleve repository](https://github.com/Guilheeeeeeerme/maoleve)
- [Headroom](https://github.com/headroomlabs-ai/headroom)
- [RTK](https://github.com/rtk-ai/rtk)
- [Caveman](https://github.com/JuliusBrussee/caveman)
- [Serena](https://github.com/oraios/serena)
- [OpenCode](https://github.com/opencode-ai/opencode)
- [Codex CLI](https://github.com/openai/codex)
- [Cursor](https://cursor.com)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- [uv](https://docs.astral.sh/uv/)
- [Context7](https://github.com/upstash/context7)
- [Firecrawl](https://github.com/firecrawl/firecrawl)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)

## 21. Documentation Entry Points

The repo-level docs should lead to this spec.

- [Repo README](../README.md)
- [Product spec](./product-spec.md)

## 22. Open Questions

These are intentionally left open for the next iteration:

- Should TokenSave remain in the default harness or be fully retired?
- Should the Ubuntu support target be pinned to a specific LTS release?
- Should Cursor CLI use a separate config path from Cursor IDE in future versions?
- Should Caveman remain a default install or become opt-in per project?

## 23. Summary

Maoleve is a productized agent harness for people who want stable, token-efficient coding workflows across a small set of supported tools.

Its job is not to do everything. Its job is to do the right small set of things consistently:

- compress what is noisy
- pin what can drift
- configure what can be automated
- document what must be manual
- stay honest about Ubuntu-only validation for now
