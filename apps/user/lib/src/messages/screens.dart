// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import '../onboarding/chrome.dart';
import 'data.dart';

/// CSS `font:` with no line-height resets to the font's normal metric.
const _normal = 1.21;

/// Size-only rules inherit `.ph`'s 1.45 line-height.
const _body = 1.45;

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  MessagesData _data = MessagesData.fallback;

  @override
  void initState() {
    super.initState();
    loadMessages().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserColors.bg,
      body: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            title: 'Messages',
            trailing: const KsIconButton(icon: KsIcons.ellipsisVertical),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _Segments(
              labels: ['Chats', 'Calls', 'Following'],
              selected: 0,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Thread(
                  avatar: const _Avatar(
                    color: UserColors.primary,
                    child: KsIcon(KsIcons.star, color: UserColors.white),
                  ),
                  title: const Row(
                    children: [
                      Text('Kinkstar Team', style: _name),
                      SizedBox(width: 12),
                      _Badge('Official', background: UserColors.surface2),
                    ],
                  ),
                  preview: 'Your free call is ready. Tap to start.',
                  trailing: Text('now', style: _time),
                ),
                _Thread(
                  avatar: _Avatar(
                    online: true,
                    child: Text(_data.priya[0], style: UserText.avatar),
                  ),
                  title: Text(_data.priya, style: _name),
                  preview: 'Thanks for the rose! Call me later?',
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('9:42 pm', style: _time),
                      SizedBox(height: 4),
                      _Badge('2', background: UserColors.primary),
                    ],
                  ),
                ),
                _Thread(
                  avatar: _Avatar(
                    online: true,
                    child: Text('A', style: UserText.avatar),
                  ),
                  title: Text('Anjali', style: _name),
                  preview: '[Gift] Chocolate x1',
                  trailing: Text('9:10 pm', style: _time),
                ),
                _Thread(
                  avatar: _Avatar(
                    color: UserColors.aiAvatar,
                    child: const KsIcon(KsIcons.bot, color: UserColors.white),
                  ),
                  title: Row(
                    children: [
                      Text(_data.aria, style: _name),
                      const SizedBox(width: 12),
                      const _Badge(
                        'AI',
                        background: UserColors.info,
                        color: UserColors.infoInk,
                      ),
                    ],
                  ),
                  preview: 'Good evening! How was your day?',
                  trailing: Text('8:01 pm', style: _time),
                ),
                _Thread(
                  avatar: _Avatar(child: Text('N', style: UserText.avatar)),
                  title: Text('Neha', style: _name),
                  preview: 'You: Hi Neha',
                  trailing: Text('Yesterday', style: _time),
                ),
                _Thread(
                  avatar: _Avatar(child: Text('S', style: UserText.avatar)),
                  title: Text('Sana', style: _name),
                  preview: '[Missed call] 2 min ago',
                  trailing: Text('Mon', style: _time),
                ),
              ],
            ),
          ),
          const _TabBar(selected: 3),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  MessagesData _data = MessagesData.fallback;

  @override
  void initState() {
    super.initState();
    loadMessages().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserColors.bg,
      body: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          _ChatTop(name: _data.priya),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 1, 16, 12),
            child: _Note(
              'For your safety, never share phone numbers, UPI IDs or money outside the app.',
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Center(child: Text('Today 9:30 pm', style: _time)),
                const SizedBox(height: 8),
                const _Bubble('Hi Priya! Loved your intro clip', mine: true),
                const SizedBox(height: 8),
                const _Bubble(
                  'Hi! Thank you. Where are you from?',
                  mine: false,
                ),
                const SizedBox(height: 8),
                const _Bubble('Delhi. Want to video call?', mine: true),
                const SizedBox(height: 8),
                const Center(child: _GiftNote()),
                const SizedBox(height: 8),
                const _Bubble(
                  'Thanks for the rose! Call me later?',
                  mine: false,
                ),
                const SizedBox(height: 8),
                _FreeLine(left: _data.freeLeft, price: _data.priceAfter),
              ],
            ),
          ),
          const _Composer(),
        ],
      ),
    );
  }
}

