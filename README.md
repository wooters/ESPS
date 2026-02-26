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
