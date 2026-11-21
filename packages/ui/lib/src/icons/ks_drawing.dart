part of 'ks_icons.dart';

/// One artboard icon, in the SVG 24×24 grid.
///
/// Strokes are the design's: width 2, round caps and joins, no fill.
class KsDrawing {
  const KsDrawing(this.shapes);

  final List<KsShape> shapes;
}

sealed class KsShape {
  const KsShape();
}

class KsSvgPath extends KsShape {
  const KsSvgPath(this.data);

  final String data;
}

class KsSvgCircle extends KsShape {
  const KsSvgCircle(this.cx, this.cy, this.r);

  final double cx;
  final double cy;
  final double r;
}

class KsSvgRect extends KsShape {
  const KsSvgRect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rx = 0,
  });

  final double x;
  final double y;
  final double width;
  final double height;
  final double rx;
}

final Map<String, Path> _svgPaths = {};

Path svgPath(String data) =>
    _svgPaths.putIfAbsent(data, () => parseSvgPath(data));

/// Parses the SVG path commands the artboards use.
Path parseSvgPath(String data) {
  final path = Path();
  final scan = _Scan(data);
  String? command;
  var current = Offset.zero;
  var subpath = Offset.zero;
  Offset? cubicControl;

  while (scan.hasMore) {
    if (scan.isCommand) {
      command = scan.takeCommand();
    } else if (command == 'M') {
      command = 'L';
    } else if (command == 'm') {
      command = 'l';
    } else if (command == null || command == 'Z' || command == 'z') {
      throw FormatException('Unexpected number in SVG path "$data"');
    }

    switch (command) {
      case 'Z':
      case 'z':
        path.close();
        current = subpath;
        cubicControl = null;
      case 'M':
      case 'm':
        final point = _point(scan, command == 'm', current);
        path.moveTo(point.dx, point.dy);
        current = point;
        subpath = point;
        cubicControl = null;
      case 'L':
      case 'l':
        final point = _point(scan, command == 'l', current);
        path.lineTo(point.dx, point.dy);
        current = point;
        cubicControl = null;
      case 'H':
      case 'h':
        final x = scan.number();
        final point = Offset(command == 'h' ? current.dx + x : x, current.dy);
        path.lineTo(point.dx, point.dy);
        current = point;
        cubicControl = null;
      case 'V':
      case 'v':
        final y = scan.number();
        final point = Offset(current.dx, command == 'v' ? current.dy + y : y);
        path.lineTo(point.dx, point.dy);
        current = point;
        cubicControl = null;
      case 'C':
      case 'c':
        final relative = command == 'c';
        final control1 = _point(scan, relative, current);
        final control2 = _point(scan, relative, current);
        final end = _point(scan, relative, current);
        path.cubicTo(
          control1.dx,
          control1.dy,
          control2.dx,
          control2.dy,
          end.dx,
          end.dy,
        );
        current = end;
        cubicControl = control2;
      case 'S':
      case 's':
        final relative = command == 's';
        final reflected = cubicControl == null
            ? current
            : Offset(
                current.dx * 2 - cubicControl.dx,
                current.dy * 2 - cubicControl.dy,
              );
        final control2 = _point(scan, relative, current);
        final end = _point(scan, relative, current);
        path.cubicTo(
          reflected.dx,
          reflected.dy,
          control2.dx,
          control2.dy,
          end.dx,
          end.dy,
        );
        current = end;
        cubicControl = control2;
      case 'A':
      case 'a':
        final rx = scan.number().abs();
        final ry = scan.number().abs();
        final rotation = scan.number();
        final largeArc = scan.flag();
        final sweep = scan.flag();
        final end = _point(scan, command == 'a', current);
        if (rx == 0 || ry == 0 || end == current) {
          path.lineTo(end.dx, end.dy);
        } else {
          path.arcToPoint(
            end,
            radius: Radius.elliptical(rx, ry),
            rotation: rotation * 3.141592653589793 / 180,
            largeArc: largeArc,
            clockwise: sweep,
          );
        }
        current = end;
        cubicControl = null;
      default:
        throw FormatException('Unsupported SVG command "$command" in "$data"');
    }
  }
  return path;
}

Offset _point(_Scan scan, bool relative, Offset current) {
  final x = scan.number();
  final y = scan.number();
  return relative ? Offset(current.dx + x, current.dy + y) : Offset(x, y);
}

class _Scan {
  _Scan(this.source);

  final String source;
  int index = 0;

  bool get hasMore {
    _skipSeparators();
    return index < source.length;
  }

  bool get isCommand {
    _skipSeparators();
    if (index >= source.length) return false;
    final code = source.codeUnitAt(index);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }

  String takeCommand() {
    final command = source[index];
    index++;
    return command;
  }

  double number() {
    _skipSeparators();
    final start = index;
    if (index < source.length &&
        (source[index] == '+' || source[index] == '-')) {
      index++;
    }
    var sawDigit = false;
    while (index < source.length && _isDigit(source.codeUnitAt(index))) {
      sawDigit = true;
      index++;
    }
    if (index < source.length && source[index] == '.') {
      index++;
      while (index < source.length && _isDigit(source.codeUnitAt(index))) {
        sawDigit = true;
        index++;
      }
    }
    if (!sawDigit) {
      throw FormatException('Expected a number at $start in "$source"');
    }
    if (index < source.length &&
        (source[index] == 'e' || source[index] == 'E')) {
      final exponent = index;
      index++;
      if (index < source.length &&
          (source[index] == '+' || source[index] == '-')) {
        index++;
      }
      final exponentDigits = index;
      while (index < source.length && _isDigit(source.codeUnitAt(index))) {
        index++;
      }
      if (index == exponentDigits) index = exponent;
    }
    return double.parse(source.substring(start, index));
  }

  bool flag() {
    _skipSeparators();
    if (index >= source.length) {
      throw FormatException('Expected an arc flag in "$source"');
    }
    final value = source[index];
    if (value != '0' && value != '1') {
      throw FormatException('Expected an arc flag at $index in "$source"');
    }
    index++;
    return value == '1';
  }

  void _skipSeparators() {
    while (index < source.length) {
      final code = source.codeUnitAt(index);
      if (code == 32 || code == 44 || code == 9 || code == 10 || code == 13) {
        index++;
      } else {
        break;
      }
    }
  }

  bool _isDigit(int code) => code >= 48 && code <= 57;
}

class KsStrokePainter extends CustomPainter {
  const KsStrokePainter(this.drawing, {required this.color});

  final KsDrawing drawing;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    for (final shape in drawing.shapes) {
      switch (shape) {
        case KsSvgPath(:final data):
          canvas.drawPath(svgPath(data), paint);
        case KsSvgCircle(:final cx, :final cy, :final r):
          canvas.drawCircle(Offset(cx, cy), r, paint);
        case KsSvgRect(
          :final x,
          :final y,
          :final width,
          :final height,
          :final rx,
        ):
          final rect = Rect.fromLTWH(x, y, width, height);
          if (rx <= 0) {
            canvas.drawRect(rect, paint);
          } else {
            canvas.drawRRect(
              RRect.fromRectAndRadius(rect, Radius.circular(rx)),
              paint,
            );
          }
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(KsStrokePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.drawing != drawing;
}
