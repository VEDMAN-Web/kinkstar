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
/// paths. The U01–U10 glyphs that did not match are [KsDrawGlyph]s of the
/// exact design paths: [star], [zap], [globe], [phone], [shield], [camera],
/// [mic], [bell], [gem], [house], [expand], [radio], [messageSquare], and
/// [user].
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
  static const KsGlyph video = KsFontGlyph(
    IconData(57765, fontFamily: family, fontPackage: package),
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
  static const KsGlyph bot = KsFontGlyph(
    IconData(57787, fontFamily: family, fontPackage: package),
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
  static const KsGlyph gift = KsFontGlyph(
    IconData(57569, fontFamily: family, fontPackage: package),
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
  static const KsGlyph crown = KsFontGlyph(
    IconData(57814, fontFamily: family, fontPackage: package),
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
  static const KsGlyph heart = KsFontGlyph(
    IconData(57586, fontFamily: family, fontPackage: package),
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
  static const KsGlyph ellipsisVertical = KsFontGlyph(
    IconData(57527, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph search = KsFontGlyph(
    IconData(57681, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph trophy = KsFontGlyph(
    IconData(58227, fontFamily: family, fontPackage: package),
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
  static const KsGlyph image = KsFontGlyph(
    IconData(57590, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph send = KsFontGlyph(
    IconData(57682, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph sparkle = KsFontGlyph(
    IconData(58494, fontFamily: family, fontPackage: package),
  );
  static const KsGlyph wallet = KsFontGlyph(
    IconData(57860, fontFamily: family, fontPackage: package),
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
