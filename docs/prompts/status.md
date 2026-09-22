# Mão leve status / repair

Copy everything below the line to see the current state and detect crash
triggers.

---

Run the status and doctor pass and report back:

```bash
bash "<checkout>/scripts/maoleve.sh" status
```

Paste the full output. Summarize:

1. Which binaries are below floor (upgrade recommended — never downgraded).
2. Which items the manifest contains and each one's state (present / missing).
3. Whether any doctor-pass crash signatures were found; propose removal with
   approval when they are. Codex or Cursor with dangling rtk hook references is
   a known crash source.
4. Which skill registrations exist and whether duplicate caveman copies are
   present.

Then wait for my direction — status never mutates anything.
