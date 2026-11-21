import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders [widget] at 390×844 logical pixels and devicePixelRatio 2
/// (780×1688 physical pixels).
///
/// Reference PNGs are 820×1728: the same frame plus a 10px logical bezel
/// (20 physical pixels) and rounded-corner canvas. [tool/compare_screen.py]
/// crops that bezel before placing the two images side by side.
Future<File> captureFrame(
  WidgetTester tester, {
  required Widget widget,
  required String outputPath,
  Size logicalSize = const Size(390, 844),
  double devicePixelRatio = 2,
}) async {
  await tester.binding.setSurfaceSize(logicalSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  // Widget tests do not load pubspec fonts. Without this, glyphs paint as
  // empty boxes and the side-by-side is unreadable.
  await tester.runAsync(_loadPackageFonts);

  final boundaryKey = GlobalKey();
  await tester.pumpWidget(
    RepaintBoundary(key: boundaryKey, child: widget),
  );
  // A fixed number of frames. A repeating ticker would keep pumpAndSettle
  // open until the test timeout.
  for (var i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }

  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(boundaryKey),
  );
  // Raster and file futures never complete in the test's fake async zone.
  // toImage is started here, then awaited with real async. The PNG write
  // stays synchronous.
  final imageFuture = boundary.toImage(pixelRatio: devicePixelRatio);
  final bytes = await tester.runAsync(() async {
    final image = await imageFuture;
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data;
  });
  final file = File(outputPath);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(bytes!.buffer.asUint8List());
  return file;
}

const _fontPackage = 'packages/kinkstar_ui';
const _fontAsset = 'packages/kinkstar_ui/assets/fonts';

Future<void> _loadPackageFonts() async {
  await _loadFamily('$_fontPackage/Inter', const [
    '$_fontAsset/Inter-400.ttf',
    '$_fontAsset/Inter-500.ttf',
    '$_fontAsset/Inter-600.ttf',
    '$_fontAsset/Inter-700.ttf',
  ]);
  await _loadFamily('$_fontPackage/Poppins', const [
    '$_fontAsset/Poppins-600.ttf',
    '$_fontAsset/Poppins-700.ttf',
  ]);
  await _loadFamily('$_fontPackage/Lucide', const [
    '$_fontAsset/Lucide.ttf',
  ]);
}

Future<void> _loadFamily(String family, List<String> assets) async {
  final loader = FontLoader(family);
  for (final asset in assets) {
    loader.addFont(rootBundle.load(asset));
  }
  await loader.load();
}