class ChatGiftScreen extends StatefulWidget {
  const ChatGiftScreen({super.key});

  @override
  State<ChatGiftScreen> createState() => _ChatGiftScreenState();
}

class _ChatGiftScreenState extends State<ChatGiftScreen> {
  MessagesData _data = MessagesData.fallback;

  @override
  void initState() {
    super.initState();
    loadMessages().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserColors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: UserSpace.statusBar),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const KsIconButton(icon: KsIcons.chevronLeft),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_data.priya, style: _name)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _Bubble('Thanks for the rose!', mine: false),
                ),
              ),
            ],
          ),
          const Positioned.fill(child: ColoredBox(color: UserColors.dim)),
          Align(
            alignment: Alignment.bottomCenter,
            child: _GiftSheet(data: _data),
          ),
        ],
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserColors.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            leading: const KsIconButton(icon: KsIcons.chevronLeft),
            title: 'Notifications',
            trailing: Text(
              'Read all',
              style: UserText.small.copyWith(
                color: UserColors.primarySoft,
                height: _body,
                decoration: TextDecoration.underline,
                decorationColor: UserColors.primarySoft,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('TODAY', style: _time),
                ),
                _Notice(
                  background: UserColors.ledgerOk,
                  color: UserColors.ok,
                  icon: KsIcons.video,
                  title: 'Priya is online now',
                  detail: 'You follow her · tap to call',
                  time: '2m',
                ),
                _Notice(
                  background: UserColors.chipGoldBg,
                  color: UserColors.gold,
                  icon: KsIcons.gem,
                  title: 'Daily reward ready',
                  detail: 'Day 3 streak · +15 Diamonds',
                  time: '1h',
                ),
                _Notice(
                  icon: KsIcons.trophy,
                  title: 'You reached Level 3',
                  detail: 'New avatar frame unlocked',
                  time: '5h',
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 6),
                  child: Text('EARLIER', style: _time),
                ),
                _Notice(
                  color: UserColors.primarySoft,
                  icon: KsIcons.gift,
                  title: 'Diwali gift festival starts',
                  detail: 'Limited gifts · 3 days',
                  time: '2d',
                ),
                _Notice(
                  icon: KsIcons.shield,
                  title: 'Report update',
                  detail: 'Action taken on your report #4821',
                  time: '3d',
                ),
                _Notice(
                  icon: KsIcons.wallet,
                  title: 'Recharge successful',
                  detail: '+1,200 Diamonds · ₹249',
                  time: '4d',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _name = TextStyle(
  fontFamily: 'packages/kinkstar_ui/Inter',
  fontSize: 15,
  fontWeight: FontWeight.w700,
  height: _body,
  color: UserColors.text,
);

final _time = UserText.xs.copyWith(
  fontWeight: FontWeight.w400,
  color: UserColors.muted,
  height: _body,
);

final _preview = UserText.small.copyWith(height: _body);

class _Thread extends StatelessWidget {
  const _Thread({
    required this.avatar,
    required this.title,
    required this.preview,
    required this.trailing,
  });

  final Widget avatar;
  final Widget title;
  final String preview;
  final Widget trailing;

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
          avatar,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                Text(preview, style: _preview),
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.child,
    this.color = UserColors.avatar,
    this.online = false,
    this.size = 48,
  });

  final Widget child;
  final Color color;
  final bool online;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(size / 2),
            ),
            child: SizedBox(
              width: size,
              height: size,
              child: Center(child: child),
            ),
          ),
          if (online)
            const Positioned(
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: UserColors.ok,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(color: UserColors.bg, width: 2),
                  ),
                ),
                child: SizedBox(width: 12, height: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.label, {
    required this.background,
    this.color = UserColors.white,
  });

  final String label;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(UserRadii.badge),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          label,
          style: UserText.badge.copyWith(color: color, height: _normal),
        ),
      ),
    );
  }
}

class _Segments extends StatelessWidget {
  const _Segments({required this.labels, required this.selected, this.width});

  final List<String> labels;
  final int selected;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final row = Container(
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
    if (width == null) return row;
    return SizedBox(width: width, child: row);
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
            _TabItem(
              icon: _items[i].$1,
              label: _items[i].$2,
              on: i == selected,
            ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.icon, required this.label, required this.on});

