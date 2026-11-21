#!/usr/bin/env python3
"""Place a reference PNG next to a captured build PNG.

Usage (from the repo root):
  python3 tool/compare_screen.py U01

The reference is design/screens/user/U01_*.png or design/screens/host/P01_*.png.
The build capture is design/compare/<ID>_build.png (390x844 at devicePixelRatio 2,
so 780x1688). References are 820x1728 because they include a 10px logical bezel.
This script crops 20 physical pixels off each edge, then writes
design/compare/<ID>_side_by_side.png.
"""

import sys
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
BEZEL_PX = 20
GAP = 24
LABEL_H = 36


def reference_for(screen_id: str) -> Path:
    folder = ROOT / "design" / "screens" / ("host" if screen_id.startswith("P") else "user")
    matches = sorted(folder.glob(f"{screen_id}_*.png"))
    if not matches:
        raise SystemExit(f"no reference for {screen_id} in {folder}")
    return matches[0]


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("usage: python3 tool/compare_screen.py <U01|P01|...>")
    screen_id = sys.argv[1]
    build_path = ROOT / "design" / "compare" / f"{screen_id}_build.png"
    if not build_path.exists():
        raise SystemExit(f"missing capture {build_path}")
    ref = Image.open(reference_for(screen_id)).convert("RGB")
    build = Image.open(build_path).convert("RGB")
    if ref.size != (820, 1728):
        raise SystemExit(f"reference is {ref.size}, expected 820x1728")
    cropped = ref.crop(
        (BEZEL_PX, BEZEL_PX, ref.width - BEZEL_PX, ref.height - BEZEL_PX)
    )
    if cropped.size != build.size:
        raise SystemExit(f"size mismatch: reference crop {cropped.size} vs build {build.size}")
    width = cropped.width * 2 + GAP
    canvas = Image.new("RGB", (width, cropped.height + LABEL_H), (231, 227, 236))
    canvas.paste(cropped, (0, LABEL_H))
    canvas.paste(build, (cropped.width + GAP, LABEL_H))
    draw = ImageDraw.Draw(canvas)
    draw.text((16, 8), f"{screen_id} reference", fill=(42, 34, 51))
    draw.text((cropped.width + GAP + 16, 8), f"{screen_id} build", fill=(42, 34, 51))
    out = ROOT / "design" / "compare" / f"{screen_id}_side_by_side.png"
    canvas.save(out, optimize=True)
    print(out)


if __name__ == "__main__":
    main()
