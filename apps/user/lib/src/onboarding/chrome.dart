import 'dart:math' as math;

// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

/// Pieces of the user onboarding chrome, matched to the design CSS.

class KsButton extends StatelessWidget {
  const KsButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.background = UserColors.primary,
    this.foreground = UserColors.white,
    this.borderColor,
    this.minHeight = UserSpace.buttonMin,
    this.textStyle,
    this.fullWidth = true,
  });

  final String label;
  final KsGlyph? icon;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final double minHeight;
  final TextStyle? textStyle;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final style = (textStyle ?? UserText.button).copyWith(color: foreground);
    final compact = minHeight == UserSpace.buttonSm;
    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(minHeight / 2),
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(color: borderColor!, width: 1.5),
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(minHeight / 2),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minHeight,
            minWidth: fullWidth && !compact ? double.infinity : 0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
              children: [
                if (icon != null) ...[
                  KsIcon(icon!, color: foreground),
                  const SizedBox(width: 8),
                ],
                Text(label, style: style),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KsIconButton extends StatelessWidget {
  const KsIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = UserSpace.iconButton,
    this.background = UserColors.surface2,
    this.color = UserColors.text,
  });

  final KsGlyph icon;
  final VoidCallback? onPressed;
  final double size;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: KsIcon(icon, color: color)),
        ),
      ),
    );
  }
}

class KsField extends StatelessWidget {
  const KsField({
    super.key,
    required this.label,
    this.value = '',
    this.placeholder = '',
    this.onTap,
    this.width,
    this.chevron = false,
  });

  final String label;
  final String value;
  final String placeholder;
  final VoidCallback? onTap;
  final double? width;
  final bool chevron;

  @override
  Widget build(BuildContext context) {
    final shown = value.isEmpty ? placeholder : value;
    final faded = value.isEmpty;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: UserText.label),
          const SizedBox(height: 6),
          Material(
            color: UserColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UserRadii.input),
              side: const BorderSide(color: UserColors.line, width: 1.5),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(UserRadii.input),
              child: SizedBox(
                height: UserSpace.buttonMin,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          shown,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: UserText.input.copyWith(
                            color: faded ? UserColors.muted : UserColors.text,
                          ),
                        ),
                      ),
                      if (chevron)
                        const KsIcon(
                          KsIcons.chevronDown,
                          color: UserColors.muted,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KsCheck extends StatelessWidget {
  const KsCheck({super.key, required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: on ? UserColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(UserRadii.xs),
        border: Border.all(
          color: on ? UserColors.primary : UserColors.line,
          width: 2,
        ),
      ),
    );
  }
}

class KsSwitch extends StatelessWidget {
  const KsSwitch({super.key, required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 28,
      decoration: BoxDecoration(
        color: on ? UserColors.primary : UserColors.line,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Align(
        alignment: on ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: UserColors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class KsChip extends StatelessWidget {
  const KsChip({
    super.key,
    required this.label,
    this.on = false,
    this.gold = false,
    this.icon,
  });

  final String label;
  final bool on;
  final bool gold;
  final KsGlyph? icon;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color border;
    final Color fg;
    if (gold) {
      bg = UserColors.chipGoldBg;
      border = UserColors.chipGoldBorder;
      fg = UserColors.gold;
    } else if (on) {
      bg = UserColors.primary;
      border = UserColors.primary;
      fg = UserColors.white;
    } else {
      bg = UserColors.surface2;
      border = UserColors.line;
      fg = UserColors.text;
    }
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(UserRadii.chip),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            KsIcon(icon!, color: fg),
            const SizedBox(width: 6),
          ],
          Text(label, style: UserText.chip.copyWith(color: fg)),
        ],
      ),
    );
  }
}

/// Hatched media stand-in from `.img`. A real photo replaces it when the
/// network image has loaded.
class KsMediaBox extends StatelessWidget {
  const KsMediaBox({
    super.key,
    required this.label,
    this.height,
    this.radius = UserRadii.chip,
    this.alignEnd = false,
    this.center = false,
    this.padding = const EdgeInsets.all(10),
    this.overlay,
  });

  final String label;
  final double? height;
  final double radius;
  final bool alignEnd;
  final bool center;
  final EdgeInsets padding;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: const _HatchPainter(),
          child:
              overlay ??
              Container(
                alignment: center
                    ? Alignment.center
                    : (alignEnd
                          ? Alignment.bottomCenter
                          : Alignment.bottomLeft),
                padding: padding,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: UserText.xs,
                ),
              ),
        ),
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  const _HatchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = UserColors.media);
    final paint = Paint()..color = UserColors.hatch;
    const period = UserHatch.periodPx;
    // CSS repeating-linear-gradient: 0deg points up, angles grow clockwise,
    // and the 0px stop sits half a gradient-line before the box center.
    final radians = UserHatch.angleDeg * math.pi / 180;
    final dx = math.sin(radians);
    final dy = -math.cos(radians);
    final length = size.width * dx.abs() + size.height * dy.abs();
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(math.atan2(dy, dx));
    final span = size.longestSide * 2;
    var x = -length / 2;
    while (x > -span) {
      x -= period;
    }
    for (; x < span; x += period) {
      canvas.drawRect(
        Rect.fromLTWH(x, -span, UserHatch.stripePx, span * 2),
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class KsTopBar extends StatelessWidget {
  const KsTopBar({super.key, this.leading, this.title, this.trailing});

  final Widget? leading;
  final String? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: UserSpace.topBarMin),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ?leading,
            if (leading != null && title != null) const SizedBox(width: 12),
            if (title != null)
              Expanded(child: Text(title!, style: UserText.title))
            else
              const Spacer(),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// Bottom navigation from `.tab`. The artboard prints "Home" on the first
/// tab. Config's discover label is "Discover", which is the page title.
class UserTabBar extends StatelessWidget {
  const UserTabBar({
    super.key,
    required this.tabs,
    this.selectedId = 'discover',
  });

  final List<ConfigTab> tabs;
  final String selectedId;

  static const _icons = {
    'discover': KsIcons.house,
    'match': KsIcons.expand,
    'live': KsIcons.radio,
    'messages': KsIcons.messageSquare,
    'me': KsIcons.user,
  };

  @override
  Widget build(BuildContext context) {
    final enabled = tabs.where((tab) => tab.enabled).toList();
    return Container(
      height: UserSpace.tabBar,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: UserColors.surface1,
        border: Border(top: BorderSide(color: UserColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final tab in enabled)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KsIcon(
                  _icons[tab.id] ?? KsIcons.circleHelp,
                  color: tab.id == selectedId
                      ? UserColors.primarySoft
                      : UserColors.muted,
                ),
                const SizedBox(height: 2),
                Text(
                  tab.id == 'discover' ? 'Home' : tab.label,
                  style: UserText.tab.copyWith(
                    color: tab.id == selectedId
                        ? UserColors.primarySoft
                        : UserColors.muted,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
