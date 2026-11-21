import 'dart:math' as math;

// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import '../onboarding/chrome.dart';
import 'data.dart';

const _normal = 1.21;
const _body = 1.45;

/// U22. Me tab.
class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  MeData _data = MeData.fallback;

  @override
  void initState() {
    super.initState();
    loadMe().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return Material(
      color: UserColors.bg,
      child: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          const KsTopBar(
            title: 'Me',
            trailing: Padding(
              padding: EdgeInsets.only(left: 12),
              child: KsIconButton(icon: KsIcons.settings),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _RingAvatar(data.username.characters.first, ring: 3),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.username, style: UserText.title),
                            const SizedBox(height: 2),
                            Text.rich(
                              TextSpan(
                                style: UserText.xs.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: UserColors.muted,
                                  height: _body,
                                ),
                                children: const [
                                  TextSpan(text: 'ID 10482231 · '),
                                  TextSpan(
                                    text: 'Edit profile',
                                    style: TextStyle(
                                      color: UserColors.primarySoft,
                                      decoration: TextDecoration.underline,
                                      decorationColor: UserColors.primarySoft,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                _MiniChip('Lv ${data.level}', gold: true),
                                const SizedBox(width: 6),
                                _MiniChip(data.vip ? 'VIP' : 'Not VIP'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _DiamondCard(data.diamonds),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Expanded(
                        child: _Shortcut(KsIcons.crown, 'VIP', gold: true),
                      ),
                      SizedBox(width: 8),
                      Expanded(child: _Shortcut(KsIcons.calendar, 'Check-in')),
                      SizedBox(width: 8),
                      Expanded(child: _Shortcut(KsIcons.trophy, 'Events')),
                      SizedBox(width: 8),
                      Expanded(child: _Shortcut(KsIcons.share2, 'Invite')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _Menu(
                    KsIcons.star,
                    'My level',
                    trailing: 'Lv ${data.level} · ${data.percent}%',
                  ),
                  const _Menu(KsIcons.wallet, 'Wallet history'),
                  const _Menu(KsIcons.heart, 'Following', trailing: '6'),
                  const _Menu(KsIcons.ban, 'Blocked users'),
                  const _Menu(KsIcons.circleHelp, 'Help & feedback'),
                  const _Menu(KsIcons.star, 'Rate Kinkstar Calls'),
                ],
              ),
            ),
          ),
          const _TabBar(selected: 4),
        ],
      ),
    );
  }
}

