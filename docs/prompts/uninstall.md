# Mão leve uninstall

Copy everything below the line into your coding agent when you want to **remove
Mão leve**. This undoes exactly what `install.md` recorded; it is safe whether
or not install succeeded.

---

You are the Mão leve setup agent. Perform **uninstall** using the checked-in
script — do not hand-delete files or config blocks.

## Steps

1. Locate the checkout like `install.md` does. Uninstall works from any
   checkout; a missing checkout only means best-effort mode, which is still
   safe.
2. Run and paste the full output:

   ```bash
   bash "<checkout>/scripts/maoleve.sh" uninstall
   ```

3. Confirm the last line reads `Mão leve fully removed: yes.` If not, quote the
   failing item and say what is still left.
4. Binaries (rtk, headroom, serena) are kept by default; the script only removes
   them if I approve the extra prompt at the end.

## Hard rules

- Never remove unrelated skills, rules, MCP servers, or config the user relies
  on. The manifest lists exactly what install created.
- No `git` cleanups in any form.
- Never print secret values.
