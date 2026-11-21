import 'dart:math' as math;

// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import '../onboarding/chrome.dart';
import 'data.dart';

const _normal = 1.21;
const _body = 1.45;

/// U15. Quick Match, idle.
class QuickMatchScreen extends StatefulWidget {
  const QuickMatchScreen({super.key});

  @override
  State<QuickMatchScreen> createState() => _QuickMatchScreenState();
}

class _QuickMatchScreenState extends State<QuickMatchScreen> {
  MatchData _data = MatchData.fallback;

  @override
  void initState() {
    super.initState();
    loadMatch().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chips = [..._data.languages, 'Any'];
    return ColoredBox(
      color: UserColors.bg,
      child: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            title: 'Quick Match',
            trailing: _GoldChip('${_data.diamonds}'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                children: [
                  const _Orbit(),
                  const SizedBox(height: 18),
                  Text(
                    '218 hosts online now',
                    textAlign: TextAlign.center,
                    style: UserText.h2,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Connect instantly with a random available host who speaks your language.',
                    textAlign: TextAlign.center,
                    style: UserText.small.copyWith(height: _body),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < chips.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        _LangChip(chips[i], on: i == 0),
                      ],
                    ],
                  ),
                  const SizedBox(height: 18),
                  _FreeCard(_data.freeLeft, _data.freeTotal),
                  const SizedBox(height: 18),
                  KsButton(
                    label: 'Start matching',
                    textStyle: UserText.button.copyWith(height: _normal),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "After free matches: 10 Diamonds per match + host's per-minute rate",
                    textAlign: TextAlign.center,
                    style: UserText.xs.copyWith(
                      fontWeight: FontWeight.w400,
                      color: UserColors.muted,
                      height: _body,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _TabBar(selected: 1),
        ],
      ),
    );
  }
}

/// U16. Match found.
class MatchFoundScreen extends StatelessWidget {
  const MatchFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: UserColors.bg,
      child: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            leading: const KsIconButton(icon: KsIcons.chevronLeft),
            title: 'Match found',
            trailing: const _Glass('Auto-skip in 8s'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const _MatchCard(),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Action(
                        icon: KsIcons.x,
                        label: 'Next',
                        muted: true,
                        size: 64,
                      ),
                      const SizedBox(width: 28),
                      _Action(
                        icon: KsIcons.video,
                        label: 'Call now',
                        size: 80,
                        background: UserColors.primary,
                      ),
                      const SizedBox(width: 28),
                      _Action(
                        icon: KsIcons.heart,
                        label: 'Follow',
                        muted: true,
                        size: 64,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orbit extends StatelessWidget {
  const _Orbit();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size(260, 260), painter: _DashedCirclePainter()),
          DecoratedBox(
            decoration: BoxDecoration(
              color: UserColors.primary,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 120,
              height: 120,
              child: Center(
                child: KsIcon(KsIcons.expand, color: UserColors.white),
              ),
            ),
          ),
          Positioned(top: -10, left: 100, child: _Letter('P')),
          Positioned(bottom: 20, left: -10, child: _Letter('A')),
          Positioned(bottom: 10, right: -6, child: _Letter('N')),
        ],
      ),
    );
  }
}

class _Letter extends StatelessWidget {
  const _Letter(this.letter);

