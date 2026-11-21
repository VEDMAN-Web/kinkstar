import 'package:flutter_test/flutter_test.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

void main() {
  test('artboard paths parse and have ink', () {
    const drawings = [
      KsIcons.star,
      KsIcons.zap,
      KsIcons.globe,
      KsIcons.phone,
      KsIcons.shield,
      KsIcons.camera,
      KsIcons.mic,
      KsIcons.bell,
      KsIcons.gem,
      KsIcons.house,
      KsIcons.expand,
      KsIcons.radio,
      KsIcons.messageSquare,
      KsIcons.user,
      KsIcons.info,
      KsIcons.gift,
      KsIcons.logOut,
      KsIcons.trash2,
      KsIcons.plus,
      KsIcons.upload,
      KsIcons.wifi,
    ];
    for (final glyph in drawings) {
      final drawing = (glyph as KsDrawGlyph).drawing;
      expect(drawing.shapes, isNotEmpty);
      for (final shape in drawing.shapes) {
        if (shape is! KsSvgPath) continue;
        final path = parseSvgPath(shape.data);
        expect(
          path.computeMetrics().fold<double>(
            0,
            (sum, metric) => sum + metric.length,
          ),
          greaterThan(0),
        );
      }
    }
  });

  test('arc flags that are written without separators stay separate', () {
    final path = parseSvgPath('M12 2a15 15 0 010 20');
    final metric = path.computeMetrics().single;
    final end = metric.getTangentForOffset(metric.length)!.position;
    expect(end.dx, closeTo(12, 0.01));
    expect(end.dy, closeTo(22, 0.01));
  });

  test('a clockwise arc bends the way the artboard does', () {
    final path = parseSvgPath('M10 0A10 10 0 010 10');
    final metric = path.computeMetrics().single;
    final mid = metric.getTangentForOffset(metric.length / 2)!.position;
    expect(mid.dx, closeTo(7.07, 0.2));
    expect(mid.dy, closeTo(7.07, 0.2));
  });
}
