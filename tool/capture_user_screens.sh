#!/usr/bin/env bash
# Headless user-app captures. Screen branches write
# design/compare/<ID>_build.png from apps/user/test/*capture*.dart, which
# calls tool/capture_frame.dart. Those PNGs are gitignored, so CI runs the
# same tests before compare_screen.py.
set -euo pipefail
cd "$(dirname "$0")/../apps/user"
shopt -s nullglob
tests=(test/*capture*.dart)
if [ "${#tests[@]}" -eq 0 ]; then
  echo "No apps/user/test/*capture*.dart files. No build captures generated."
  exit 0
fi
echo "Generating build captures: flutter test ${tests[*]}"
flutter test "${tests[@]}"