  final String letter;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: UserColors.avatar,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(child: Text(letter, style: UserText.avatar)),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = UserColors.line;
    const dash = 7.0;
    const gap = 5.0;
    final radius = size.width / 2 - 1;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );
    final sweep = dash / radius;
    final skip = (dash + gap) / radius;
    var angle = -math.pi / 2;
    final end = angle + math.pi * 2;
    while (angle < end) {
      canvas.drawArc(rect, angle, sweep, false, paint);
      angle += skip;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoldChip extends StatelessWidget {
  const _GoldChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.chipGoldBg,
        borderRadius: BorderRadius.circular(UserRadii.chip),
        border: Border.all(color: UserColors.chipGoldBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 32,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const KsIcon(KsIcons.gem, color: UserColors.gold),
              const SizedBox(width: 6),
              Text(
                label,
                style: UserText.chip.copyWith(
                  color: UserColors.gold,
                  height: _normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip(this.label, {required this.on, this.pad = 12});

  final String label;
  final bool on;
  final double pad;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: on ? UserColors.primary : UserColors.surface2,
        borderRadius: BorderRadius.circular(UserRadii.chip),
        border: Border.all(color: on ? UserColors.primary : UserColors.line),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: pad),
        child: SizedBox(
          height: 32,
          child: Center(
            child: Text(
              label,
              style: UserText.chip.copyWith(
                color: on ? UserColors.white : UserColors.text,
                height: _normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FreeCard extends StatelessWidget {
  const _FreeCard(this.left, this.total);

  final int left;
  final int total;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Free matches today',
                style: UserText.small.copyWith(
                  color: UserColors.text,
                  height: _body,
                ),
              ),
            ),
            Text(
              '$left of $total left',
              style: UserText.body.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UserRadii.chip),
      child: SizedBox(
        height: 520,
        width: double.infinity,
        child: CustomPaint(
          painter: const _HatchPainter(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const _Badge('● Online', live: true),
                    const SizedBox(width: 6),
                    const _Badge('Verified', icon: KsIcons.shield),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Riya, 22',
                  style: UserText.balance.copyWith(color: UserColors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Jaipur · Hindi · ★ 4.7',
                  style: UserText.small.copyWith(
                    color: UserColors.mediaText,
                    height: _body,
                  ),
                ),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: _Badge('40/min', icon: KsIcons.gem),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.label, {
    this.icon,
    this.live = false,
    this.primary = false,
  });

  final String label;
  final KsGlyph? icon;
  final bool live;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    if (live) {
      bg = UserColors.ok;
      fg = UserColors.onlineInk;
    } else if (primary) {
      bg = UserColors.primary;
      fg = UserColors.white;
    } else {
      bg = UserColors.badgeScrim;
      fg = UserColors.white;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(UserRadii.badge),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              KsIcon(icon!, color: fg),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: UserText.badge.copyWith(color: fg, height: _normal),
            ),
          ],
        ),
      ),
    );
  }
}

class _Glass extends StatelessWidget {
  const _Glass(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.glass,
        borderRadius: BorderRadius.circular(UserRadii.glass),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(label, style: UserText.glass.copyWith(height: _normal)),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.size,
    this.muted = false,
    this.background = UserColors.surface2,
  });

  final KsGlyph icon;
  final String label;
  final double size;
  final bool muted;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KsIconButton(icon: icon, size: size, background: background),
        const SizedBox(height: 4),
        Text(
          label,
          style: UserText.xs.copyWith(
            fontWeight: FontWeight.w400,
            color: muted ? UserColors.muted : UserColors.text,
            height: _body,
          ),
        ),
      ],
    );
  }
}

/// U17. Live rooms. V2.
class LiveRoomsScreen extends StatelessWidget {
  const LiveRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: UserColors.bg,
      child: Column(
        children: [
          SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            title: 'Live',
            trailing: KsIconButton(icon: KsIcons.search),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                _LangChip('Popular', on: true, pad: 13),
                SizedBox(width: 8),
                _LangChip('PK Battles', on: false, pad: 13),
                SizedBox(width: 8),
                _LangChip('New', on: false, pad: 13),
                SizedBox(width: 8),
                _LangChip('Following', on: false, pad: 13),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: _Festival(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _Room(
                          badge: 'LIVE',
                          viewers: '1.2k',
                          title: 'Sana · Songs night',
                          detail: 'Hindi',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _Room(
                          badge: 'PK',
                          viewers: '860',
                          title: 'Kavya vs Ishita',
                          detail: '02:41 left',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _Room(
                          badge: 'LIVE',
                          viewers: '430',
                          title: 'Meera · Chill chat',
                          detail: 'Tamil',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _Room(
                          badge: 'LIVE',
                          viewers: '390',
                          title: 'Pooja · Dance',
                          detail: 'Hindi',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _TabBar(selected: 2),
        ],
      ),
    );
  }
}

class _Festival extends StatelessWidget {
  const _Festival();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.line),
      ),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: UserColors.chipGoldBg,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Center(
                  child: KsIcon(KsIcons.trophy, color: UserColors.gold),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diwali Gift Festival',
                    style: TextStyle(
                      fontFamily: 'packages/kinkstar_ui/Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: _body,
                      color: UserColors.text,
                    ),
                  ),
                  Text(
                    'Top gifters win VIP for 30 days · 2d left',
                    style: TextStyle(
                      fontFamily: 'packages/kinkstar_ui/Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: _body,
                      color: UserColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            KsIcon(KsIcons.chevronRight, color: UserColors.text),
          ],
        ),
      ),
    );
  }
}

class _Room extends StatelessWidget {
  const _Room({
    required this.badge,
    required this.viewers,
    required this.title,
    required this.detail,
  });

  final String badge;
  final String viewers;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UserRadii.chip),
      child: SizedBox(
        height: 220,
        child: CustomPaint(
          painter: const _HatchPainter(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _Badge(badge, primary: true),
                    const Spacer(),
                    _Badge(viewers, icon: KsIcons.users),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: UserText.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: UserColors.white,
                        height: 1.05,
                      ),
                    ),
                    Text(
                      detail,
                      style: UserText.xs.copyWith(
                        fontWeight: FontWeight.w400,
                        color: UserColors.mediaText,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// U18. Live room with a PK battle. V2.
class LiveRoomScreen extends StatelessWidget {
  const LiveRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: UserColors.video,
      child: Stack(
        children: [
          Positioned(
            top: UserSpace.frameHeight * 0.46,
            left: 0,
            right: 0,
            child: Text(
              'Live video (host camera)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'packages/kinkstar_ui/Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: _normal,
                color: UserColors.videoCaption,
              ),
            ),
          ),
          Positioned(top: 52, left: 16, right: 16, child: _HostBar()),
          Positioned(top: 112, left: 16, right: 16, child: _PkBar()),
          Positioned(bottom: 150, left: 16, right: 16, child: _ChatStack()),
          Positioned(bottom: 36, left: 16, right: 16, child: _LiveComposer()),
        ],
      ),
    );
  }
}