/// U38. My level.
class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  MeData _data = MeData.fallback;

  @override
  void initState() {
    super.initState();
    loadMe().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return Material(
      color: UserColors.bg,
      child: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            leading: const KsIconButton(icon: KsIcons.chevronLeft),
            title: 'My level',
            trailing: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                'Rules',
                style: UserText.small.copyWith(
                  color: UserColors.primarySoft,
                  height: _body,
                  decoration: TextDecoration.underline,
                  decorationColor: UserColors.primarySoft,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: UserGradients.levelCard,
                      borderRadius: BorderRadius.circular(UserRadii.card),
                      border: Border.all(color: UserColors.line),
                    ),
                    child: Column(
                      children: [
                        _RingAvatar(data.username.characters.first, ring: 4),
                        const SizedBox(height: 8),
                        Text('Level ${data.level}', style: UserText.display24),
                        const SizedBox(height: 8),
                        _Progress(data.percent / 100),
                        const SizedBox(height: 8),
                        Text(
                          '${data.spent} / ${data.goal} Diamonds to Level ${data.nextLevel}',
                          style: UserText.xs.copyWith(
                            fontWeight: FontWeight.w400,
                            color: UserColors.muted,
                            height: _body,
                          ),
                        ),
                        const SizedBox(height: 8),
                        KsButton(
                          label: 'Level up now',
                          minHeight: UserSpace.buttonSm,
                          background: UserColors.gold,
                          foreground: UserColors.goldInk,
                          textStyle: UserText.buttonSm.copyWith(
                            height: _normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LEVEL PERKS',
                      style: UserText.xs.copyWith(
                        fontWeight: FontWeight.w400,
                        color: UserColors.muted,
                        height: _body,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _Perk('Lv 3', 'Silver avatar frame', '500'),
                  const _Perk('Lv 5', 'Entry effect in live rooms', '2,000'),
                  const _Perk(
                    'Lv 10',
                    'Exclusive gifts + 5% call discount',
                    '10,000',
                  ),
                  const _Perk(
                    'Lv 20',
                    'Gold frame + dedicated support',
                    '50,000',
                  ),
                  const _Perk(
                    'Lv 30',
                    'King badge + event invitations',
                    '2,00,000',
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

/// U39. Daily check-in.
class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: UserColors.bg,
      child: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          const KsTopBar(
            leading: KsIconButton(icon: KsIcons.chevronLeft),
            title: 'Daily check-in',
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _DayHero(),
                  SizedBox(height: 14),
                  _CheckGrid(),
                  SizedBox(height: 14),
                  KsButton(
                    label: 'Claim +15 Diamonds',
                    background: UserColors.gold,
                    foreground: UserColors.goldInk,
                    textStyle: UserText.button.copyWith(height: _normal),
                  ),
                  SizedBox(height: 14),
                  _Reminder(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// U40. Events and leaderboard.
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: UserColors.bg,
      child: Column(
        children: [
          SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            leading: KsIconButton(icon: KsIcons.chevronLeft),
            title: 'Diwali Festival',
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _Banner('[Event banner · server-driven]'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _Segments(
              labels: ['Top gifters', 'Top hosts', 'Rewards'],
              selected: 0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _Rank(1, 'V', 'Vikram_99', '84,200', gold: true),
                  _Rank(2, 'R', 'Raj_King', '61,050', gold: true),
                  _Rank(3, 'S', 'Sam', '40,900', gold: true),
                  _Rank(4, 'A', 'Amit', '22,100'),
                  _Rank(5, 'K', 'Karan', '18,750'),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: _YouCard(),
          ),
        ],
      ),
    );
  }
}

/// U41. Refer and earn.
class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: UserColors.bg,
      child: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          const KsTopBar(
            leading: KsIconButton(icon: KsIcons.chevronLeft),
            title: 'Invite friends',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: UserGradients.offer,
                      borderRadius: BorderRadius.circular(UserRadii.card),
                      border: Border.all(color: UserColors.line),
                    ),
                    child: Column(
                      children: [
                        const KsIcon(KsIcons.gift, color: UserColors.gold),
                        const SizedBox(height: 15),
                        Text(
                          'You both get 100 Diamonds',
                          textAlign: TextAlign.center,
                          style: UserText.h2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'When your friend makes their first recharge',
                          textAlign: TextAlign.center,
                          style: UserText.small.copyWith(height: _body),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: UserColors.surface1,
                      borderRadius: BorderRadius.circular(UserRadii.card),
                      border: Border.all(color: UserColors.line),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your code',
                                style: UserText.xs.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: UserColors.muted,
                                  height: _body,
                                ),
                              ),
                              Text('RAHUL482', style: UserText.code),
                            ],
                          ),
                        ),
                        KsButton(
                          label: 'Copy',
                          minHeight: UserSpace.buttonSm,
                          background: const Color(0x00000000),
                          foreground: UserColors.text,
                          borderColor: UserColors.line,
                          textStyle: UserText.buttonSm.copyWith(
                            height: _normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  KsButton(
                    label: 'Share on WhatsApp',
                    icon: KsIcons.share2,
                    textStyle: UserText.button.copyWith(height: _normal),
                  ),
                  const SizedBox(height: 14),
                  KsButton(
                    label: 'More ways to share',
                    background: const Color(0x00000000),
                    foreground: UserColors.text,
                    borderColor: UserColors.line,
                    textStyle: UserText.button.copyWith(height: _normal),
                  ),
                  const SizedBox(height: 14),
                  const _Stats(),
                  const SizedBox(height: 14),
                  Text(
                    'Max 20 rewarded invites per month. Fraudulent invites are removed.',
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
        ],
      ),
    );
  }
}

/// U43. AI companion profile. The badge stays labelled AI.
class AiProfileScreen extends StatefulWidget {
  const AiProfileScreen({super.key});

  @override
  State<AiProfileScreen> createState() => _AiProfileScreenState();
}

class _AiProfileScreenState extends State<AiProfileScreen> {
  MeData _data = MeData.fallback;

  @override
  void initState() {
    super.initState();
    loadMe().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return Material(
      color: UserColors.bg,
      child: Column(
        children: [
          CustomPaint(
            painter: const _HatchPainter(base: UserColors.aiAvatar),
            child: SizedBox(
              height: 420,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const KsIconButton(
                          icon: KsIcons.chevronLeft,
                          background: UserColors.overlay40,
                        ),
                        const Spacer(),
                        _AiBadge(data.ariaLabel),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.ariaName,
                          style: UserText.balance.copyWith(
                            color: UserColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'AI persona · ${data.ariaLanguages} · always available',
                          style: UserText.small.copyWith(
                            fontWeight: FontWeight.w500,
                            color: UserColors.mediaText,
                            height: _normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Note(
                    'Aria is an AI, not a real person. Conversations are generated by AI and moderated for safety.',
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _RateChip('${data.ariaVideo}/min video', gold: true),
                      // hosts.json voiceRatePerMin is 15. The artboard says 8.
                      const _RateChip('8/min voice'),
                      const _RateChip('Text free', icon: false),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Cheerful, loves movies and music, remembers what you told her last time.',
                    style: UserText.small.copyWith(
                      color: UserColors.text,
                      height: _body,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'MORE AI COMPANIONS',
                    style: UserText.xs.copyWith(
                      fontWeight: FontWeight.w400,
                      color: UserColors.muted,
                      height: _body,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      _Companion('M', 'Maya'),
                      SizedBox(width: 10),
                      _Companion('Z', 'Zoya'),
                      SizedBox(width: 10),
                      _Companion('T', 'Tara'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: KsButton(
                    label: 'Chat',
                    icon: KsIcons.messageSquare,
                    background: const Color(0x00000000),
                    foreground: UserColors.text,
                    borderColor: UserColors.line,
                    textStyle: UserText.button.copyWith(height: _normal),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 7,
                  child: KsButton(
                    label: 'AI video call',
                    icon: KsIcons.video,
                    textStyle: UserText.button.copyWith(height: _normal),
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

class _RingAvatar extends StatelessWidget {
  const _RingAvatar(this.letter, {required this.ring});

  final String letter;
  final double ring;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: UserColors.avatar,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: UserColors.gold, spreadRadius: ring)],
      ),
      child: Text(letter, style: UserText.avatarLarge),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip(this.label, {this.gold = false, this.height = 24});

  final String label;
  final bool gold;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: gold ? UserColors.chipGoldBg : UserColors.surface2,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(
          color: gold ? UserColors.chipGoldBorder : UserColors.line,
        ),
      ),
      child: Text(
        label,
        style: UserText.chip.copyWith(
          color: gold ? UserColors.gold : UserColors.text,
          height: _normal,
        ),
      ),
    );
  }
}

class _DiamondCard extends StatelessWidget {
  const _DiamondCard(this.diamonds);

  final int diamonds;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: UserGradients.balanceCard,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.chipGoldBorder),
      ),
      child: Row(
        children: [
          const KsIcon(KsIcons.gem, color: UserColors.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diamonds',
                  style: UserText.xs.copyWith(
                    fontWeight: FontWeight.w400,
                    color: UserColors.muted,
                    height: _body,
                  ),
                ),
                Text('$diamonds', style: UserText.kpi),
              ],
            ),
          ),
          KsButton(
            label: 'Recharge',
            minHeight: UserSpace.buttonSm,
            background: UserColors.gold,
            foreground: UserColors.goldInk,
            textStyle: UserText.buttonSm.copyWith(height: _normal),
          ),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut(this.icon, this.label, {this.gold = false});

  final KsGlyph icon;
  final String label;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KsIconButton(
          icon: icon,
          color: gold ? UserColors.gold : UserColors.text,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: UserText.xs.copyWith(
            fontWeight: FontWeight.w400,
            color: UserColors.text,
            height: _body,
          ),
        ),
      ],
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu(this.icon, this.label, {this.trailing});

  final KsGlyph icon;
  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: UserColors.line)),
      ),
      child: Row(
        children: [
          KsIcon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: UserText.body)),
          if (trailing != null)
            Text(
              trailing!,
              style: UserText.xs.copyWith(
                fontWeight: FontWeight.w400,
                color: UserColors.muted,
                height: _body,
              ),
            ),
        ],
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  const _Perk(this.level, this.label, this.cost);

  final String level;
  final String label;
  final String cost;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: UserColors.line)),
      ),
      child: Row(
        children: [
          _MiniChip(level, gold: true, height: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: UserText.small.copyWith(
                color: UserColors.text,
                height: _body,
              ),
            ),
          ),
          Text(
            cost,
            style: UserText.xs.copyWith(
              fontWeight: FontWeight.w400,
              color: UserColors.muted,
              height: _body,
            ),
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress(this.value);

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UserRadii.progress),
      child: SizedBox(
        height: 8,
        width: double.infinity,
        child: Stack(
          children: [
            const ColoredBox(
              color: UserColors.surface2,
              child: SizedBox.expand(),
            ),
            FractionallySizedBox(
              widthFactor: value,
              child: const ColoredBox(color: UserColors.gold),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayHero extends StatelessWidget {
  const _DayHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 17, 14, 14),
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.line),
      ),
      child: Column(
        children: [
          Text('Day 3', style: UserText.display36),
          const SizedBox(height: 4),
          Text(
            'Come back every day. Miss a day and the streak restarts.',
            textAlign: TextAlign.center,
            style: UserText.small.copyWith(height: _body),
          ),
        ],
      ),
    );
  }
}

class _CheckGrid extends StatelessWidget {
  const _CheckGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cell = (constraints.maxWidth - 24) / 4;
        final wide = cell * 2 + 8;
        final days = [
          const _Day(1, '+5', done: true),
          const _Day(2, '+10', done: true),
          const _Day(3, '+15', today: true),
          const _Day(4, '+15'),
          const _Day(5, '+20'),
          const _Day(6, '+20'),
          const _Day(7, '+50 + free gift', gift: true),
        ];
        return Column(
          children: [
            Row(
              children: [
                for (var i = 0; i < 4; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  SizedBox(width: cell, child: days[i]),
                ],
              ],
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                SizedBox(width: cell, child: days[4]),
                const SizedBox(width: 8),
                SizedBox(width: cell, child: days[5]),
                const SizedBox(width: 8),
                SizedBox(width: wide, child: days[6]),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Day extends StatelessWidget {
  const _Day(
    this.day,
    this.reward, {
    this.done = false,
    this.today = false,
    this.gift = false,
  });

  final int day;
  final String reward;
  final bool done;
  final bool today;
  final bool gift;

  @override
  Widget build(BuildContext context) {
    final icon = done
        ? const KsIcon(KsIcons.check, color: UserColors.ok)
        : KsIcon(
            gift ? KsIcons.gift : KsIcons.gem,
            color: today ? UserColors.gold : UserColors.text,
          );
    return Opacity(
      opacity: done ? 0.6 : 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: today ? UserColors.packSelected : UserColors.surface2,
              borderRadius: BorderRadius.circular(UserRadii.chip),
              border: Border.all(
                color: today ? UserColors.gold : UserColors.line,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Day $day',
                  style: UserText.xs.copyWith(
                    fontWeight: FontWeight.w400,
                    color: UserColors.text,
                    height: _body,
                  ),
                ),
                const SizedBox(height: 4),
                icon,
                const SizedBox(height: 4),
                Text(
                  reward,
                  textAlign: TextAlign.center,
                  style: UserText.xs.copyWith(
                    fontWeight: FontWeight.w400,
                    color: UserColors.gold,
                    height: _body,
                  ),
                ),
              ],
            ),
          ),
          if (today)
            const Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(child: _Tag('TODAY')),
            ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.gold,
        borderRadius: BorderRadius.circular(UserRadii.tag),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(label, style: UserText.tag.copyWith(height: _normal)),
      ),
    );
  }
}

class _Reminder extends StatelessWidget {
  const _Reminder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.line),
      ),
      child: Row(
        children: [
          const KsIcon(KsIcons.bell),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Remind me daily at 9 pm',
              style: UserText.small.copyWith(
                color: UserColors.text,
                height: _body,
              ),
            ),
          ),
          const KsSwitch(on: true),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UserRadii.chip),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: CustomPaint(
          painter: const _HatchPainter(),
          child: Center(
            child: Text(label, style: UserText.xs.copyWith(height: _normal)),
          ),
        ),
      ),
    );
  }
}

