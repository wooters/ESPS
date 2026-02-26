# ESPS Devtools

This directory contains standalone developer utilities used to modernize and maintain this repository.
Tools here are not part of the ESPS runtime package itself.

## Available utilities

### `man2md`

Convert a man-page source file to Markdown.

Usage:

```bash
go run ./devtools/man2md -- <input-man-file|-> <output-markdown-file|->
```

Example:

```bash
go run ./devtools/man2md -- ESPS/ATT/formant/man/formant.1 /tmp/formant.md
```

Build a direct executable:

```bash
make -C devtools man2md
```

Run the compiled binary:

```bash
./devtools/bin/man2md ESPS/ATT/formant/man/formant.1 /tmp/formant.md
```

Current status:
- `man2md` is useful for quick internal conversion, but it is not fully robust for legacy roff/troff macros.
- Some pages can contain residual man-page cruft in output (example: `]W \zee\(*p\`).

Recommendation:
- Prefer `pandoc` for production man-page to Markdown conversion.

Example:

```bash
pandoc -f man -t gfm ESPS/general/man/man3/vqencode.3 -o ESPS/general/man/man3/vqencode.3.md
```

### `compile-docs-phase1.sh`

Compile core legacy documentation sources into staged plain-text outputs with per-file logs and summary reports.

Usage:

```bash
./devtools/compile-docs-phase1.sh [--out-dir build/docs-phase1] [--strict errors|warnings|none] [--scope core] [--keep-going] [--dry-run]
```

Example:

```bash
./devtools/compile-docs-phase1.sh --out-dir build/docs-phase1 --strict errors --scope core --keep-going
```

Outputs:
- Rendered docs/man/help files under the chosen output directory (preserving source-relative paths)
- Per-file stderr logs under `<out-dir>/logs/`
- Summary reports:
  - `<out-dir>/summary.md`
  - `<out-dir>/summary.json`
