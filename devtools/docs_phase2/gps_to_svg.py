#!/usr/bin/env python3
"""Convert legacy ESPS GPS (Masscomp Graphic Primitive String) files to SVG."""

from __future__ import annotations

import argparse
import json
import math
import os
import struct
import sys
import xml.sax.saxutils as saxutils
from dataclasses import dataclass
from typing import List, Tuple


@dataclass
class Polyline:
    points: List[Tuple[float, float]]


@dataclass
class TextItem:
    x: float
    y: float
    size: int
    rotation: int
    text: str


def write_placeholder(path: str, title: str, detail: str) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    w, h = 960, 220
    safe_title = saxutils.escape(title)
    safe_detail = saxutils.escape(detail)
    svg = f"""<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"{w}\" height=\"{h}\" viewBox=\"0 0 {w} {h}\">\n  <rect x=\"0\" y=\"0\" width=\"{w}\" height=\"{h}\" fill=\"#fff7ed\" stroke=\"#f59e0b\" stroke-width=\"2\"/>\n  <text x=\"24\" y=\"64\" font-family=\"monospace\" font-size=\"24\" fill=\"#7c2d12\">{safe_title}</text>\n  <text x=\"24\" y=\"104\" font-family=\"monospace\" font-size=\"16\" fill=\"#7c2d12\">{safe_detail}</text>\n</svg>\n"""
    with open(path, "w", encoding="utf-8") as f:
        f.write(svg)


def parse_gps(raw: bytes) -> Tuple[List[Polyline], List[TextItem], List[str], dict]:
    polylines: List[Polyline] = []
    texts: List[TextItem] = []
    warnings: List[str] = []
    commands: dict = {}

    idx = 0
    n = len(raw)

    def need(bytes_needed: int, context: str) -> bool:
        if idx + bytes_needed <= n:
            return True
        warnings.append(f"truncated input while reading {context}")
        return False

    while idx + 2 <= n:
        word = struct.unpack_from(">H", raw, idx)[0]
        idx += 2

        code = (word >> 12) & 0xF
        length = word & 0x0FFF
        commands[str(code)] = commands.get(str(code), 0) + 1

        if length < 1:
            warnings.append(f"invalid command length {length} for code {code}")
            break

        payload_words = length - 1
        payload_bytes = payload_words * 2
        if not need(payload_bytes, f"code {code}"):
            break

        payload = raw[idx : idx + payload_bytes]
        idx += payload_bytes

        if code == 0:
            # line/polyline: 2*(npoints) coordinate words then one style/bundle word.
            if length < 4 or (length % 2) != 0:
                warnings.append(f"invalid line command length={length}")
                continue
            coord_words = payload_words - 1
            points = []
            for off in range(0, coord_words * 2, 4):
                x = struct.unpack_from(">h", payload, off)[0]
                y = struct.unpack_from(">h", payload, off + 2)[0]
                points.append((float(x), float(y)))
            if len(points) >= 2:
                polylines.append(Polyline(points=points))
        elif code == 2:
            # text: x,y,bundle,size/rotation, then packed chars.
            if length < 6:
                warnings.append(f"invalid text command length={length}")
                continue
            x = struct.unpack_from(">h", payload, 0)[0]
            y = struct.unpack_from(">h", payload, 2)[0]
            size_rot = struct.unpack_from(">H", payload, 6)[0]
            size = (size_rot >> 8) & 0xFF
            rotation = size_rot & 0xFF
            char_words = payload_words - 4
            chars = bytearray()
            for off in range(8, 8 + char_words * 2):
                chars.append(payload[off])
            text = chars.rstrip(b"\x00").decode("latin-1", errors="replace")
            texts.append(TextItem(x=float(x), y=float(y), size=size, rotation=rotation, text=text))
        elif code == 15:
            # comment payload ignored.
            pass
        else:
            warnings.append(f"unsupported command code {code}")

    if idx != n:
        warnings.append("extra trailing bytes found after parse")

    return polylines, texts, warnings, commands


def emit_svg(path: str, polylines: List[Polyline], texts: List[TextItem]) -> None:
    xs: List[float] = []
    ys: List[float] = []

    for pl in polylines:
        for x, y in pl.points:
            xs.append(x)
            ys.append(y)

    for t in texts:
        xs.append(t.x)
        ys.append(t.y)

    if not xs or not ys:
        write_placeholder(path, "GPS figure has no drawable content", "No line/text elements parsed.")
        return

    min_x = min(xs)
    max_x = max(xs)
    min_y = min(ys)
    max_y = max(ys)

    pad = 24.0
    width = max(320.0, (max_x - min_x) + 2 * pad)
    height = max(220.0, (max_y - min_y) + 2 * pad)

    def tx(x: float) -> float:
        return x - min_x + pad

    def ty(y: float) -> float:
        return max_y - y + pad

    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(
            f"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"{width:.0f}\" height=\"{height:.0f}\" "
            f"viewBox=\"0 0 {width:.3f} {height:.3f}\">\n"
        )
        f.write("  <rect x=\"0\" y=\"0\" width=\"100%\" height=\"100%\" fill=\"#ffffff\"/>\n")

        for pl in polylines:
            pts = " ".join(f"{tx(x):.3f},{ty(y):.3f}" for x, y in pl.points)
            f.write(
                "  <polyline "
                f"points=\"{pts}\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"1.2\" "
                "stroke-linecap=\"round\" stroke-linejoin=\"round\"/>\n"
            )

        for t in texts:
            xx = tx(t.x)
            yy = ty(t.y)
            rot = -360.0 * (float(t.rotation) / 256.0)
            fs = max(8.0, float(t.size) * 1.2)
            text = saxutils.escape(t.text)
            transform = ""
            if abs(rot) > 0.01:
                transform = f" transform=\"rotate({rot:.3f} {xx:.3f} {yy:.3f})\""
            f.write(
                f"  <text x=\"{xx:.3f}\" y=\"{yy:.3f}\"{transform} "
                f"font-family=\"monospace\" font-size=\"{fs:.3f}\" fill=\"#111827\">{text}</text>\n"
            )

        f.write("</svg>\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert ESPS GPS file to SVG")
    parser.add_argument("input", help="Path to .gps input file")
    parser.add_argument("output", help="Path to .svg output file")
    args = parser.parse_args()

    result = {
        "input": args.input,
        "output": args.output,
        "status": "error",
        "warnings": [],
        "commands": {},
        "elements": {"polylines": 0, "texts": 0},
    }

    try:
        with open(args.input, "rb") as f:
            raw = f.read()

        if len(raw) < 2:
            write_placeholder(args.output, "GPS conversion failed", "Input file is empty or truncated.")
            result["status"] = "warning"
            result["warnings"] = ["input file empty or truncated"]
            print(json.dumps(result, ensure_ascii=True))
            return 0

        polylines, texts, warnings, commands = parse_gps(raw)
        emit_svg(args.output, polylines, texts)

        result["commands"] = commands
        result["elements"] = {"polylines": len(polylines), "texts": len(texts)}
        result["warnings"] = warnings
        if warnings:
            result["status"] = "warning"
        else:
            result["status"] = "success"

        print(json.dumps(result, ensure_ascii=True))
        return 0
    except Exception as exc:  # pragma: no cover - defensive CLI guard
        write_placeholder(args.output, "GPS conversion failed", str(exc))
        result["status"] = "warning"
        result["warnings"] = [str(exc)]
        print(json.dumps(result, ensure_ascii=True))
        return 0


if __name__ == "__main__":
    sys.exit(main())
