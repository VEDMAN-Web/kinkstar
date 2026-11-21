import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
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
  tester.view.devicePixelRatio = devicePixelRatio;
  tester.view.physicalSize = logicalSize * devicePixelRatio;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final boundaryKey = GlobalKey();
  await tester.pumpWidget(
    RepaintBoundary(key: boundaryKey, child: widget),
  );
  await tester.pumpAndSettle(
    const Duration(milliseconds: 100),
    EnginePhase.sendSemanticsUpdate,
    const Duration(seconds: 3),
  );

  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(boundaryKey),
  );
  // toImage completes on the engine's raster thread. The test binding's fake
  // async zone never delivers that callback, so this has to run as real async.
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: devicePixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data;
  });
  final file = File(outputPath);
  await file.parent.create(recursive: true);
  await file.writeAsBytes(bytes!.buffer.asUint8List());
  return file;
}