class _Rank extends StatelessWidget {
  const _Rank(
    this.place,
    this.letter,
    this.name,
    this.amount, {
    this.gold = false,
  });

  final int place;
  final String letter;
  final String name;
  final String amount;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final color = gold ? UserColors.gold : UserColors.text;
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: UserColors.line)),
      ),
      child: Row(
        children: [
          _Fixed(24, '$place', color),
          const SizedBox(width: 12),
          _Letter(letter),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: UserText.body)),
          KsIcon(KsIcons.gem, color: color),
          Text(
            ' $amount',
            style: UserText.body.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Letter extends StatelessWidget {
  const _Letter(this.letter, {this.color = UserColors.avatar});

  final String letter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(letter, style: UserText.avatar),
    );
  }
}

class _YouCard extends StatelessWidget {
  const _YouCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.primary),
      ),
      child: Row(
        children: [
          const _Fixed(24, '412', UserColors.text),
          const SizedBox(width: 12),
          const _Letter('R'),
          const SizedBox(width: 12),
          Expanded(child: Text('You', style: UserText.body)),
          KsButton(
            label: 'Send gifts',
            minHeight: UserSpace.buttonSm,
            textStyle: UserText.buttonSm.copyWith(height: _normal),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.line),
      ),
      child: const Row(
        children: [
          Expanded(child: _Stat('4', 'Invited')),
          SizedBox(width: 10),
          Expanded(child: _Stat('1', 'Recharged')),
          SizedBox(width: 10),
          Expanded(child: _Stat('100', 'Earned', gold: true)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label, {this.gold = false});

  final String value;
  final String label;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: UserText.body.copyWith(
            fontWeight: FontWeight.w700,
            color: gold ? UserColors.gold : UserColors.text,
          ),
        ),
        Text(
          label,
          style: UserText.xs.copyWith(
            fontWeight: FontWeight.w400,
            color: UserColors.muted,
            height: _body,
          ),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: UserColors.noteBg,
        borderRadius: BorderRadius.circular(UserRadii.note),
        border: Border.all(color: UserColors.noteBorder),
      ),
      child: Text(
        text,
        style: UserText.small.copyWith(
          color: UserColors.noteText,
          height: _body,
        ),
      ),
    );
  }
}

