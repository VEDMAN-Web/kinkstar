// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

/// User-app palette, taken from the shared `<style>` block in
/// `design/source/user/*.dc.html` plus one-off colours in those files.
///
/// CSS variables (`:root`): bg, s1, s2, ln, tx, mu, pri, pri2, gold, ok, info.
/// `--pri2` (#FB7185) is a lighter crimson than `--pri` (#E11D48).
/// Letter-spacing is 0 except invite codes (`letter-spacing: 2px`).
/// Explicit line-heights are body 1.45 and h1 1.2. Other styles use the
/// font's own metrics (CSS `normal`).
abstract final class UserColors {
  static const Color bg = Color(0xFF0F0A14);
  static const Color surface1 = Color(0xFF1A1322);
  static const Color surface2 = Color(0xFF251B30);
  static const Color line = Color(0xFF3A2E47);
  static const Color text = Color(0xFFF7F2FA);
  static const Color muted = Color(0xFFBBAECB);
  static const Color primary = Color(0xFFE11D48);
  static const Color primarySoft = Color(0xFFFB7185);
  static const Color gold = Color(0xFFF5B83D);
  static const Color ok = Color(0xFF34D399);
  static const Color info = Color(0xFF93C5FD);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color goldInk = Color(0xFF241500);
  static const Color onlineInk = Color(0xFF052E1C);
  static const Color infoInk = Color(0xFF0B2545);
  static const Color avatar = Color(0xFF4B3A5C);
  static const Color media = Color(0xFF3B2D4A);
  static const Color mediaText = Color(0xFFE6DCEF);
  static const Color video = Color(0xFF2A1F35);
  static const Color pip = Color(0xFF4A3A58);
  static const Color noteBg = Color(0xFF1E2A3A);
  static const Color noteBorder = Color(0xFF2F4560);
  static const Color noteText = Color(0xFFCFE3FA);
  static const Color chipGoldBg = Color(0xFF3A2A08);
  static const Color chipGoldBorder = Color(0xFF6B4E10);
  static const Color packSelected = Color(0xFF2E2310);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerText = Color(0xFFFCA5A5);
  static const Color pkBlue = Color(0xFF2563EB);
  static const Color successSolid = Color(0xFF16A34A);
  static const Color aiAvatar = Color(0xFF1E3A5F);
  static const Color ledgerOk = Color(0xFF123826);
  static const Color coachBody = Color(0xFF4A4055);
  static const Color coachSkip = Color(0xFF6B5B7B);
  static const Color dotInactive = Color(0xFF666666);
  static const Color viewer = Color(0xFF000000);
  static const Color playCard = Color(0xFF202124);
  static const Color playMuted = Color(0xFF5F6368);
  static const Color playStar = Color(0xFF9AA0A6);

  static const Color splashStart = Color(0xFF3B0F24);
  static const Color offerStart = Color(0xFF4A1028);
  static const Color offerEnd = Color(0xFF2B1636);
  static const Color voiceTop = Color(0xFF22142E);
  static const Color levelTop = Color(0xFF2E2310);

  static const Color badgeScrim = Color(0x8C000000);
  static const Color dim = Color(0x99050208);
  static const Color dimStrong = Color(0xCC050208);
  static const Color dimQueue = Color(0xBF050208);
  static const Color glass = Color(0x8C0F0A14);
  static const Color sheet = Color(0xF51A1322);
  static const Color lowBalance = Color(0xD9DC2626);
  static const Color videoCaption = Color(0x59FFFFFF);
  static const Color pipBorder = Color(0x4DFFFFFF);
  static const Color hatch = Color(0x0AFFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color overlay40 = Color(0x66000000);
  static const Color overlay50 = Color(0x80000000);
  static const Color callPulseInner = Color(0x2EE11D48);
  static const Color callPulseOuter = Color(0x14E11D48);
  static const Color videoScrimTop = Color(0x330F0A14);
  static const Color videoScrimBottom = Color(0xEB0F0A14);

  /// Outside the phone frame. Not used by [UserTheme].
  static const Color canvasArtboard = Color(0xFFE7E3EC);
  static const Color canvasLabel = Color(0xFF2A2233);
  static const Color canvasBezel = Color(0xFF16121B);
}

abstract final class UserGradients {
  static const LinearGradient balanceCard = LinearGradient(
    colors: [UserColors.chipGoldBg, UserColors.surface1],
    transform: GradientRotation(0.5235987755982988),
  );
  static const LinearGradient vipCard = LinearGradient(
    colors: [UserColors.chipGoldBg, UserColors.voiceTop],
    transform: GradientRotation(0.7853981633974483),
  );
  static const LinearGradient voiceCall = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [UserColors.voiceTop, UserColors.bg],
  );
  static const LinearGradient levelCard = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [UserColors.levelTop, UserColors.surface1],
  );
  static const LinearGradient offer = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [UserColors.offerStart, UserColors.surface1],
  );
  static const LinearGradient rechargeBanner = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [UserColors.offerStart, UserColors.offerEnd],
  );
  static const LinearGradient videoScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [UserColors.videoScrimTop, UserColors.videoScrimBottom],
    stops: [0, 0.7],
  );
  static const RadialGradient splash = RadialGradient(
    center: Alignment(0, -0.2),
    radius: 0.85,
    colors: [UserColors.splashStart, UserColors.bg],
    stops: [0, 0.7],
  );
  static const RadialGradient calling = RadialGradient(
    center: Alignment(0, -0.3),
    radius: 0.85,
    colors: [UserColors.splashStart, UserColors.bg],
    stops: [0, 0.7],
  );
}

