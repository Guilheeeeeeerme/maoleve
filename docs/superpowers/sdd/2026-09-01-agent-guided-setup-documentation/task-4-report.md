# Task 4 verification report

**Date:** 2026-09-01
**Scope:** Final documentation review fixes in `PROMPT.md`, `README.md`, and
`docs/README.md`.

## Verification commands and evidence

### Recovery boundary

```bash
rtk grep -n -F -e "Broader removal is outside Mão leve scope." -e "Mão leve never removes an entire" -e "including after human confirmation." PROMPT.md
```

Exit: `0`

```text
85:Broader removal is outside Mão leve scope. Mão leve never removes an entire
86:agent configuration directory, including after human confirmation. Do not
```

```bash
rtk grep -n -F "Any broader removal requires" PROMPT.md
```

Exit: `1` (expected absence). Output: none.

### Approval before checkout mutation

```bash
rtk grep -n -F -e "obtain human approval before any" -e "obtain human approval before performing" PROMPT.md
```

Exit: `0`

```text
4:platform, explain each planned action, obtain human approval before any
19:   target and planned effects, and obtain human approval before performing
```

```bash
rtk grep -n -i -E "approval before (it )?(clones|cloning)|approval before performing" README.md docs/README.md PROMPT.md
```

Exit: `0`

```text
README.md:9:each proposed action, and waits for approval before it clones or updates the
docs/README.md:24:approval before cloning or updating it, and do not discard my changes. Read
PROMPT.md:19:   target and planned effects, and obtain human approval before performing
```

### Credential preservation

```bash
rtk grep -n -F -e "preserves every existing credential categorically" -e "formatting and ordering whenever possible" README.md
```

Exit: `0`

```text
38:- It preserves every existing credential categorically: credentials are never
41:  unknown fields. It preserves formatting and ordering whenever possible.
```

```bash
rtk grep -n -i -E "credentials?.*whenever possible|whenever possible.*credentials?" README.md
```

Exit: `1` (expected absence). Output: none.

### Current product-contract labels

```bash
rtk grep -n -F "Current product contract" README.md docs/README.md
```

Exit: `0`

```text
README.md:105:- [Current product contract](docs/product-spec.md)
docs/README.md:149:- [Current product contract](./product-spec.md)
```

```bash
rtk grep -n -F "Product spec (planning reference)" README.md docs/README.md
```

Exit: `1` (expected absence). Output: none.

### Link targets

```bash
rtk proxy test -f PROMPT.md
rtk proxy test -f README.md
rtk proxy test -f docs/README.md
rtk proxy test -f docs/product-spec.md
rtk proxy test -f versions.env
```

Each command exited `0` with no output.

```bash
rtk grep -n -e "](docs/\|](../\|](./" README.md docs/README.md PROMPT.md
```

Exit: `0`. Output included all repository-relative links in the three files,
including `docs/README.md`, `PROMPT.md`, `versions.env`, and
`docs/product-spec.md`; each referenced target exists.

### Diff checks

```bash
rtk git diff --check
```

Exit: `0`. Output: none.

```bash
rtk git diff --name-only -- PROMPT.md README.md docs/README.md
```

Exit: `0`

```text
PROMPT.md
README.md
docs/README.md
```

Pre-existing `install.sh` and `.cursor/` changes were not edited. No broad test
suite was run because this wave changes Markdown only and the request requires
focused documentation checks.
