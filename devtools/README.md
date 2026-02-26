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

Legacy figure note:
- Some docs include `.gps` figure assets (Masscomp "Graphic Primitive String" plot/metafile format), referenced via `.GP ... .GE` in roff sources (for example, `history.prme` and `doc/filter/filter.rgeme`).
- Historically these figures were handled through `gpstt` in an `refer | eqn | gpstt | iroff -me` pipeline.
- Keep this in mind for HTML migration: `.gps` content will need a dedicated conversion path (for example, to image or SVG assets).

### `build-docs-phase2.sh`

Build a navigable static documentation website from legacy ESPS docs (Phase 1 staged text, regenerated man-page Markdown, help docs, and legacy figure assets).

Usage:

```bash
./devtools/build-docs-phase2.sh [--out-dir build/docs-phase2] [--strict errors|warnings|none] [--scope core-plus] [--keep-going] [--dry-run] [--base-url /]
```

Example:

```bash
./devtools/build-docs-phase2.sh --out-dir build/docs-phase2 --strict errors --scope core-plus --keep-going
```

Outputs:
- Website source tree: `<out-dir>/site-src/`
- Built site: `<out-dir>/site/`
- Figure assets and placeholders: `<out-dir>/assets/figures/`
- Per-file logs: `<out-dir>/logs/`
- Reports:
  - `<out-dir>/summary.md`
  - `<out-dir>/summary.json`
  - `<out-dir>/manifest.content.json`
  - `<out-dir>/manifest.figures.json`

Note:
- Phase 2 docs generation is now intended to run locally (one-time snapshot workflow), not as a recurring GitHub Action pipeline.

### `snapshot-docs-phase2-local.sh`

Run a full local Phase 2 docs build and package a one-time snapshot archive.

Usage:

```bash
./devtools/snapshot-docs-phase2-local.sh [--out-dir build/docs-phase2-local] [--snapshot-dir build/docs-phase2-snapshots] [--strict errors|warnings|none] [--scope core-plus] [--keep-going] [--base-url /] [--venv /path/to/venv]
```

Example:

```bash
./devtools/snapshot-docs-phase2-local.sh --venv /tmp/esps-phase2-venv --strict errors --keep-going
```

Outputs:
- Snapshot working dir: `<snapshot-dir>/esps-docs-phase2-<timestamp>-<commit>/`
- Snapshot tarball: `<snapshot-dir>/esps-docs-phase2-<timestamp>-<commit>.tar.gz`
- Snapshot zip (if `zip` is available): `<snapshot-dir>/esps-docs-phase2-<timestamp>-<commit>.zip`