class _HostBar extends StatelessWidget {
  const _HostBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _HostGlass(),
        SizedBox(width: 10),
        _FollowButton(),
        Spacer(),
        KsIconButton(icon: KsIcons.x, background: UserColors.overlay40),
      ],
    );
  }
}

class _HostGlass extends StatelessWidget {
  const _HostGlass();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.glass,
        borderRadius: BorderRadius.circular(UserRadii.glass),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
        child: Row(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                color: UserColors.avatar,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 36,
                height: 36,
                child: Center(child: Text('K', style: UserText.avatar)),
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kavya',
                  style: TextStyle(
                    fontFamily: 'packages/kinkstar_ui/Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: _normal,
                    color: UserColors.white,
                  ),
                ),
                Row(
                  children: [
                    KsIcon(KsIcons.users, size: 14, color: UserColors.white),
                    SizedBox(width: 4),
                    Text(
                      '860',
                      style: TextStyle(
                        fontFamily: 'packages/kinkstar_ui/Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: _normal,
                        color: UserColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SizedBox(
          height: 36,
          child: Center(
            child: Text(
              'Follow',
              style: UserText.buttonSm.copyWith(height: _normal),
            ),
          ),
        ),
      ),
    );
  }
}

class _PkBar extends StatelessWidget {
  const _PkBar();

  @override
  Widget build(BuildContext context) {
    const score = TextStyle(
      fontFamily: 'packages/kinkstar_ui/Inter',
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: _normal,
      color: UserColors.text,
    );
    return const Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          child: SizedBox(
            height: 28,
            child: Row(
              children: [
                Expanded(
                  flex: 62,
                  child: ColoredBox(
                    color: UserColors.primary,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Kavya 18,420', style: score),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 38,
                  child: ColoredBox(
                    color: UserColors.pkBlue,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('11,300 Ishita', style: score),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 6),
        _Glass('PK ends in 02:41'),
      ],
    );
  }
}

class _ChatStack extends StatelessWidget {
  const _ChatStack();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChatLine(name: 'Lv18 Vikram', gold: true, rest: ' sent Rose x10'),
        SizedBox(height: 6),
        _ChatLine(name: 'Amit', rest: ': Sing one more song!'),
        SizedBox(height: 6),
        _ChatLine(
          name: 'Lv25 Raj',
          gold: true,
          rest: ' sent Crown x1 · +5,000',
        ),
      ],
    );
  }
}

class _ChatLine extends StatelessWidget {
  const _ChatLine({required this.name, required this.rest, this.gold = false});

  final String name;
  final String rest;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final base = UserText.glass.copyWith(height: _normal);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.glass,
        borderRadius: BorderRadius.circular(UserRadii.glass),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text.rich(
          TextSpan(
            style: base,
            children: [
              TextSpan(
                text: name,
                style: base.copyWith(
                  fontWeight: FontWeight.w700,
                  color: gold ? UserColors.gold : UserColors.white,
                ),
              ),
              TextSpan(text: rest),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiveComposer extends StatelessWidget {
  const _LiveComposer();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: UserColors.glass,
              borderRadius: BorderRadius.all(Radius.circular(UserRadii.glass)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                'Say something…',
                style: TextStyle(
                  fontFamily: 'packages/kinkstar_ui/Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: _normal,
                  color: UserColors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        _RoundButton(KsIcons.gift, UserColors.gold, UserColors.goldInk),
        SizedBox(width: 10),
        _RoundButton(KsIcons.video, UserColors.primary, UserColors.white),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton(this.icon, this.background, this.color);

  final KsGlyph icon;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: SizedBox(
        width: 52,
        height: 52,
        child: Center(child: KsIcon(icon, color: color)),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.selected});

  final int selected;

  static const _items = [
    (KsIcons.house, 'Home'),
    (KsIcons.expand, 'Match'),
    (KsIcons.radio, 'Live'),
    (KsIcons.messageSquare, 'Messages'),
    (KsIcons.user, 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
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
          for (var i = 0; i < _items.length; i++)
            SizedBox(
              width: 56,
              height: 44,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KsIcon(
                    _items[i].$1,
                    color: i == selected
                        ? UserColors.primarySoft
                        : UserColors.muted,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _items[i].$2,
                    style: UserText.tab.copyWith(
                      color: i == selected
                          ? UserColors.primarySoft
                          : UserColors.muted,
                      height: _normal,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// `.img` hatch. CSS 135deg points down and to the right; the stripe phase
/// starts on the box, not on a rotated centre line.
class _HatchPainter extends CustomPainter {
  const _HatchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = UserColors.media);
    final paint = Paint()..color = UserColors.hatch;
    const period = UserHatch.periodPx;
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