/// Media hatch: repeating-linear-gradient(135deg, white 4% 0 12px, transparent 12px 24px).
/// Flutter has no repeating gradient; these are the stripe metrics.
abstract final class UserHatch {
  static const double angleDeg = 135;
  static const double stripePx = 12;
  static const double periodPx = 24;
  static const Color color = UserColors.hatch;
}

abstract final class UserSpace {
  static const double s2 = 2;
  static const double s3 = 3;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double statusBar = 44;
  static const double topBarMin = 56;
  static const double tabBar = 72;
  static const double buttonMin = 52;
  static const double buttonSm = 44;
  static const double iconButton = 44;
  static const double frameWidth = 390;
  static const double frameHeight = 844;
}

abstract final class UserRadii {
  static const double hairline = 2;
  static const double progress = 4;
  static const double xs = 6;
  static const double tag = 8;
  static const double badge = 10;
  static const double switchThumb = 11;
  static const double note = 12;
  static const double input = 14;
  static const double chip = 16;
  static const double card = 18;
  static const double glass = 22;
  static const double avatar = 24;
  static const double pill = 26;
  static const double sheet = 28;
  static const double logo = 28;
  static const double avatarLarge = 44;
}

abstract final class UserShadows {
  static const List<BoxShadow> callPulse = [
    BoxShadow(color: UserColors.callPulseInner, spreadRadius: 12),
    BoxShadow(color: UserColors.callPulseOuter, spreadRadius: 26),
  ];
  static const List<BoxShadow> levelRing = [
    BoxShadow(color: UserColors.gold, spreadRadius: 3),
  ];
  static const List<BoxShadow> levelRingStrong = [
    BoxShadow(color: UserColors.gold, spreadRadius: 4),
  ];
  static const List<BoxShadow> canvasBezel = [
    BoxShadow(color: UserColors.canvasBezel, spreadRadius: 10),
  ];
}

abstract final class UserIconSize {
  static const double md = 22;
}

const String _pkg = 'kinkstar_ui';

/// Platform fonts for letters Inter does not contain. Not bundled.
const _scriptFallback = [
  'Noto Sans Devanagari',
  'Noto Sans Bengali',
  'Noto Sans Tamil',
  'Noto Sans Telugu',
  'Noto Sans Kannada',
  // U+2605 BLACK STAR, which the host profile line uses and Inter lacks.
  'Noto Sans Symbols2',
];

TextStyle _inter(
  double size,
  FontWeight weight, {
  double? height,
  double letterSpacing = 0,
  Color? color,
}) {
  return TextStyle(
    // Full family name, not `package:`. A package font skips script fallbacks
    // in widget tests, so Hindi and the other picker labels paint as boxes.
    fontFamily: 'packages/$_pkg/Inter',
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    fontFamilyFallback: _scriptFallback,
  );
}

TextStyle _poppins(
  double size,
  FontWeight weight, {
  double? height,
  double letterSpacing = 0,
  Color? color,
}) {
  return TextStyle(
    fontFamily: 'packages/$_pkg/Poppins',
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    fontFamilyFallback: _scriptFallback,
  );
}

