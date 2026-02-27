#!/usr/bin/env python3
"""Generate mkdocs.yml and section index pages from phase-2 manifests."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
from pathlib import Path
from typing import Any


def q(s: str) -> str:
    return '"' + s.replace('"', '\\"') + '"'


def write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def rel_doc(entry: dict[str, Any]) -> str:
    return entry.get("doc", "")


def title_of(entry: dict[str, Any]) -> str:
    return entry.get("title") or Path(rel_doc(entry)).stem


def list_section(entries: list[dict[str, Any]]) -> str:
    if not entries:
        return "- _No entries generated in this build._\n"
    lines = []
    for e in entries:
        t = title_of(e)
        d = rel_doc(e)
        lines.append(f"- [{t}](/{d})")
    return "\n".join(lines) + "\n"


def build_indexes(docs_dir: Path, content: dict[str, Any], figures: dict[str, Any]) -> None:
    generated = content.get(
        "generated_at",
        dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
    )
    cats = content.get("categories", {})

    man_entries = cats.get("man", [])
    sec1 = [e for e in man_entries if e.get("section") == "1"]
    sec3 = [e for e in man_entries if e.get("section") == "3"]
    sec5 = [e for e in man_entries if e.get("section") == "5"]

    write_text(
        docs_dir / "index.md",
        "\n".join(
            [
                "# ESPS Documentation",
                "",
                "This site is generated from legacy ESPS documentation sources.",
                "",
                f"- Generated: `{generated}`",
                f"- Man pages: `{len(man_entries)}`",
                f"- Notes: `{len(cats.get('notes', []))}`",
                f"- Help docs: `{len(cats.get('help', []))}`",
                f"- Extras: `{len(cats.get('extras', []))}`",
                "",
                "Use the left navigation to browse sections.",
                "",
            ]
        ),
    )

    write_text(
        docs_dir / "man/index.md",
        "\n".join(
            [
                "# Man Pages",
                "",
                f"- Section 1 pages: `{len(sec1)}`",
                f"- Section 3 pages: `{len(sec3)}`",
                f"- Section 5 pages: `{len(sec5)}`",
                "",
            ]
        ),
    )

    write_text(
        docs_dir / "notes/index.md",
        "# Applications Notes / Legacy Docs\n\n" + list_section(cats.get("notes", [])),
    )

    write_text(
        docs_dir / "help/index.md",
        "# Waves Help\n\n" + list_section(cats.get("help", [])),
    )

    write_text(
        docs_dir / "extras/index.md",
        "# Extras\n\n" + list_section(cats.get("extras", [])),
    )

    gps_entries = figures.get("gps", [])
    aw_entries = figures.get("aw", [])
    write_text(
        docs_dir / "figures/index.md",
        "\n".join(
            [
                "# Legacy Figures & Covers",
                "",
                f"- GPS assets: `{len(gps_entries)}`",
                f"- AW assets: `{len(aw_entries)}`",
                "",
                "## GPS Figures",
                "",
            ]
        )
        + list_section(gps_entries)
        + "\n## AW Covers\n\n"
        + list_section(aw_entries),
    )

    write_text(
        docs_dir / "build-reports/index.md",
        "\n".join(
            [
                "# Build Reports",
                "",
                "- [Summary](summary.md)",
                "- [Content Manifest](manifest-content.md)",
                "- [Figure Manifest](manifest-figures.md)",
                "",
            ]
        ),
    )


def build_mkdocs(site_src: Path, content: dict[str, Any], figures: dict[str, Any], base_url: str) -> str:
    cats = content.get("categories", {})
    man_entries = sorted(cats.get("man", []), key=lambda e: (e.get("section", ""), title_of(e).lower()))
    notes_entries = sorted(cats.get("notes", []), key=lambda e: title_of(e).lower())
    help_entries = sorted(cats.get("help", []), key=lambda e: title_of(e).lower())
    extras_entries = sorted(cats.get("extras", []), key=lambda e: title_of(e).lower())
    gps_entries = sorted(figures.get("gps", []), key=lambda e: title_of(e).lower())
    aw_entries = sorted(figures.get("aw", []), key=lambda e: title_of(e).lower())

    lines: list[str] = []
    lines.append(f"site_name: {q('ESPS Documentation (Revival)')}")
    lines.append("extra:")
    lines.append(f"  base_url_hint: {q(base_url)}")
    lines.append(f"docs_dir: {q('docs')}")
    lines.append("use_directory_urls: true")
    lines.append("theme:")
    lines.append("  name: material")
    lines.append("markdown_extensions:")
    lines.append("  - toc")
    lines.append("  - tables")
    lines.append("  - fenced_code")
    lines.append("  - codehilite:")
    lines.append("      guess_lang: false")
    lines.append("      css_class: highlight")
    lines.append("nav:")
    lines.append("  - Home: index.md")

    lines.append("  - Man Pages:")
    lines.append("      - Overview: man/index.md")
    for sec in ("1", "3", "5"):
        lines.append(f"      - Section {sec}:")
        sec_entries = [e for e in man_entries if e.get("section") == sec]
        if not sec_entries:
            lines.append("          - (empty): man/index.md")
        for e in sec_entries:
            lines.append(f"          - {q(title_of(e))}: {q(rel_doc(e))}")

    lines.append("  - Applications Notes / Legacy Docs:")
    lines.append("      - Overview: notes/index.md")
    for e in notes_entries:
        lines.append(f"      - {q(title_of(e))}: {q(rel_doc(e))}")

    lines.append("  - Waves Help:")
    lines.append("      - Overview: help/index.md")
    for e in help_entries:
        lines.append(f"      - {q(title_of(e))}: {q(rel_doc(e))}")

    lines.append("  - Legacy Figures & Covers:")
    lines.append("      - Overview: figures/index.md")
    lines.append("      - GPS Figures:")
    for e in gps_entries:
        lines.append(f"          - {q(title_of(e))}: {q(rel_doc(e))}")
    lines.append("      - AW Covers:")
    for e in aw_entries:
        lines.append(f"          - {q(title_of(e))}: {q(rel_doc(e))}")

    lines.append("  - Extras:")
    lines.append("      - Overview: extras/index.md")
    for e in extras_entries:
        lines.append(f"      - {q(title_of(e))}: {q(rel_doc(e))}")

    lines.append("  - Build Reports:")
    lines.append("      - Overview: build-reports/index.md")
    lines.append("      - Summary: build-reports/summary.md")
    lines.append("      - Content Manifest: build-reports/manifest-content.md")
    lines.append("      - Figure Manifest: build-reports/manifest-figures.md")

    text = "\n".join(lines) + "\n"
    write_text(site_src / "mkdocs.yml", text)
    return text


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate mkdocs nav for phase2 docs site")
    parser.add_argument("--site-src", required=True, help="Phase2 site-src root")
    parser.add_argument("--manifest-content", required=True, help="Path to manifest.content.json")
    parser.add_argument("--manifest-figures", required=True, help="Path to manifest.figures.json")
    parser.add_argument("--base-url", default="/", help="Base URL")
    args = parser.parse_args()

    site_src = Path(args.site_src)
    docs_dir = site_src / "docs"

    with open(args.manifest_content, "r", encoding="utf-8") as f:
        content = json.load(f)
    with open(args.manifest_figures, "r", encoding="utf-8") as f:
        figures = json.load(f)

    build_indexes(docs_dir, content, figures)
    build_mkdocs(site_src, content, figures, args.base_url)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
