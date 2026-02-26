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
