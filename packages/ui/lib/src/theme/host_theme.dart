// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

/// Host-app palette, from `design/source/host/*.dc.html`.
///
/// `--pri` and `--pri2` are both #6D28D9 (the user app's pri/pri2 differ).
/// `--gold` is #B45309 (amber-brown), not the user app's #F5B83D.
/// `.btn.g` is green #047857, not gold. The later `.badge.live` rule wins:
/// background #047857, text #fff (an earlier rule in the same sheet sets
/// text to #052E1C and is overridden).
/// `.vid` is declared twice with the same #2A1F35.
abstract final class HostColors {
  static const Color bg = Color(0xFFF7F5FB);
  static const Color surface1 = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF0ECF7);
  static const Color line = Color(0xFFE2DCEC);
  static const Color text = Color(0xFF1C1528);
  static const Color muted = Color(0xFF5E5470);
  static const Color primary = Color(0xFF6D28D9);
  static const Color primarySoft = Color(0xFF6D28D9);
  static const Color gold = Color(0xFFB45309);
  static const Color ok = Color(0xFF047857);
  static const Color info = Color(0xFF1D4ED8);

  static const Color white = Color(0xFFFFFFFF);
  static const Color buttonDark = Color(0xFF1C1528);
  static const Color buttonSuccess = Color(0xFF047857);
  static const Color chipGoldBg = Color(0xFFFEF3C7);
  static const Color chipGoldBorder = Color(0xFFF59E0B);
  static const Color chipGoldText = Color(0xFF92400E);
  static const Color avatar = Color(0xFF7C5BB5);
  static const Color media = Color(0xFFDCD3EA);
  static const Color mediaText = Color(0xFF3F3552);
  static const Color video = Color(0xFF2A1F35);
  static const Color pip = Color(0xFF4A3A58);
  static const Color infoBadge = Color(0xFF93C5FD);
  static const Color infoInk = Color(0xFF0B2545);
  static const Color noteBg = Color(0xFFEFF6FF);
  static const Color noteBorder = Color(0xFFBFDBFE);
  static const Color noteText = Color(0xFF1E3A8A);
  static const Color warnBg = Color(0xFFFFFBEB);
  static const Color warnBorder = Color(0xFFFCD34D);
  static const Color warnText = Color(0xFF78350F);
  static const Color badBg = Color(0xFFFEF2F2);
  static const Color badBorder = Color(0xFFFCA5A5);
  static const Color badText = Color(0xFF7F1D1D);
  static const Color packSelected = Color(0xFFEDE4FB);
  static const Color money = Color(0xFF047857);
  static const Color danger = Color(0xFFB91C1C);
  static const Color dangerSolid = Color(0xFFDC2626);
  static const Color successSolid = Color(0xFF16A34A);
  static const Color successBright = Color(0xFF22C55E);
  static const Color payoutAmount = Color(0xFF4ADE80);
  static const Color successDeep = Color(0xFF06210F);
  static const Color amber = Color(0xFFFBBF24);
  static const Color violetDeep = Color(0xFF4C1D95);
  static const Color chart = Color(0xFFC4B5FD);
  static const Color chartMuted = Color(0xFFD8CCEB);
  static const Color payoutCard = Color(0xFF1C1528);
  static const Color callTop = Color(0xFF2E1065);
  static const Color softViolet = Color(0xFFF3ECFF);
  static const Color successSoft = Color(0xFFECFDF5);
  static const Color plum = Color(0xFF5B4A6E);
  static const Color liveBadgeText = Color(0xFFFFFFFF);

  static const Color badgeScrim = Color(0x8C000000);
  static const Color dim = Color(0x80140C1E);
  static const Color glass = Color(0x8C0F0A14);
  static const Color videoCaption = Color(0x59FFFFFF);
  static const Color pipBorder = Color(0x4DFFFFFF);
  static const Color hatch = Color(0x59FFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white15 = Color(0x26FFFFFF);
  static const Color overlay40 = Color(0x66000000);
  static const Color overlay50 = Color(0x80000000);
  static const Color moneyScrim = Color(0xE6047857);
  static const Color amberScrim = Color(0xD9B45309);

  static const Color canvasArtboard = Color(0xFFE7E3EC);
  static const Color canvasLabel = Color(0xFF2A2233);
  static const Color canvasBezel = Color(0xFF2B2238);
}

abstract final class HostGradients {
  static const LinearGradient call = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [HostColors.callTop, HostColors.buttonDark],
  );
}

abstract final class HostHatch {
  static const double angleDeg = 135;
  static const double stripePx = 12;
  static const double periodPx = 24;
  static const Color color = HostColors.hatch;
}