abstract final class UserText {
  static final TextStyle body = _inter(
    15,
    FontWeight.w400,
    height: 1.45,
    color: UserColors.text,
  );
  static final TextStyle small = _inter(13, FontWeight.w400, color: UserColors.muted);
  static final TextStyle xs = _inter(12, FontWeight.w500, color: UserColors.mediaText);
  static final TextStyle chip = _inter(13, FontWeight.w500, color: UserColors.text);
  static final TextStyle label = _inter(13, FontWeight.w500, color: UserColors.muted);
  static final TextStyle button = _inter(16, FontWeight.w600, color: UserColors.white);
  static final TextStyle buttonSm = _inter(14, FontWeight.w600, color: UserColors.white);
  static final TextStyle input = _inter(16, FontWeight.w500, color: UserColors.text);
  static final TextStyle badge = _inter(11, FontWeight.w600, color: UserColors.white);
  static final TextStyle tab = _inter(11, FontWeight.w500, color: UserColors.muted);
  static final TextStyle glass = _inter(13, FontWeight.w500, color: UserColors.white);
  static final TextStyle caption = _inter(14, FontWeight.w500, color: UserColors.videoCaption);
  static final TextStyle tag = _inter(10, FontWeight.w700, color: UserColors.goldInk);
  static final TextStyle bubble = _inter(14, FontWeight.w400, color: UserColors.text);
  static final TextStyle title = _poppins(20, FontWeight.w600, color: UserColors.text);
  static final TextStyle h1 = _poppins(
    28,
    FontWeight.w700,
    height: 1.2,
    color: UserColors.text,
  );
  static final TextStyle h2 = _poppins(18, FontWeight.w600, color: UserColors.text);
  static final TextStyle avatar = _poppins(16, FontWeight.w600, color: UserColors.white);
  static final TextStyle avatarLarge = _poppins(28, FontWeight.w600, color: UserColors.white);
  static final TextStyle otp = _poppins(22, FontWeight.w600, color: UserColors.text);
  static final TextStyle balance = _poppins(26, FontWeight.w700, color: UserColors.text);
  static final TextStyle kpi = _poppins(22, FontWeight.w700, color: UserColors.text);
  static final TextStyle code = _poppins(
    22,
    FontWeight.w700,
    letterSpacing: 2,
    color: UserColors.text,
  );
  static final TextStyle display24 = _poppins(24, FontWeight.w700, color: UserColors.gold);
  static final TextStyle display36 = _poppins(36, FontWeight.w700, color: UserColors.gold);
  static final TextStyle display40 = _poppins(40, FontWeight.w400, color: UserColors.text);
  static final TextStyle display44 = _poppins(44, FontWeight.w600, color: UserColors.white);
  static final TextStyle display48 = _poppins(48, FontWeight.w700, color: UserColors.text);
}

abstract final class UserTheme {
  static ThemeData get data {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: UserColors.bg,
      canvasColor: UserColors.bg,
      dividerColor: UserColors.line,
      splashFactory: NoSplash.splashFactory,
      colorScheme: const ColorScheme.dark(
        primary: UserColors.primary,
        onPrimary: UserColors.white,
        secondary: UserColors.gold,
        onSecondary: UserColors.goldInk,
        surface: UserColors.surface1,
        onSurface: UserColors.text,
        onSurfaceVariant: UserColors.muted,
        error: UserColors.danger,
        onError: UserColors.white,
        outline: UserColors.line,
      ),
      iconTheme: const IconThemeData(size: UserIconSize.md, color: UserColors.text),
    );
    final text = base.textTheme
        .apply(
          fontFamily: 'Inter',
          package: _pkg,
          bodyColor: UserColors.text,
          displayColor: UserColors.text,
        )
        .copyWith(
          headlineLarge: UserText.h1,
          headlineMedium: UserText.h2,
          titleLarge: UserText.title,
          bodyMedium: UserText.body,
          bodySmall: UserText.small,
          labelLarge: UserText.button,
          labelMedium: UserText.chip,
        );
    return base.copyWith(
      textTheme: text,
      primaryTextTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: UserColors.bg,
        foregroundColor: UserColors.text,
        elevation: 0,
        titleTextStyle: UserText.title,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UserColors.primary,
          foregroundColor: UserColors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(UserSpace.buttonMin),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(UserRadii.pill)),
          ),
          textStyle: UserText.button,
        ),
      ),
    );
  }
}
