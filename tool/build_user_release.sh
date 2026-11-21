#!/usr/bin/env bash
# Release APKs split per ABI (armeabi-v7a, arm64-v8a, x86_64).
# Flutter's --split-per-abi is the supported switch. A fat APK is not produced.
set -euo pipefail
cd "$(dirname "$0")/../apps/user"
flutter build apk --release --split-per-abi
echo
echo "APKs:"
find build/app/outputs/flutter-apk -name '*.apk' -exec ls -lh {} \;
