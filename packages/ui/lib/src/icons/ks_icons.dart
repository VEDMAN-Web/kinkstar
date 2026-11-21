import 'package:flutter/widgets.dart';

/// Lucide regular (stroke) icons used by the design SVGs.
///
/// The design draws inline Feather/Lucide-style paths (24px grid, stroke 2,
/// round caps). Six of those paths match the current Lucide font exactly:
/// [chevronLeft], [chevronRight], [ban], [check], [clock4], [lock].
/// The rest are the same icon names with older or simplified outlines, so
/// the glyph is close but not identical. Notable mismatches:
///
/// * [gem] is Lucide's faceted gem. The design diamond has a different
///   facet path (`M6 3h12l4 6-10 12L2 9z`). Lucide `diamond` is a card-suit
///   rhombus and is a worse match, so it is not used.
/// * [star] is a stroked five-point star. The design star is a slightly
///   different polygon, and CSS `fill: none` strokes it rather than filling it.
/// * [house] includes a door in the design path; the current Lucide house
///   outline differs.
/// * [expand] stands in for the Quick Match control
///   (`M16 3h5v5M4 20L21 3…`). That drawing is not a Lucide icon.
/// * [switchCamera] stands in for the in-call flip-camera glyph, whose
///   inner arrows are a custom path.
///
/// Release builds tree-shake this font down to the code points referenced
/// by these constants.
@staticIconProvider
abstract final class KsIcons {
  static const String family = 'Lucide';
  static const String package = 'kinkstar_ui';

  static const IconData chevronLeft = IconData(
    57454,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData chevronRight = IconData(
    57455,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData ban = IconData(
    57425,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData check = IconData(
    57452,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData clock4 = IconData(
    57937,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData lock = IconData(
    57611,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData gem = IconData(
    57922,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData video = IconData(
    57765,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData camera = IconData(
    57444,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData phoneOff = IconData(
    57656,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData phone = IconData(
    57651,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData mic = IconData(
    57624,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData micOff = IconData(
    57625,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData shield = IconData(
    57688,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData bot = IconData(
    57787,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData info = IconData(
    57593,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData bell = IconData(
    57433,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData gift = IconData(
    57569,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData globe = IconData(
    57576,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData logOut = IconData(
    57614,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData trash2 = IconData(
    57742,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData plus = IconData(
    57661,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData messageSquare = IconData(
    57623,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData crown = IconData(
    57814,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData x = IconData(
    57778,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData creditCard = IconData(
    57514,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData zap = IconData(
    57780,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData calendar = IconData(
    57443,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData expand = IconData(
    57882,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData heart = IconData(
    57586,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData flag = IconData(
    57553,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData switchCamera = IconData(
    57724,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData star = IconData(
    57718,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData filter = IconData(
    57564,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData house = IconData(
    57589,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData radio = IconData(
    57666,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData user = IconData(
    57759,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData share2 = IconData(
    57686,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData ellipsisVertical = IconData(
    57527,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData search = IconData(
    57681,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData trophy = IconData(
    58227,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData users = IconData(
    57764,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData upload = IconData(
    57758,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData wifi = IconData(
    57774,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData image = IconData(
    57590,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData send = IconData(
    57682,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData sparkle = IconData(
    58494,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData wallet = IconData(
    57860,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData settings = IconData(
    57684,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData circleHelp = IconData(
    57474,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData chartLine = IconData(
    58021,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData eye = IconData(
    57530,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData smile = IconData(
    57700,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData landmark = IconData(
    57914,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData fileText = IconData(
    57548,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData pause = IconData(
    57646,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData idCard = IconData(
    58903,
    fontFamily: family,
    fontPackage: package,
  );
  static const IconData list = IconData(
    57606,
    fontFamily: family,
    fontPackage: package,
  );
}

/// Design icon size. `.ic` is 22×22; larger circles are tap targets, not glyphs.
class KsIcon extends StatelessWidget {
  const KsIcon(this.icon, {super.key, this.size = 22, this.color});

  final IconData icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }
}
