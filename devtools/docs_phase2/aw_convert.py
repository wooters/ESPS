#!/usr/bin/env python3
"""Attempt conversion of legacy Aster*x Words (.aw) documents.

Adapter A: external converter if available.
Adapter B: metadata/text extraction fallback + generated preview asset.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import xml.sax.saxutils as saxutils


def write_preview_svg(path: str, title: str, subtitle: str, lines: list[str]) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    body_lines = lines[:20]
    w = 1200
    h = 220 + max(0, len(body_lines) * 26)
    y = 54

    escaped_title = saxutils.escape(title)
    escaped_subtitle = saxutils.escape(subtitle)
    rendered = [
        f"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"{w}\" height=\"{h}\" viewBox=\"0 0 {w} {h}\">",
        f"  <rect x=\"0\" y=\"0\" width=\"{w}\" height=\"{h}\" fill=\"#f8fafc\" stroke=\"#475569\" stroke-width=\"2\"/>",
        f"  <text x=\"24\" y=\"{y}\" font-family=\"monospace\" font-size=\"28\" fill=\"#0f172a\">{escaped_title}</text>",
    ]
    y += 34
    rendered.append(
        f"  <text x=\"24\" y=\"{y}\" font-family=\"monospace\" font-size=\"16\" fill=\"#334155\">{escaped_subtitle}</text>"
    )
    y += 24
    rendered.append(
        f"  <line x1=\"24\" y1=\"{y}\" x2=\"{w - 24}\" y2=\"{y}\" stroke=\"#94a3b8\" stroke-width=\"1\"/>"
    )
    y += 26

    if not body_lines:
        body_lines = ["(No preview lines extracted from this AW file.)"]

    for line in body_lines:
        txt = saxutils.escape(line)
        rendered.append(
            f"  <text x=\"24\" y=\"{y}\" font-family=\"monospace\" font-size=\"15\" fill=\"#1e293b\">{txt}</text>"
        )
        y += 24

    rendered.append("</svg>")
    svg = "\n".join(rendered) + "\n"
    with open(path, "w", encoding="utf-8") as f:
        f.write(svg)


def run_cmd(cmd: list[str], cwd: str | None = None) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)


def detect_aw(raw: bytes) -> bool:
    head = raw[:4096].decode("latin-1", errors="replace")
    return ("doc.info" in head) or ("Aster" in head) or ("SETUP_" in head)


def extract_metadata(raw: bytes) -> dict:
    text = raw.decode("latin-1", errors="replace")
    lines = text.splitlines()

    setup = {}
    for line in lines:
        if line.startswith("SETUP_") and ":" in line:
            k, v = line.split(":", 1)
            setup[k.strip()] = v.strip()

    saved = None
    for line in lines:
        if "Last saved by Words" in line:
            saved = line.strip()
            break

    info = {
        "detected_format": "Aster*x Words" if detect_aw(raw) else "unknown",
        "setup": setup,
        "saved_line": saved,
        "line_count": len(lines),
    }

    # Pull printable chunks for an extraction report.
    printable = []
    for line in lines:
        if any(token in line for token in ("SETUP_", "Last saved", "printFormat", "pageType", "lMargin", "rMargin", "tMargin")):
            printable.append(line)
    info["printable_snippets"] = printable[:200]
    return info


def extract_preview_lines(raw: bytes) -> list[str]:
    text = raw.decode("latin-1", errors="replace")

    out: list[str] = []
    seen = set()

    def add_line(line: str) -> None:
        clean = " ".join(line.strip().split())
        clean = re.sub(r"[^ -~]", "", clean)
        clean = clean.replace("\\", "").strip()
        if len(clean) < 8 or len(clean) > 140:
            return
        if sum(ch.isalpha() for ch in clean) < 4:
            return
        if clean.startswith(("SETUP_", "RU TB", "H0 ", "H1 ", "AL LI", "CO ", "EF ", "WP ", "RS ", "AT ")):
            return
        if clean.startswith("TX"):
            return
        if clean in {"Footnotes", "footnote"}:
            return
        if clean.startswith("Last saved by Words"):
            return
        if clean.endswith("doc.info 0"):
            return
        if re.match(r'^"[a-z]",\d{4,}', clean):
            return
        if clean.startswith(("SC", "IC CP")):
            return
        if clean in seen:
            return
        seen.add(clean)
        out.append(clean)

    # Prefer text payload lines (TX...) from Aster*x Words content streams.
    for m in re.finditer(r"TX([ -~]{1,180})", text):
        add_line(m.group(1))

    if len(out) >= 5:
        return out[:40]

    # Quoted text often carries visible labels/strings.
    for m in re.finditer(r'"([^"\n]{4,140})"', text):
        add_line(m.group(1))

    # Fallback printable chunks.
    chunks = re.split(r"[^ -~\n\r\t]+", text)
    for chunk in chunks:
        for line in chunk.splitlines():
            add_line(line)

    return out[:40]


def try_external_adapter(input_path: str, out_base: str) -> tuple[bool, str, str | None, list[str], str]:
    warnings: list[str] = []

    # Adapter A1: explicit AW_CONVERTER env var.
    converter = os.environ.get("AW_CONVERTER", "").strip()
    if converter:
        ps_path = out_base + ".ps"
        proc = run_cmd([converter, input_path, ps_path])
        if proc.returncode == 0 and os.path.exists(ps_path):
            png_path = out_base + ".png"
            if shutil.which("gs"):
                gs_cmd = [
                    "gs",
                    "-dSAFER",
                    "-dBATCH",
                    "-dNOPAUSE",
                    "-sDEVICE=png16m",
                    "-r144",
                    f"-sOutputFile={png_path}",
                    ps_path,
                ]
                gs_proc = run_cmd(gs_cmd)
                if gs_proc.returncode == 0 and os.path.exists(png_path):
                    return True, "aw_converter+gs", png_path, warnings, (proc.stderr + "\n" + gs_proc.stderr)
                warnings.append(f"AW_CONVERTER succeeded but gs rasterization failed ({gs_proc.returncode})")
            else:
                warnings.append("AW_CONVERTER produced PS, but gs not available for PNG rasterization")
        else:
            warnings.append(f"AW_CONVERTER failed with code {proc.returncode}")

    # Adapter A2: known command names if installed.
    for cmd_name in ("aw2ps", "asterix2ps"):
        cmd = shutil.which(cmd_name)
        if not cmd:
            continue
        ps_path = out_base + ".ps"
        proc = run_cmd([cmd, input_path])
        if proc.returncode == 0:
            with open(ps_path, "w", encoding="latin-1") as f:
                f.write(proc.stdout)
            png_path = out_base + ".png"
            if shutil.which("gs"):
                gs_cmd = [
                    "gs",
                    "-dSAFER",
                    "-dBATCH",
                    "-dNOPAUSE",
                    "-sDEVICE=png16m",
                    "-r144",
                    f"-sOutputFile={png_path}",
                    ps_path,
                ]
                gs_proc = run_cmd(gs_cmd)
                if gs_proc.returncode == 0 and os.path.exists(png_path):
                    return True, f"{cmd_name}+gs", png_path, warnings, (proc.stderr + "\n" + gs_proc.stderr)
            warnings.append(f"{cmd_name} produced PS but conversion to PNG failed")
        else:
            warnings.append(f"{cmd_name} failed with code {proc.returncode}")

    return False, "none", None, warnings, ""


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert Aster*x Words .aw files")
    parser.add_argument("input", help="Path to .aw file")
    parser.add_argument("out_base", help="Output base path (without extension)")
    args = parser.parse_args()

    out_dir = os.path.dirname(args.out_base)
    os.makedirs(out_dir, exist_ok=True)

    result = {
        "input": args.input,
        "status": "warning",
        "adapter": "none",
        "asset": "",
        "report": args.out_base + ".report.md",
        "metadata": args.out_base + ".json",
        "warnings": [],
    }

    try:
        with open(args.input, "rb") as f:
            raw = f.read()

        if not raw:
            preview = args.out_base + ".svg"
            write_preview_svg(preview, "AW conversion unavailable", "Input is empty.", [])
            result["asset"] = preview
            result["warnings"].append("input file empty")
            print(json.dumps(result, ensure_ascii=True))
            return 0

        metadata = extract_metadata(raw)
        with open(result["metadata"], "w", encoding="utf-8") as f:
            json.dump(metadata, f, indent=2, ensure_ascii=True)

        ok, adapter, asset_path, warn_a, stderr_a = try_external_adapter(args.input, args.out_base)
        result["warnings"].extend(warn_a)

        if ok and asset_path:
            result["status"] = "success"
            result["adapter"] = adapter
            result["asset"] = asset_path
        else:
            # Adapter B: metadata extraction + generated preview card.
            preview = args.out_base + ".svg"
            preview_lines = extract_preview_lines(raw)
            write_preview_svg(
                preview,
                f"AW Preview: {os.path.basename(args.input)}",
                "Generated from extracted text/metadata (no external AW renderer).",
                preview_lines,
            )
            result["status"] = "success"
            result["adapter"] = "metadata_preview"
            result["asset"] = preview

        report_lines = [
            f"# Legacy AW Extraction: `{os.path.basename(args.input)}`",
            "",
            f"- Source: `{args.input}`",
            f"- Adapter: `{result['adapter']}`",
            f"- Status: `{result['status']}`",
            "",
            "## Metadata",
            "",
            "```json",
            json.dumps(metadata, indent=2, ensure_ascii=True),
            "```",
        ]
        if stderr_a.strip():
            report_lines.extend(["", "## Adapter Diagnostics", "", "```text", stderr_a.strip(), "```"])
        if result["warnings"]:
            report_lines.extend(["", "## Warnings", ""])
            report_lines.extend([f"- {w}" for w in result["warnings"]])

        with open(result["report"], "w", encoding="utf-8") as f:
            f.write("\n".join(report_lines) + "\n")

        print(json.dumps(result, ensure_ascii=True))
        return 0
    except Exception as exc:  # pragma: no cover
        preview = args.out_base + ".svg"
        write_preview_svg(preview, "AW conversion failed", str(exc), [])
        result["status"] = "warning"
        result["adapter"] = "exception_fallback"
        result["asset"] = preview
        result["warnings"].append(str(exc))
        with open(result["report"], "w", encoding="utf-8") as f:
            f.write(f"# Legacy AW Extraction Error\n\n- Error: `{exc}`\n")
        print(json.dumps(result, ensure_ascii=True))
        return 0


if __name__ == "__main__":
    sys.exit(main())
