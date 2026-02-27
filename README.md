# ESPS Revival

This repository is an active effort to revive and modernize the ESPS (Entropic Signal Processing System) codebase for current toolchains and workflows.

## Development Period

Based on copyright and version stamps in this repository, the core ESPS/Entropic code appears to have been developed primarily in the **mid-1980s through late-1990s** (roughly **1986-1999**), with later maintenance updates into the mid-2000s.

Examples in-tree:
- [`ESPS/general/src/doc/intro.doc`](./ESPS/general/src/doc/intro.doc): copyright range includes 1987-1993
- [`ESPS/general/src/doc/guide.doc`](./ESPS/general/src/doc/guide.doc): dated January 22, 1993 (ETM-S-86-14)
- [`ESPS/ATT/waves/src/c/xmethods.c`](./ESPS/ATT/waves/src/c/xmethods.c): SCCS stamp dated October 28, 1999
- [`ESPS/ATT/formant/src/xversion.c`](./ESPS/ATT/formant/src/xversion.c): maintenance stamp dated April 5, 2005

## Provenance

- This repo was forked from `jeremysalwen/ESPS` (`master`) on **February 25, 2026**.
- The upstream `jeremysalwen/ESPS` repository describes itself as a mirror of Entropic ESPS 6.0 with modifications, and includes historical notes from a 2009 refresh.
- Historical fork-origin files from that mirror are preserved in [`fork-origin-docs/`](./fork-origin-docs/).

## Brief History (ESPS and Entropic)

- ESPS/waves+ was a major UNIX speech/signal-processing toolkit associated with Entropic; Microsoft later described ESPS/waves+ and HTK as Entropic's industry-leading speech R&D toolkits during its acquisition announcement.
- The HTK project history documents that Entropic Research Laboratories took over HTK distribution/maintenance in 1993, integrated it with ESPS/xwaves, and formed Entropic Cambridge Research Laboratory (ECRL) with Cambridge University in 1995.
- Microsoft announced the acquisition of Entropic on **October 29, 1999**. HTK history notes that, after the acquisition, Microsoft licensed HTK back to Cambridge, and CUED resumed free source distribution in 2000.

## Credit

This project stands on work from many contributors across academia and industry, including:

- Entropic Research Laboratory / Entropic Inc.
- Cambridge University Engineering Department (Speech, Vision and Robotics Group) and HTK contributors
- Jeremy Salwen and others who preserved and mirrored historical ESPS sources

## Sources

- [Microsoft acquisition announcement (1999-10-29)](https://news.microsoft.com/source/1999/10/29/microsoft-acquires-entropic-an-innovator-in-speech-technologies/)
- [HTK history (CUED/HTK project mirror)](https://spandh.dcs.shef.ac.uk/ed_arena/htk/history.html)
- [Upstream mirror repository: jeremysalwen/ESPS](https://github.com/jeremysalwen/ESPS)

## Building on Modern macOS

The ESPS codebase compiles on modern macOS (Apple clang 17, arm64) with minimal source changes. GUI/X11/audio components are excluded.

### Quick Start

```bash
cd ESPS/general
./SETUP                    # Generates emake, defaults install to /usr/esps
./ESPS_INSTALL             # Builds and installs everything
```

Or to build into a custom directory:

```bash
cd ESPS/general
./SETUP -p /path/to/install
./ESPS_INSTALL
```

### What Gets Built

- **154 compiled CLI utilities** (fft, lpcana, get_f0, frame, sgram, etc.) plus 12 macOS-specific audio scripts/binaries
- **7 libraries**: `libespsg.a`, `libhdre.a`, `libhdrw.a`, `libhdrs.a`, `libhdrn.a`, `libesignal.a`, `libexv.a`

### Excluded Components

The following components require X11/XView/audio hardware not available on modern macOS and are skipped:

libxv, xwaves (ATT), audio, image, formsy, ps_ana, gpstohp, exprompt, expromptrun, fbuttons, mbuttons, plot3d, send_xwaves, wsystem, xacf, xtext, epochs, xfir_filt, xpz

### Changes Required for macOS Compilation

All changes are minimal — only what the compiler requires:

**Build system:**
- `SETUP` — C89 compatibility flags (`-std=gnu89`, `-Wno-implicit-*`), non-fatal XView detection, guarded macAudio copy
- `COMPILE` — Copy `other_includes` before build, comment out X11/GUI/HP components
- `lib/makefile` — Remove X11-dependent `xsend.o` from library objects
- `ATT/libsig/Makefile` — Remove XView dependency
- `lib_header/makefile` — Add `mkdir -p` for build subdirectories
- sphere2.6 Makefiles — Replace `gcc -ansi` with `gnu89` + warning suppression

**Source code (6 files, compiler-required only):**
- `sphere.h` — Guard `u_int` macro with `__APPLE__` to avoid typedef conflict
- `fixio.c` — Add `#include <unistd.h>` for `swab()` declaration
- `vqdesign.c` — Add `#include <stdlib.h>`, fix implicit int declaration
- `vqencode.c` — Add `#include <stdlib.h>` for `exit()` declaration
- `addfeahd.c`, `btosps.c` — Add `LINUX_OR_MAC` to platform guards for lvalue cast

## Building on Linux (Ubuntu 24.04)

ESPS also compiles on Ubuntu 24.04 (GCC 13, arm64/x86_64). A Dockerfile is provided for containerized builds.

### Container Build (from macOS)

Requires Apple's [`container`](https://github.com/apple/container) CLI:

```bash
make container-test
```

This builds ESPS inside an Ubuntu 24.04 container and produces **154 CLI utilities** (the same compiled programs as macOS; the 12 extra on macOS are platform-specific audio shell scripts).

### Native Linux Build

```bash
# Install dependencies
sudo apt-get install gcc libc6-dev make bison flex libx11-dev libxt-dev

cd ESPS/general
./SETUP -p /usr/esps
./ESPS_INSTALL
```

### Key Linux Adaptations

- `SETUP` — GCC flags: `-std=gnu89 -fcommon`, warning suppressions for legacy C, architecture-agnostic X11 library path
- `SETUP` — Library link order repeats `libhdre.a`/`libespsg.a` to resolve circular dependencies with GNU ld (which processes archives in a single left-to-right pass, unlike macOS ld)
- `COMPILE` — Creates `libexv.a` stub (XView disabled) using a dummy object for cross-platform `ar` compatibility

## Documentation

- Live ESPS manual pages (upstream mirror): [jeremysalwen/ESPS `ESPS/general/man`](https://github.com/jeremysalwen/ESPS/tree/master/ESPS/general/man)
- Documentation in this repo:
  - Source manual pages: [`ESPS/general/man/`](./ESPS/general/man/)
  - Generated Markdown manual pages (`*.md`) alongside the source man pages
  - Technical memoranda and guides: [`ESPS/general/src/doc/`](./ESPS/general/src/doc/)
  - Introductory ESPS document: [`ESPS/general/src/doc/intro.doc`](./ESPS/general/src/doc/intro.doc)

## Licensing Note

The repository includes a BSD-style license at [`LICENSE`](./LICENSE), and the historical text at [`fork-origin-docs/BSD.TXT`](./fork-origin-docs/BSD.TXT), which states the terms apply to software and documentation unless explicitly disclaimed in individual files.  
As with any historical code archive, preserve existing copyright notices and verify per-file notices before redistributing outside this repository.
