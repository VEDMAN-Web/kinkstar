#!/usr/bin/env bash
# Headless user-app captures. Screen branches write
# design/compare/<ID>_build.png from apps/user/test/*capture*.dart, which
# calls tool/capture_frame.dart at 390×844 logical pixels and devicePixelRatio 2.
# Those PNGs are gitignored, so CI runs the same tests before compare_screen.py.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
# capture_frame.dart FontLoads these for letters Inter does not cover, and
# skips the file when it is absent. Developer machines have them from
# fonts-noto-core. The GitHub runner does not, so Indic text paints as boxes.
noto="/usr/share/fonts/truetype/noto/NotoSansDevanagari-Regular.ttf"
if [ ! -f "$noto" ]; then
  echo "Installing fonts-noto-core so capture fallback fonts match a developer machine."
  if ! sudo apt-get update -qq || ! sudo apt-get install -y -qq fonts-noto-core; then
    echo "warning: fonts-noto-core was not installed. Indic glyphs may render as boxes."
  fi
fi
if [ -f "$noto" ]; then
  fc-cache -f >/dev/null 2>&1 || true
  echo "Capture fallback font present: $noto"
else
  echo "Capture fallback font missing: $noto"
fi
cd "$root/apps/user"
shopt -s nullglob
tests=(test/*capture*.dart)
if [ "${#tests[@]}" -eq 0 ]; then
  echo "No apps/user/test/*capture*.dart files. No build captures generated."
  exit 0
fi
echo "Generating build captures: flutter test ${tests[*]}"
flutter test "${tests[@]}"
