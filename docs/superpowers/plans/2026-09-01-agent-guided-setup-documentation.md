# Agent-Guided Setup Documentation Implementation Plan
> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align Maoleve's prompt and documentation with supervised, opt-in,
non-destructive setup across Codex, OpenCode, Cursor Agents, Cursor IDE, and
Claude Code.

**Architecture:** `PROMPT.md` is the operational source read by the setup
agent. `docs/README.md` is the user-facing onboarding source, while the root
README provides a concise entry point and `docs/product-spec.md` defines the
product contract. All documents share the same complementary merge, credential
preservation, cross-agent authorization, and Maoleve-owned recovery rules.

**Tech Stack:** Markdown, Bash command examples, repository-local links, and
existing `versions.env` terminology.

**Spec:** `docs/superpowers/specs/2026-09-01-agent-guided-setup-design.md`

## Global Constraints

- Initial supported agents are Codex, OpenCode, Cursor Agents (`cursor-agent`), Cursor IDE, and Claude Code.
- No integration is recommended or enabled automatically.
- Maoleve treats the user's existing harness as the primary configuration.
- Never delete or replace an existing credential.
- Ask before reading credential-bearing files or environment configuration in another agent's directory.
- Clean reinstall never means deleting an entire agent configuration directory.
- Maoleve remains Linux-first and Ubuntu-only for guaranteed support.
- Version pins remain governed by `versions.env`.
- User-facing documentation remains in English.

---

### Task 1: Rewrite the operational setup prompt

**Files:**
- Modify: `PROMPT.md`
- Reference: `docs/superpowers/specs/2026-09-01-agent-guided-setup-design.md`

**Interfaces:**
- Consumes: bootstrap agent context, repository checkout, and explicit human answers.
- Produces: deterministic setup instructions that later documentation links to as the operational source of truth.

- [ ] **Step 1: Replace default-stack instructions with an explicit setup-agent contract**

Write instructions that require the agent to identify the current supported
agent, verify Linux/Ubuntu scope, clone/update Maoleve, and read the detailed
repository documentation before making changes.

- [ ] **Step 2: Add the supervised question sequence**

Require explicit questions for active-agent inspection, cross-agent discovery,
the exact agents authorized for discovery, and each optional integration:
Headroom, RTK, Serena, Caveman, Spectkit, Superpowers, Firecrawl, and Context7.
State that “skip” and “manual instructions” are valid answers.

- [ ] **Step 3: Add complementary merge and ownership rules**

Require reading existing config first, preserving unknown fields and existing
credentials, adding stable Maoleve-managed markers, and changing only
Maoleve-owned entries on future runs. Require a human-visible summary before
ambiguous edits.

- [ ] **Step 4: Add credential and recovery safety rules**

State that credentials must not be printed, copied unnecessarily, replaced by
placeholders, or read from another agent without authorization. Define the
diagnose → repair → approved Maoleve-only reinstall → validate recovery ladder.

- [ ] **Step 5: Add per-agent token guidance**

Document native policy targets for Cursor rules, Cursor Agents, Codex
`AGENTS.md`, OpenCode `AGENTS.md`, and Claude `CLAUDE.md`. Require targeted
searches, compact shell output when selected, selective MCP use, and no broad
tests/refactors unless requested.

- [ ] **Step 6: Check the prompt for stale default behavior**

Run:

```bash
rtk grep -n -i -e 'default.*headroom\|default.*rtk\|default.*caveman\|overwrite stale\|overwrite.*config' PROMPT.md
```

Expected: no matches that instruct automatic installation, unconditional
configuration, or destructive overwrite.

- [ ] **Step 7: Commit the prompt change**

```bash
rtk git add PROMPT.md
rtk git commit -m "docs: define supervised setup prompt"
```

### Task 2: Rewrite the user onboarding documentation

**Files:**
- Modify: `docs/README.md`
- Reference: `PROMPT.md`
- Reference: `docs/product-spec.md`

**Interfaces:**
- Consumes: the operational prompt from Task 1 and the product contract.
- Produces: the primary human-facing onboarding and safety guide.

- [ ] **Step 1: Add the copy/paste bootstrap prompt**

Provide a short shell-safe prompt that tells the user to paste it into one of
the five supported agents and tells that agent to clone Maoleve and read
`PROMPT.md`. Link to the detailed prompt for inspection.

- [ ] **Step 2: Document supported agents and config surfaces**

Use exact names for Codex, OpenCode, Cursor Agents, Cursor IDE, and Claude
Code. Describe each native rule/config surface without claiming that all
agents share one format.

- [ ] **Step 3: Document opt-in integration questions**

Give each optional tool its purpose and state that Maoleve asks before
installing or configuring it. Remove language implying Headroom, RTK, Serena,
Caveman, or any MCP is a recommended default.

- [ ] **Step 4: Document complementary merge behavior**

Explain that the user's harness wins, Maoleve adds an owned layer, unknown
fields and existing settings remain intact, and ambiguous format changes pause
for human confirmation.

- [ ] **Step 5: Document credential discovery permissions**

Explain the difference between inspecting the active agent and inspecting
other agents. Require explicit per-agent authorization and state that found
credentials are not adopted until separately approved.

- [ ] **Step 6: Document repair and clean reinstall boundaries**

Describe backups, diagnosis, Maoleve-only repair, and Maoleve-only clean
reinstall. Include a warning that an entire agent config directory is never
removed as part of normal recovery.

- [ ] **Step 7: Check links and stale claims**

Run:

```bash
rtk grep -n -i -e 'recommended\|automatically\|always-on\|default path\|overwrite' docs/README.md
rtk grep -n -e 'PROMPT.md\|Cursor Agents\|Cursor IDE\|Claude Code' docs/README.md
```

Expected: any remaining “default” language describes the prompt workflow or
Ubuntu/version policy, not automatic optional-tool installation; all source
links resolve to repository files.

- [ ] **Step 8: Commit the onboarding documentation**

```bash
rtk git add docs/README.md
rtk git commit -m "docs: add guided setup onboarding"
```

### Task 3: Align the root README

**Files:**
- Modify: `README.md`
- Reference: `docs/README.md`

**Interfaces:**
- Consumes: onboarding contract from Tasks 1–2.
- Produces: concise repository entry point that cannot contradict the detailed docs.

- [ ] **Step 1: Replace automatic-install language with supervised setup language**

Update overview, install, tooling, environment, and agent sections to say that
the copied prompt drives setup and every integration is opt-in.

- [ ] **Step 2: Update the supported-agent list and terminology**

Use the exact five supported names and distinguish Cursor IDE from Cursor
Agents. Link users to `docs/README.md` for the bootstrap prompt.

- [ ] **Step 3: Add the complementary-config summary**

State that existing harness configuration and credentials are preserved and
that Maoleve changes only approved, Maoleve-managed entries.

- [ ] **Step 4: Remove contradictory command promises**

Review `maoleve apply`, tool lists, MCP lists, and version claims. Keep only
claims supported by the current product contract; move detailed future or
manual behavior to `docs/README.md` where needed.

- [ ] **Step 5: Commit the root README change**

```bash
rtk git add README.md
rtk git commit -m "docs: align root setup guidance"
```

### Task 4: Update the product specification

**Files:**
- Modify: `docs/product-spec.md`
- Reference: `docs/superpowers/specs/2026-09-01-agent-guided-setup-design.md`

**Interfaces:**
- Consumes: approved design and user-facing contract from Tasks 1–3.
- Produces: product-level source of truth for future implementation work.

- [ ] **Step 1: Rewrite product goal and operating modes around supervised setup**

State that Maoleve complements an existing harness, asks before optional
integration changes, and keeps a human responsible for ambiguous operations.

- [ ] **Step 2: Replace the supported-agent section**

Document Codex, OpenCode, Cursor Agents, Cursor IDE, and Claude Code with
agent-specific native guidance surfaces.

- [ ] **Step 3: Reclassify tooling as optional integrations**

Describe Headroom, RTK, Serena, Caveman, Spectkit, Superpowers, Firecrawl, and
Context7 without an always-on/default recommendation. Retain purpose and
version-lock information where accurate.

- [ ] **Step 4: Add merge, credential, discovery, and recovery requirements**

Make preservation of unknown fields and secrets, explicit cross-agent access,
stable ownership markers, backups, and Maoleve-only reinstall behavior product
requirements.

- [ ] **Step 5: Update installation, quality bar, acceptance criteria, and open questions**

Make the prompt-driven flow primary, keep shell install as an implementation
path only if it remains accurate, and remove acceptance criteria that require
automatic default installation.

- [ ] **Step 6: Commit the product-spec change**

```bash
rtk git add docs/product-spec.md
rtk git commit -m "docs: define complementary setup contract"
```

### Task 5: Cross-document consistency validation

**Files:**
- Test: repository documentation only; no new test file
- Inspect: `PROMPT.md`, `README.md`, `docs/README.md`, `docs/product-spec.md`

**Interfaces:**
- Consumes: all updated documentation.
- Produces: evidence that entry points agree and no stale default behavior remains.

- [ ] **Step 1: Verify supported-agent terminology**

Run:

```bash
rtk grep -n -i -e 'Codex\|OpenCode\|Cursor Agents\|Cursor IDE\|Claude Code' PROMPT.md README.md docs/README.md docs/product-spec.md
```

Confirm every current source uses the five-name list and does not present an
unsupported agent as part of initial support.

- [ ] **Step 2: Verify optional-tool policy**

Run:

```bash
rtk grep -n -i -e 'Headroom\|RTK\|Serena\|Caveman\|Spectkit\|Superpowers\|Firecrawl\|Context7' PROMPT.md README.md docs/README.md docs/product-spec.md
```

Inspect each match and remove any claim that an optional integration is
installed or configured without user selection.

- [ ] **Step 3: Verify safety language**

Run:

```bash
rtk grep -n -i -e 'credential\|secret\|authorized\|preserve\|merge\|backup\|reinstall\|Maoleve-managed' PROMPT.md README.md docs/README.md docs/product-spec.md
```

Confirm every relevant document states preservation, authorization, and
Maoleve-only recovery boundaries.

- [ ] **Step 4: Check Markdown and repository links**

Run:

```bash
rtk grep -n -e '](docs/\|](../\|](./' README.md docs/README.md docs/product-spec.md PROMPT.md
rtk git diff --check
```

Expected: links target existing files, and `git diff --check` reports no
whitespace errors.

- [ ] **Step 5: Review the final diff without broad tests**

Run:

```bash
rtk git diff -- PROMPT.md README.md docs/README.md docs/product-spec.md
rtk git status --short
```

Confirm unrelated existing changes remain untouched. No broad test suite is
required for Markdown-only changes.

- [ ] **Step 6: Request focused code/documentation review**

Review against the design spec, especially credential safety, ownership scope,
agent naming, and contradictions between the root README and detailed docs.
