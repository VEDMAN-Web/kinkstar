import 'package:flutter/widgets.dart';

part 'ks_drawing.dart';

/// Artboard icon. A [KsFontGlyph] is a Lucide code point whose outline matches
/// the design SVG. A [KsDrawGlyph] is the design SVG itself, stroked in a
/// 24px box, which is lighter than keeping a second outline in the icon font.
sealed class KsGlyph {
  const KsGlyph();
}

final class KsFontGlyph extends KsGlyph {
  const KsFontGlyph(this.icon);

  final IconData icon;
}

final class KsDrawGlyph extends KsGlyph {
  const KsDrawGlyph(this.drawing);

  final KsDrawing drawing;
}

/// Icons used by the design SVGs.
///
/// [chevronDown], [chevronLeft], [chevronRight], [ban], [check], [clock4],
/// and [lock] are the current Lucide outlines, which match those artboard
/// paths. Glyphs whose Lucide outline does not match the design SVG are
/// [KsDrawGlyph]s: [star], [zap], [globe], [phone], [shield], [camera],
/// [mic], [bell], [gem], [house], [expand], [radio], [messageSquare],
/// [user], [video], [bot], [gift], [crown], [heart], [ellipsisVertical],
/// [trophy], [image], [send], [sparkle], and [wallet].
///
/// Release builds tree-shake the Lucide font down to the code points still
/// referenced by [KsFontGlyph] constants.
@staticIconProvider
abstract final class KsIcons {
  static const String family = 'Lucide';
  static const String package = 'kinkstar_ui';