class _RateChip extends StatelessWidget {
  const _RateChip(this.label, {this.gold = false, this.icon = true});

  final String label;
  final bool gold;
  final bool icon;

  @override
  Widget build(BuildContext context) {
    final fg = gold ? UserColors.gold : UserColors.text;
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: gold ? UserColors.chipGoldBg : UserColors.surface2,
        borderRadius: BorderRadius.circular(UserRadii.chip),
        border: Border.all(
          color: gold ? UserColors.chipGoldBorder : UserColors.line,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon) ...[
            KsIcon(KsIcons.gem, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: UserText.chip.copyWith(color: fg, height: _normal),
          ),
        ],
      ),
    );
  }
}

class _Companion extends StatelessWidget {
  const _Companion(this.letter, this.name);

  final String letter;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Letter(letter, color: UserColors.aiAvatar),
        const SizedBox(height: 4),
        Text(
          name,
          style: UserText.xs.copyWith(
            fontWeight: FontWeight.w400,
            color: UserColors.text,
            height: _body,
          ),
        ),
      ],
    );
  }
}

class _AiBadge extends StatelessWidget {
  const _AiBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.info,
        borderRadius: BorderRadius.circular(UserRadii.badge),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const KsIcon(KsIcons.bot, color: UserColors.infoInk),
            const SizedBox(width: 4),
            Text(
              label,
              style: UserText.badge.copyWith(
                color: UserColors.infoInk,
                height: _normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segments extends StatelessWidget {
  const _Segments({required this.labels, required this.selected});

  final List<String> labels;
  final int selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: UserColors.surface2,
        borderRadius: BorderRadius.circular(UserRadii.glass),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: i == selected
                      ? UserColors.primary
                      : const Color(0x00000000),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: UserText.chip.copyWith(
                      color: i == selected
                          ? UserColors.white
                          : UserColors.muted,
                      height: _normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
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

class _Fixed extends StatelessWidget {
  const _Fixed(this.width, this.text, this.color);

  final double width;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: width),
      child: Text(
        text,
        softWrap: false,
        style: UserText.body.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  const _HatchPainter({this.base = UserColors.media});

  final Color base;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);
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