  final KsGlyph icon;
  final String label;
  final bool on;

  @override
  Widget build(BuildContext context) {
    final color = on ? UserColors.primarySoft : UserColors.muted;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 56, minHeight: 44),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KsIcon(icon, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: UserText.tab.copyWith(color: color, height: _normal),
          ),
        ],
      ),
    );
  }
}

class _ChatTop extends StatelessWidget {
  const _ChatTop({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: UserSpace.topBarMin),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const KsIconButton(icon: KsIcons.chevronLeft),
            const SizedBox(width: 12),
            _Avatar(
              size: 40,
              online: true,
              child: Text(name.isEmpty ? 'P' : name[0], style: UserText.avatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: _name),
                  Text(
                    'Online · replies in ~2 min',
                    style: _time.copyWith(color: UserColors.ok),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const KsIconButton(icon: KsIcons.phone),
            const SizedBox(width: 12),
            const KsIconButton(
              icon: KsIcons.video,
              background: UserColors.primary,
              color: UserColors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.noteBg,
        borderRadius: BorderRadius.circular(UserRadii.note),
        border: Border.all(color: UserColors.noteBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Text(
          text,
          style: UserText.small.copyWith(
            color: UserColors.noteText,
            height: _body,
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.text, {required this.mine});

  final String text;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 272),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: mine ? UserColors.primary : UserColors.surface2,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(mine ? 18 : 6),
              bottomRight: Radius.circular(mine ? 6 : 18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              text,
              style: UserText.bubble.copyWith(
                color: mine ? UserColors.white : UserColors.text,
                height: _body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GiftNote extends StatelessWidget {
  const _GiftNote();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.line),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: SizedBox(
          height: 30,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              KsIcon(KsIcons.gift, color: UserColors.gold),
              SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: 'packages/kinkstar_ui/Inter',
                    fontSize: 13,
                    height: _body,
                    color: UserColors.text,
                  ),
                  children: [
                    TextSpan(text: 'You sent '),
                    TextSpan(
                      text: 'Rose x1',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FreeLine extends StatelessWidget {
  const _FreeLine({required this.left, required this.price});

  final int left;
  final int price;

  @override
  Widget build(BuildContext context) {
    final style = UserText.small.copyWith(
      color: UserColors.text,
      height: _body,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 25),
                child: Row(
                  children: [
                    Text(
                      '$left free messages left · then $price',
                      style: style,
                    ),
                    const SizedBox(width: 4),
                    const KsIcon(KsIcons.gem, color: UserColors.text),
                    Text(' each', style: style),
                  ],
                ),
              ),
            ),
            Text(
              'Why?',
              style: style.copyWith(
                color: UserColors.gold,
                decoration: TextDecoration.underline,
                decorationColor: UserColors.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 28),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: UserColors.line)),
      ),
      child: const Row(
        children: [
          KsIconButton(icon: KsIcons.image),
          SizedBox(width: 8),
          Expanded(child: _MessageField()),
          SizedBox(width: 8),
          KsIconButton(icon: KsIcons.gift, color: UserColors.gold),
          SizedBox(width: 8),
          KsIconButton(
            icon: KsIcons.send,
            background: UserColors.primary,
            color: UserColors.white,
          ),
        ],
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
  const _MessageField();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.surface2,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: UserColors.line, width: 1.5),
      ),
      child: const SizedBox(
        height: 44,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Type a message',
              style: TextStyle(
                fontFamily: 'packages/kinkstar_ui/Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: _normal,
                color: UserColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GiftSheet extends StatelessWidget {
  const _GiftSheet({required this.data});

  final MessagesData data;

  List<_Gift> get _gifts => [
    _Gift(
      data.giftName('gift_rose', 'Rose'),
      '${data.giftPrice('gift_rose', 10)}',
      KsIcons.heart,
      UserColors.primarySoft,
      selected: true,
    ),
    _Gift(
      data.giftName('gift_star', 'Star'),
      '${data.giftPrice('gift_star', 30)}',
      KsIcons.star,
      UserColors.gold,
    ),
    // These five are on the artboard and not in gifts.json.
    const _Gift('Chocolate', '50', KsIcons.gift, UserColors.text),
    _Gift(
      data.giftName('gift_crown', 'Crown'),
      '${data.giftPrice('gift_crown', 500)}',
      KsIcons.crown,
      UserColors.gold,
      tag: 'HOT',
    ),
    const _Gift('Kiss', '99', KsIcons.sparkle, UserColors.text),
    const _Gift('Fireworks', '199', KsIcons.zap, UserColors.text),
    const _Gift('Diamond ring', '999', KsIcons.gem, UserColors.text),
    const _Gift(
      'Daily heart',
      '0 (1 left)',
      KsIcons.heart,
      UserColors.text,
      tag: 'FREE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UserRadii.sheet),
        ),
        border: Border(top: BorderSide(color: UserColors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: UserColors.line,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: SizedBox(width: 40, height: 4),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: Text('Send a gift', style: UserText.h2)),
              _DiamondChip(data.diamonds),
            ],
          ),
          const SizedBox(height: 14),
          const _Segments(
            labels: ['Popular', 'Luxury', 'Interactive', 'VIP'],
            selected: 0,
          ),
          const SizedBox(height: 14),
          for (var row = 0; row < 2; row++) ...[
            if (row > 0) const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var col = 0; col < 4; col++) ...[
                  if (col > 0) const SizedBox(width: 8),
                  Expanded(child: _gifts[row * 4 + col]),
                ],
              ],
            ),
          ],
          const SizedBox(height: 13),
          Row(
            children: [
              const _Segments(
                labels: ['x1', 'x10', 'x99'],
                selected: 1,
                width: 125,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      KsButton(
                        label: 'Top up',
                        minHeight: UserSpace.buttonSm,
                        background: UserColors.gold,
                        foreground: UserColors.goldInk,
                        textStyle: UserText.buttonSm,
                      ),
                      const SizedBox(width: 12),
                      KsButton(
                        label: 'Send · 100',
                        minHeight: UserSpace.buttonSm,
                        textStyle: UserText.buttonSm,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Gift extends StatelessWidget {
  const _Gift(
    this.name,
    this.price,
    this.icon,
    this.color, {
    this.tag,
    this.selected = false,
  });

  final String name;
  final String price;
  final KsGlyph icon;
  final Color color;
  final String? tag;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          decoration: BoxDecoration(
            color: selected ? UserColors.packSelected : UserColors.surface2,
            borderRadius: BorderRadius.circular(UserRadii.chip),
            border: Border.all(
              color: selected ? UserColors.gold : UserColors.line,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              KsIcon(icon, color: color),
              const SizedBox(height: 4),
              Text(
                name,
                textAlign: TextAlign.center,
                style: UserText.xs.copyWith(
                  fontWeight: FontWeight.w400,
                  color: UserColors.text,
                  height: _body,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                price,
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
        if (tag != null)
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: UserColors.gold,
                  borderRadius: BorderRadius.circular(UserRadii.tag),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Text(
                    tag!,
                    style: UserText.tag.copyWith(height: _normal),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DiamondChip extends StatelessWidget {
  const _DiamondChip(this.diamonds);

  final int diamonds;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.chipGoldBg,
        borderRadius: BorderRadius.circular(UserRadii.chip),
        border: Border.all(color: UserColors.chipGoldBorder),
      ),
      child: SizedBox(
        height: 32,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const KsIcon(KsIcons.gem, color: UserColors.gold),
              const SizedBox(width: 6),
              Text(
                '$diamonds',
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

class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.title,
    required this.detail,
    required this.time,
    this.background = UserColors.surface2,
    this.color = UserColors.text,
  });

  final KsGlyph icon;
  final String title;
  final String detail;
  final String time;
  final Color background;
  final Color color;

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
          KsIconButton(icon: icon, background: background, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: UserText.small.copyWith(
                    fontWeight: FontWeight.w700,
                    color: UserColors.text,
                    height: _body,
                  ),
                ),
                Text(detail, style: _time),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(time, style: _time),
        ],
      ),
    );
  }
}
