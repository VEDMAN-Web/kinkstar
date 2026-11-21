#!/usr/bin/env python3
"""Compare a captured screen with its design reference.

Usage (from the repo root):

    python3 tool/compare_screen.py U11
    python3 tool/compare_screen.py --tolerance 2 U11

The reference is design/screens/user/U11_*.png or design/screens/host/P01_*.png.
The build capture is design/compare/<ID>_build.png (390x844 at devicePixelRatio 2,
so 780x1688). References are 820x1728 because they include a 10px logical bezel.
This script crops 20 physical pixels off each edge, then writes:

- design/compare/<ID>_side_by_side.png
- design/compare/<ID>_diff.png

It prints the percentage of pixels that differ at that shared size. A pixel
counts as different when any RGB channel differs by more than --tolerance.
The default tolerance is 0, so any channel difference counts. The diff image
is the per-channel absolute difference, multiplied by 4 and clamped, so
unchanged pixels are black and small mismatches stay visible.

The process exits 0 even when pixels differ, and also when the capture or
the reference is missing. CI can treat the printed percentage as a warning.
"""

import argparse
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
BEZEL_PX = 20
GAP = 24
LABEL_H = 36


def reference_for(screen_id: str) -> Path:
    folder = ROOT / "design" / "screens" / ("host" if screen_id.startswith("P") else "user")
    matches = sorted(folder.glob(f"{screen_id}_*.png"))
    if not matches:
        raise FileNotFoundError(f"no reference for {screen_id} in {folder}")
    return matches[0]


def difference_percent(
    reference: Image.Image, build: Image.Image, tolerance: int
) -> tuple[float, int, int]:
    diff = ImageChops.difference(reference, build)
    bands = diff.split()
    peak = bands[0]
    for band in bands[1:]:
        peak = ImageChops.lighter(peak, band)
    # histogram()[0] is an exact match. Tolerance 0 keeps "any difference counts".
    changed = sum(peak.histogram()[tolerance + 1 :])
    total = reference.width * reference.height
    percent = 100 * changed / total if total else 0
    return percent, changed, total


def write_diff(reference: Image.Image, build: Image.Image, path: Path) -> None:
    diff = ImageChops.difference(reference, build)
    # Amplify so a 1-level channel miss is still visible. Unchanged stays black.
    amplified = diff.point(lambda value: min(255, value * 4))
    amplified.save(path, optimize=True)


def compare(screen_id: str, tolerance: int) -> None:
    build_path = ROOT / "design" / "compare" / f"{screen_id}_build.png"
    if not build_path.exists():
        print(f"{screen_id} missing capture {build_path}", file=sys.stderr)
        return
    try:
        reference_path = reference_for(screen_id)
    except FileNotFoundError as error:
        print(f"{screen_id} {error}", file=sys.stderr)
        return
    reference = Image.open(reference_path).convert("RGB")
    build = Image.open(build_path).convert("RGB")
    if reference.size != (820, 1728):
        print(
            f"{screen_id} reference is {reference.size[0]}x{reference.size[1]}, expected 820x1728",
            file=sys.stderr,
        )
        return
    cropped = reference.crop(
        (BEZEL_PX, BEZEL_PX, reference.width - BEZEL_PX, reference.height - BEZEL_PX)
    )
    if cropped.size != build.size:
        print(
            f"{screen_id} size mismatch: reference crop {cropped.size[0]}x{cropped.size[1]} "
            f"vs build {build.size[0]}x{build.size[1]}",
            file=sys.stderr,
        )
        return

    percent, changed, total = difference_percent(cropped, build, tolerance)
    diff_path = ROOT / "design" / "compare" / f"{screen_id}_diff.png"
    write_diff(cropped, build, diff_path)
    if tolerance:
        print(f"{screen_id} {percent:.2f}% ({changed}/{total} pixels, tolerance {tolerance})")
    else:
        print(f"{screen_id} {percent:.2f}% ({changed}/{total} pixels)")

    width = cropped.width * 2 + GAP
    canvas = Image.new("RGB", (width, cropped.height + LABEL_H), (231, 227, 236))
    canvas.paste(cropped, (0, LABEL_H))
    canvas.paste(build, (cropped.width + GAP, LABEL_H))
    draw = ImageDraw.Draw(canvas)
    draw.text((16, 8), f"{screen_id} reference", fill=(42, 34, 51))
    draw.text((cropped.width + GAP + 16, 8), f"{screen_id} build", fill=(42, 34, 51))
    side_path = ROOT / "design" / "compare" / f"{screen_id}_side_by_side.png"
    canvas.save(side_path, optimize=True)
    print(side_path)
    print(diff_path)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Compare a captured screen with its design reference."
    )
    parser.add_argument("screen_id", help="Screen id, for example U11 or P01")
    parser.add_argument(
        "--tolerance",
        type=int,
        default=0,
        help="Max per-channel difference that still counts as a match (default 0)",
    )
    args = parser.parse_args()
    if args.tolerance < 0 or args.tolerance > 255:
        print("tolerance must be from 0 to 255", file=sys.stderr)
        return
    compare(args.screen_id, args.tolerance)


if __name__ == "__main__":
    main()
