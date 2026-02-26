# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Core Engineering Principles

1. **Clarity over cleverness** — Write code that's maintainable, not impressive
2. **Explicit over implicit** — No magic. Make behavior obvious
3. **Composition over inheritance** — Small units that combine
4. **Fail fast, fail loud** — Surface errors at the source
5. **Delete code** — Less code = fewer bugs. Question every addition
6. **Verify, don't assume** — Run it. Test it. Prove it works

## Project

ESPS (Entropic Signal Processing System) 6.0 — a 1990s-era C toolkit for audio/speech signal processing with 150+ CLI utilities across ~200 component directories. BSD-licensed.

## Build System

ESPS uses a custom `emake` wrapper (not standard make). `SETUP` generates `emake` with platform-specific env vars.

```bash
# Full build
cd ESPS/general
./SETUP [-p <install_dir>]    # Creates emake, defaults to /usr/esps
./ESPS_INSTALL                 # Builds and installs everything

# Single component
cd ESPS/general/src/<component>
emake clean && emake install
```

`emake` must exist (run `SETUP` first) and `ESPS_BASE` must be set.

### Build Order (critical — from `src/COMPILE`)

Libraries first: `h/` → `ATT/sigproc` → `ATT/libsig` → `lib` → `lib_header` → `lib_sp` → `libxv` → `utils` → then individual components.

### Core Libraries

- `libespsg.a` — Main ESPS support library
- `libhdre.a` / `libhdrw.a` / `libhdrs.a` / `libhdrn.a` — Header format libs (ESPS, waves, SPHERE, NIST)
- `libexv.a` — XView wrapper
- External deps: XView (must be system-installed; bundled copy was removed), X11, libm

### Compiler Flags

`CC=gcc` with `-DLINUX_OR_MAC -DNO_LIC -DSCCS -DLIB`. Expect many warnings on modern compilers.

## Architecture

### Native File Formats

- **SD** (Signal Data) — sampled audio with ESPS headers
- **FEA** (Feature Analysis) — frame-based feature records with typed fields
- Both managed by `lib_header` libraries

### Key Directories

- `ESPS/general/src/` — ~200 component dirs, each with Makefile + `.c` sources
- `ESPS/general/h/` — 68 core headers
- `ESPS/ATT/` — AT&T components: `libsig/` (I/O), `sigproc/` (algorithms), `waves/` (xwaves UI), `formant/`
- `macAudio/` — macOS audio I/O layer (C++/Obj-C, Xcode project)

## Runtime Environment

```bash
export ESPS_BASE=/usr/esps
export PATH=$ESPS_BASE/bin:$PATH
export USE_ESPS_COMMON=off
mkdir -p $HOME/waves/tmp    # required by xwaves for intermediate files
```
