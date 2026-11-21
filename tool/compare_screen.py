#!/usr/bin/env python3
"""Compare a captured screen with its design reference.

Usage (from the repo root):

    python3 tool/compare_screen.py U23

The reference is design/screens/user/U23_*.png or design/screens/host/P01_*.png.
The build capture is design/compare/<ID>_build.png (390x844 at devicePixelRatio 2,
so 780x1688). References are 820x1728 because they include a 10px logical bezel.
This script crops 20 physical pixels off each edge, then writes:

- design/compare/<ID>_side_by_side.png
- design/compare/<ID>_diff.png

It prints two percentages at that shared size. The first is the share of pixels
where any RGB channel differs. The second is the share of pixels whose channels
differ by at most 2. The diff image is the per-channel absolute difference,
multiplied by 4 and clamped, so unchanged pixels are black and small mismatches
stay visible.

The process exits 0 even when pixels differ, and also when the capture or
the reference is missing. CI can treat the printed percentage as a warning.
"""

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
    reference: Image.Image, build: Image.Image
) -> tuple[float, float, int, int]:
    diff = ImageChops.difference(reference, build)
    bands = diff.split()
    peak = bands[0]
    for band in bands[1:]:
        peak = ImageChops.lighter(peak, band)
    histogram = peak.histogram()
    changed = sum(histogram[1:])
    within = sum(histogram[:3])
    total = reference.width * reference.height
    percent = 100 * changed / total if total else 0
    within_percent = 100 * within / total if total else 0
    return percent, within_percent, changed, total


def write_diff(reference: Image.Image, build: Image.Image, path: Path) -> None:
    diff = ImageChops.difference(reference, build)
    amplified = diff.point(lambda value: min(255, value * 4))
    amplified.save(path, optimize=True)


def compare(screen_id: str) -> None:
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

    percent, within_percent, changed, total = difference_percent(cropped, build)
    diff_path = ROOT / "design" / "compare" / f"{screen_id}_diff.png"
    write_diff(cropped, build, diff_path)
    print(
        f"{screen_id} {percent:.2f}% ({changed}/{total} pixels); "
        f"{within_percent:.2f}% within 2 levels"
    )

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
    if len(sys.argv) != 2:
        print("usage: python3 tool/compare_screen.py <U01|P01|...>", file=sys.stderr)
        return
    compare(sys.argv[1])


if __name__ == "__main__":
    main()
