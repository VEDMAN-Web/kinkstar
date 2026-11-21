# Kinkstar

User app (`apps/user`) and host app (`apps/host`) for 1-to-1 video and voice calls. Shared theme, icons, and config loading live in `packages/ui` (package name `kinkstar_ui`).

This branch is the scaffold only. Feature screens are listed in [docs/SCREENS.md](docs/SCREENS.md) and are not built yet. Each app opens `/` with a themed placeholder that reads config.

## Layout

- `apps/user`, `apps/host` — Flutter apps (Android and iOS). State is Riverpod. Routing is go_router.
- `packages/ui` — tokens and theme, Lucide icon font, config loader, placeholder home.
- `design/source/user`, `design/source/host` — exported HTML. Not an app asset.
- `design/screens/user`, `design/screens/host` — 820×1728 reference PNGs. Not an app asset.
- `packages/ui/assets/config/config.json` — byte-for-byte copy of `mock/config.json` from `feature/mock-data` (PR #1). That branch owns `mock/`. This branch does not modify it.

## Tokens

- `packages/ui/lib/src/theme/user_theme.dart` — user dark palette.
- `packages/ui/lib/src/theme/host_theme.dart` — host light palette.

## Assumptions

- Pub workspace (Dart 3.14 / Flutter 3.50) instead of Melos. No extra tool.
- Package name `kinkstar_ui` so imports do not collide with `dart:ui`.
- Application ids are `app.kinkstar.kinkstar_user` and `app.kinkstar.kinkstar_host` (Flutter's default from the project names).
- English is the fallback language code. The JSON has no default-language field. The design pre-selects English.
- Inter and Poppins do not contain Indic glyphs. Those strings use the platform font.
- One Lucide font (regular stroke) instead of the `lucide_icons_flutter` package, which also ships six extra stroke weights.
- Host photos, banners, and gift animations are not in the app. The only image asset is `packages/ui/assets/images/fallback.png`.
- iOS projects are generated and not built here (Linux).

## Commands

```bash
flutter pub get
flutter analyze
flutter test
python3 tool/compare_screen.py U01
bash tool/build_user_release.sh
```

`flutter analyze` and `flutter test` are run in each of `apps/user`, `apps/host`, and `packages/ui`. Release APKs are split per ABI (`--split-per-abi`): armeabi-v7a, arm64-v8a, x86_64. There is no universal APK.

## User release APK size

Measured with `bash tool/build_user_release.sh` (Flutter 3.50.1). Bytes are the file size on disk. The megabyte figure is what Flutter prints.

| ABI | Bytes | Flutter |
| --- | ---: | --- |
| armeabi-v7a | 13,941,235 | 13.9MB |
| arm64-v8a | 16,354,043 | 16.4MB |
| x86_64 | 17,671,381 | 17.7MB |

armeabi-v7a is under the 15MB target. arm64-v8a and x86_64 are over it. On arm64 the APK is `libflutter.so` (11,346,352 bytes) plus `libapp.so` (4,457,432 bytes). Bundled fonts, the Lucide font (tree-shaken from 986,208 bytes to 992), config, and the fallback image are about 250KB together. Both native libraries are already stripped, so there is no further debug-info cut available without dropping Material.
