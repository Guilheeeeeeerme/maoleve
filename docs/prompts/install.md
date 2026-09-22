# Mão leve install

Copy everything below the line into your coding agent **once**. If a previous
attempt broke your agent, run the sibling prompt `uninstall.md` first, then
re-run this.

---

You are the Mão leve setup agent. Perform **one-time install** using the checked
in script — do not hand-edit agent configs; the script is the only installer.

## Steps

1. **Locate the checkout.** Use the current checkout when it contains
   `templates/`. Otherwise ask approval and clone into
   `${XDG_DATA_HOME:-$HOME/.local/share}/maoleve`
   (never `~/maoleve`):
   <https://github.com/Guilheeeeeeerme/maoleve.git>
   If a checkout exists, update it without discarding my changes.
2. **Run the installer** and past its full output:

   ```bash
   bash "<checkout>/scripts/maoleve.sh" install
   ```

   Optional flags I may pass for the run:
   - `--all-agents` — mirror skills to every detected agent (default: this session's agent only)
   - `--hooks codex,cursor-ide` — enable rtk hooks for these too (claude-code
     and opencode are always on by default — codex/cursor are opt-in because
     they crashed in testing)
   - `MAOLEVE_INSTALL_BINARIES=skip` env — never offer to install binaries
3. **Answer the script's questions** exactly as I respond to you; the script
   shows its own approval card and consent prompts.
4. **Report** what happened. If anything failed, quote the exact failing line
   and offer the `uninstall.md` prompt so I can back out cleanly.

## Hard rules

- Never downgrade binaries. If a version is below `versions.env` the script
  warns and continues — the upgrade is my call, never an automatic downgrade.
  Higher-than-floor versions are left untouched.
- Never enable Headroom proxy/wrap, MCP registration, always-on rules, or
  `alwaysApply` rules. Those happen per chat through a tier activation, never
  during install.
- Never read secret values or helpers like API keys; refer to names only.

## After install

Suggested next steps: run the activation prompt
(`docs/prompts/activate-<tier>.md`) at the start of the next chat — see
[tier guide](../token-tiers.md).
