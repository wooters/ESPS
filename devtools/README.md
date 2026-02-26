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