  static const KsGlyph chevronDown = KsFontGlyph(
    IconData(57453, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph chevronLeft = KsFontGlyph(
    IconData(57454, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph chevronRight = KsFontGlyph(
    IconData(57455, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph ban = KsFontGlyph(
    IconData(57425, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph check = KsFontGlyph(
    IconData(57452, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph clock4 = KsFontGlyph(
    IconData(57937, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph lock = KsFontGlyph(
    IconData(57611, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph gem = KsDrawGlyph(
    KsDrawing([
      KsSvgPath('M6 3h12l4 6-10 12L2 9z'),
      KsSvgPath('M2 9h20M12 21L8 9l4-6 4 6z'),
    ]),
  );
  static const KsGlyph video = KsDrawGlyph(
    KsDrawing([
      KsSvgRect(x: 2, y: 6, width: 14, height: 12, rx: 2),
      KsSvgPath('M16 10l6-3v10l-6-3z'),
    ]),
  );
  static const KsGlyph camera = KsDrawGlyph(
    KsDrawing([
      KsSvgPath(
        'M23 19a2 2 0 01-2 2H3a2 2 0 01-2-2V8a2 2 0 012-2h4l2-3h6l2 3h4a2 2 0 012 2z',
      ),
      KsSvgCircle(12, 13, 4),
    ]),
  );
  static const KsGlyph phoneOff = KsFontGlyph(
    IconData(57656, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph phone = KsDrawGlyph(
    KsDrawing([
      KsSvgPath(
        'M22 16.9v3a2 2 0 01-2.2 2 19.8 19.8 0 01-8.6-3.1 19.5 19.5 0 01-6-6A19.8 19.8 0 012.1 4.2 2 2 0 014.1 2h3a2 2 0 012 1.7c.1.9.4 1.8.7 2.7a2 2 0 01-.5 2.1L8.1 9.8a16 16 0 006 6l1.3-1.3a2 2 0 012.1-.4c.9.3 1.8.6 2.7.7a2 2 0 011.8 2z',
      ),
    ]),
  );
  static const KsGlyph mic = KsDrawGlyph(
    KsDrawing([
      KsSvgRect(x: 9, y: 2, width: 6, height: 12, rx: 3),
      KsSvgPath('M5 10a7 7 0 0014 0M12 19v3'),
    ]),
  );
  static const KsGlyph micOff = KsFontGlyph(
    IconData(57625, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph shield = KsDrawGlyph(
    KsDrawing([KsSvgPath('M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z')]),
  );
  static const KsGlyph bot = KsDrawGlyph(
    KsDrawing([
      KsSvgRect(x: 4, y: 8, width: 16, height: 12, rx: 3),
      KsSvgPath('M12 4v4M9 13h.01M15 13h.01M9 17h6'),
    ]),
  );
  static const KsGlyph info = KsFontGlyph(
    IconData(57593, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph bell = KsDrawGlyph(
    KsDrawing([
      KsSvgPath(
        'M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9M13.7 21a2 2 0 01-3.4 0',
      ),
    ]),
  );
  static const KsGlyph gift = KsDrawGlyph(
    KsDrawing([
      KsSvgRect(x: 3, y: 8, width: 18, height: 13, rx: 1),
      KsSvgPath(
        'M12 8v13M3 12h18M12 8S10 3 7.5 4 9 8 12 8zm0 0s2-5 4.5-4S15 8 12 8z',
      ),
    ]),
  );
  static const KsGlyph globe = KsDrawGlyph(
    KsDrawing([
      KsSvgCircle(12, 12, 10),
      KsSvgPath('M2 12h20M12 2a15 15 0 010 20M12 2a15 15 0 000 20'),
    ]),
  );
  static const KsGlyph logOut = KsFontGlyph(
    IconData(57614, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph trash2 = KsFontGlyph(
    IconData(57742, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph plus = KsFontGlyph(
    IconData(57661, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph messageSquare = KsDrawGlyph(
    KsDrawing([
      KsSvgPath('M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z'),
    ]),
  );
  static const KsGlyph crown = KsDrawGlyph(
    KsDrawing([KsSvgPath('M2 18h20l-2-11-5 5-3-7-3 7-5-5z')]),
  );
  static const KsGlyph x = KsFontGlyph(
    IconData(57778, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph creditCard = KsFontGlyph(
    IconData(57514, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph zap = KsDrawGlyph(
    KsDrawing([KsSvgPath('M13 2L3 14h9l-1 8 10-12h-9z')]),
  );
  static const KsGlyph calendar = KsFontGlyph(
    IconData(57443, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph expand = KsDrawGlyph(
    KsDrawing([KsSvgPath('M16 3h5v5M4 20L21 3M21 16v5h-5M15 15l6 6M4 4l5 5')]),
  );
  static const KsGlyph heart = KsDrawGlyph(
    KsDrawing([
      KsSvgPath(
        'M20.8 4.6a5.5 5.5 0 00-7.8 0L12 5.7l-1-1.1a5.5 5.5 0 00-7.8 7.8l1 1L12 21l7.8-7.6 1-1a5.5 5.5 0 000-7.8z',
      ),
    ]),
  );
  static const KsGlyph flag = KsFontGlyph(
    IconData(57553, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph switchCamera = KsFontGlyph(
    IconData(57724, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph star = KsDrawGlyph(
    KsDrawing([
      KsSvgPath(
        'M12 2l3.1 6.3 6.9 1-5 4.9 1.2 6.8L12 17.8 5.8 21l1.2-6.8-5-4.9 6.9-1z',
      ),
    ]),
  );
  static const KsGlyph filter = KsFontGlyph(
    IconData(57564, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph house = KsDrawGlyph(
    KsDrawing([
      KsSvgPath('M3 10l9-7 9 7v10a2 2 0 01-2 2h-4v-7H9v7H5a2 2 0 01-2-2z'),
    ]),
  );
  static const KsGlyph radio = KsDrawGlyph(
    KsDrawing([
      KsSvgCircle(12, 12, 3),
      KsSvgPath(
        'M16.2 7.8a6 6 0 010 8.4M7.8 16.2a6 6 0 010-8.4M19.1 4.9a10 10 0 010 14.2M4.9 19.1a10 10 0 010-14.2',
      ),
    ]),
  );
  static const KsGlyph user = KsDrawGlyph(
    KsDrawing([KsSvgCircle(12, 8, 4), KsSvgPath('M4 21a8 8 0 0116 0')]),
  );
  static const KsGlyph share2 = KsFontGlyph(
    IconData(57686, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph ellipsisVertical = KsDrawGlyph(
    KsDrawing([
      KsSvgCircle(12, 5, 1),
      KsSvgCircle(12, 12, 1),
      KsSvgCircle(12, 19, 1),
    ]),
  );
  static const KsGlyph search = KsFontGlyph(
    IconData(57681, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph trophy = KsDrawGlyph(
    KsDrawing([
      KsSvgPath(
        'M8 21h8M12 17v4M7 4h10v5a5 5 0 01-10 0zM17 5h3v2a3 3 0 01-3 3M7 5H4v2a3 3 0 003 3',
      ),
    ]),
  );
  static const KsGlyph users = KsFontGlyph(
    IconData(57764, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph upload = KsFontGlyph(
    IconData(57758, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph wifi = KsFontGlyph(
    IconData(57774, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph image = KsDrawGlyph(
    KsDrawing([
      KsSvgRect(x: 3, y: 3, width: 18, height: 18, rx: 2),
      KsSvgCircle(8.5, 8.5, 1.5),
      KsSvgPath('M21 15l-5-5L5 21'),
    ]),
  );
  static const KsGlyph send = KsDrawGlyph(
    KsDrawing([KsSvgPath('M22 2L11 13M22 2l-7 20-4-9-9-4z')]),
  );
  static const KsGlyph sparkle = KsDrawGlyph(
    KsDrawing([KsSvgPath('M12 3l2 6 6 2-6 2-2 6-2-6-6-2 6-2z')]),
  );
  static const KsGlyph wallet = KsDrawGlyph(
    KsDrawing([
      KsSvgRect(x: 2, y: 6, width: 20, height: 14, rx: 2),
      KsSvgPath('M16 13h2M2 10h20M6 6V4h12v2'),
    ]),
  );
  static const KsGlyph settings = KsFontGlyph(
    IconData(57684, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph circleHelp = KsFontGlyph(
    IconData(57474, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph chartLine = KsFontGlyph(
    IconData(58021, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph eye = KsFontGlyph(
    IconData(57530, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph smile = KsFontGlyph(
    IconData(57700, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph landmark = KsFontGlyph(
    IconData(57914, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph fileText = KsFontGlyph(
    IconData(57548, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph pause = KsFontGlyph(
    IconData(57646, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph idCard = KsFontGlyph(
    IconData(58903, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph list = KsFontGlyph(
    IconData(57606, fontFamily: family, fontPackage: package),
  );
}

/// Design icon size. `.ic` is 22×22; larger circles are tap targets, not glyphs.
class KsIcon extends StatelessWidget {
  const KsIcon(this.glyph, {super.key, this.size = 22, this.color});

  final KsGlyph glyph;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return switch (glyph) {
      KsFontGlyph(:final icon) => Icon(icon, size: size, color: color),
      KsDrawGlyph(:final drawing) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: KsStrokePainter(
            drawing,
            color:
                color ?? IconTheme.of(context).color ?? const Color(0xFF000000),
          ),
        ),
      ),
    };
  }
}
