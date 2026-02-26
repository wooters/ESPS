#!/usr/bin/env python3
"""Validate internal links in built mkdocs HTML output."""

from __future__ import annotations

import argparse
import html.parser
import json
import os
import sys
import urllib.parse
from pathlib import Path


class LinkParser(html.parser.HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.links: list[str] = []

    def handle_starttag(self, tag: str, attrs):
        for k, v in attrs:
            if k in ("href", "src") and v:
                self.links.append(v)


def is_external(url: str) -> bool:
    u = url.lower()
    return (
        u.startswith("http://")
        or u.startswith("https://")
        or u.startswith("mailto:")
        or u.startswith("javascript:")
        or u.startswith("data:")
        or u.startswith("tel:")
    )


def resolve_target(site_dir: Path, html_file: Path, link: str) -> Path:
    clean = link.split("#", 1)[0].split("?", 1)[0]
    clean = urllib.parse.unquote(clean)

    if clean.startswith("/"):
        target = site_dir / clean.lstrip("/")
    else:
        target = (html_file.parent / clean).resolve()

    return target


def exists_target(path: Path) -> bool:
    if path.exists():
        return True
    if path.suffix.lower() == ".md":
        no_md = path.with_suffix("")
        if no_md.exists():
            return True
        if no_md.is_dir() and (no_md / "index.html").exists():
            return True
        if Path(str(no_md) + "/index.html").exists():
            return True
    if path.is_dir() and (path / "index.html").exists():
        return True
    if path.suffix == "" and (Path(str(path) + "/index.html")).exists():
        return True
    return False


def main() -> int:
    parser = argparse.ArgumentParser(description="Check internal links in built docs site")
    parser.add_argument("--site-dir", required=True, help="Path to built site root")
    parser.add_argument("--out-json", default="", help="Optional output JSON report")
    args = parser.parse_args()

    site_dir = Path(args.site_dir).resolve()
    html_files = sorted(site_dir.rglob("*.html"))

    issues: list[dict] = []
    checked = 0

    for html_path in html_files:
        parser_html = LinkParser()
        parser_html.feed(html_path.read_text(encoding="utf-8", errors="replace"))

        for raw in parser_html.links:
            if not raw or raw.startswith("#") or is_external(raw):
                continue
            checked += 1
            target = resolve_target(site_dir, html_path.resolve(), raw)
            if not exists_target(target):
                issues.append(
                    {
                        "file": str(html_path.relative_to(site_dir)),
                        "link": raw,
                        "resolved": str(target),
                    }
                )

    report = {
        "site_dir": str(site_dir),
        "html_files": len(html_files),
        "links_checked": checked,
        "broken_links": len(issues),
        "issues": issues[:1000],
    }

    if args.out_json:
        out = Path(args.out_json)
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(report, indent=2, ensure_ascii=True) + "\n", encoding="utf-8")

    if issues:
        print(f"linkcheck: found {len(issues)} broken internal links", file=sys.stderr)
        for item in issues[:40]:
            print(
                f"  {item['file']}: {item['link']} -> {item['resolved']}",
                file=sys.stderr,
            )
        return 1

    print(f"linkcheck: ok ({checked} links across {len(html_files)} html files)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