abstract final class HostSpace {
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

abstract final class HostRadii {
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
  static const double avatarLarge = 44;
}

abstract final class HostShadows {
  static const List<BoxShadow> canvasBezel = [
    BoxShadow(color: HostColors.canvasBezel, spreadRadius: 10),
  ];
}

abstract final class HostIconSize {
  static const double md = 22;
}

const String _pkg = 'kinkstar_ui';

TextStyle _inter(
  double size,
  FontWeight weight, {
  double? height,
  double letterSpacing = 0,
  Color? color,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    package: _pkg,
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
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
    fontFamily: 'Poppins',
    package: _pkg,
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
  );
}

abstract final class HostText {
  static final TextStyle body = _inter(
    15,
    FontWeight.w400,
    height: 1.45,
    color: HostColors.text,
  );
  static final TextStyle small = _inter(13, FontWeight.w400, color: HostColors.muted);
  static final TextStyle xs = _inter(12, FontWeight.w500, color: HostColors.mediaText);
  static final TextStyle chip = _inter(13, FontWeight.w500, color: HostColors.text);
  static final TextStyle label = _inter(13, FontWeight.w500, color: HostColors.muted);
  static final TextStyle button = _inter(16, FontWeight.w600, color: HostColors.white);
  static final TextStyle buttonSm = _inter(14, FontWeight.w600, color: HostColors.white);
  static final TextStyle input = _inter(16, FontWeight.w500, color: HostColors.text);
  static final TextStyle badge = _inter(11, FontWeight.w600, color: HostColors.white);
  static final TextStyle tab = _inter(11, FontWeight.w500, color: HostColors.muted);
  static final TextStyle glass = _inter(13, FontWeight.w500, color: HostColors.white);
  static final TextStyle tag = _inter(10, FontWeight.w700, color: HostColors.white);
  static final TextStyle bubble = _inter(14, FontWeight.w400, color: HostColors.text);
  static final TextStyle title = _poppins(20, FontWeight.w600, color: HostColors.text);
  static final TextStyle h1 = _poppins(
    28,
    FontWeight.w700,
    height: 1.2,
    color: HostColors.text,
  );
  static final TextStyle h2 = _poppins(18, FontWeight.w600, color: HostColors.text);
  static final TextStyle avatar = _poppins(16, FontWeight.w600, color: HostColors.white);
  static final TextStyle avatarLarge = _poppins(28, FontWeight.w600, color: HostColors.white);
  static final TextStyle otp = _poppins(22, FontWeight.w600, color: HostColors.text);
  static final TextStyle kpi = _poppins(22, FontWeight.w700, color: HostColors.text);
  static final TextStyle code = _poppins(
    22,
    FontWeight.w700,
    letterSpacing: 2,
    color: HostColors.text,
  );
  static final TextStyle display24 = _poppins(24, FontWeight.w700, color: HostColors.text);
  static final TextStyle display26 = _poppins(26, FontWeight.w700, color: HostColors.text);
  static final TextStyle payout = _poppins(32, FontWeight.w700, color: HostColors.payoutAmount);
  static final TextStyle display40 = _poppins(40, FontWeight.w400, color: HostColors.text);
  static final TextStyle display44 = _poppins(44, FontWeight.w600, color: HostColors.white);
}

abstract final class HostTheme {
  static ThemeData get data {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: HostColors.bg,
      canvasColor: HostColors.bg,
      dividerColor: HostColors.line,
      splashFactory: NoSplash.splashFactory,
      colorScheme: const ColorScheme.light(
        primary: HostColors.primary,
        onPrimary: HostColors.white,
        secondary: HostColors.gold,
        onSecondary: HostColors.white,
        surface: HostColors.surface1,
        onSurface: HostColors.text,
        onSurfaceVariant: HostColors.muted,
        error: HostColors.danger,
        onError: HostColors.white,
        outline: HostColors.line,
      ),
      iconTheme: const IconThemeData(size: HostIconSize.md, color: HostColors.text),
    );
    final text = base.textTheme
        .apply(
          fontFamily: 'Inter',
          package: _pkg,
          bodyColor: HostColors.text,
          displayColor: HostColors.text,
        )
        .copyWith(
          headlineLarge: HostText.h1,
          headlineMedium: HostText.h2,
          titleLarge: HostText.title,
          bodyMedium: HostText.body,
          bodySmall: HostText.small,
          labelLarge: HostText.button,
          labelMedium: HostText.chip,
        );
    return base.copyWith(
      textTheme: text,
      primaryTextTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: HostColors.bg,
        foregroundColor: HostColors.text,
        elevation: 0,
        titleTextStyle: HostText.title,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HostColors.primary,
          foregroundColor: HostColors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(HostSpace.buttonMin),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(HostRadii.pill)),
          ),
          textStyle: HostText.button,
        ),
      ),
    );
  }
}
