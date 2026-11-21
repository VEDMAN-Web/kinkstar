// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import '../onboarding/chrome.dart';
import 'data.dart';

/// Artboard copy that `wallet.json` and `ledger.json` do not contain, or that
/// contradicts them. Listed in the group PR.
const _offerLeft = '23:41:10';
const _credited = 1200;
const _creditedBase = 600;
const _creditedBonus = 600;
const _storePacks = [
  _PackData(60, '+60 bonus', 29),
  _PackData(220, '+220 bonus', 99),
  _PackData(600, '+600 bonus', 249, tag: 'MOST POPULAR', selected: true),
  _PackData(1300, '+10%', 499),
  _PackData(2800, '+15%', 999, tag: 'BEST VALUE'),
  _PackData(6000, '+20%', 1999),
];

class _PackData {
  const _PackData(
    this.diamonds,
    this.bonus,
    this.price, {
    this.tag,
    this.selected = false,
  });

  final int diamonds;
  final String bonus;
  final int price;
  final String? tag;
  final bool selected;
}

class _OfferPack {
  const _OfferPack(
    this.diamonds,
    this.payFor,
    this.price, {
    this.tag,
    this.selected = false,
  });

  final int diamonds;
  final int payFor;
  final int price;
  final String? tag;
  final bool selected;
}

class DiamondStoreScreen extends StatelessWidget {
  const DiamondStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WalletStage(
      builder: (data) {
        final diamonds = data?.diamonds ?? 120;
        final minutes = data?.callMinutes ?? 3;
        final month = data?.plans
            .where((plan) => plan.duration == '1 month')
            .firstOrNull;
        return Column(
          children: [
            const SizedBox(height: UserSpace.statusBar),
            KsTopBar(
              leading: const KsIconButton(icon: KsIcons.chevronLeft),
              title: 'Diamonds',
              trailing: Text(
                'History',
                style: UserText.small.copyWith(color: UserColors.primarySoft),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                children: [
                  _BalanceCard(diamonds: diamonds, minutes: minutes),
                  const SizedBox(height: 14),
                  const _OfferBanner(),
                  const SizedBox(height: 14),
                  const _PackGrid(_storePacks),
                  const SizedBox(height: 14),
                  _VipRow(price: month?.priceINR ?? 399),
                  const SizedBox(height: 14),
                  Text.rich(
                    TextSpan(
                      style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
                      children: const [
                        TextSpan(
                          text: 'Prices include GST. Diamonds never expire. ',
                        ),
                        TextSpan(
                          text: 'Refund policy',
                          style: TextStyle(color: UserColors.primarySoft),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: KsButton(
                label: 'Buy 1,200 Diamonds · ₹249',
                background: UserColors.gold,
                foreground: UserColors.goldInk,
              ),
            ),
          ],
        );
      },
    );
  }
}

class PayMethodScreen extends StatelessWidget {
  const PayMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WalletStage(
      builder: (data) {
        final pay = data?.payLabel ?? 'Google Play';
        return Stack(
          children: [
            const Positioned.fill(child: KsMediaBox(label: '', radius: 0)),
            const Positioned.fill(child: ColoredBox(color: UserColors.dim)),
            Align(
              alignment: Alignment.bottomCenter,
              child: _Sheet(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Choose how to pay', style: UserText.h2),
                      ),
                      const KsIconButton(icon: KsIcons.x),
                    ],
                  ),
                  _Card(
                    child: Row(
                      children: [
                        const KsIcon(KsIcons.gem, color: UserColors.gold),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            '1,200 Diamonds',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: UserColors.text,
                            ),
                          ),
                        ),
                        Text(
                          '₹249',
                          style: UserText.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Card(
                    border: UserColors.gold,
                    child: Row(
                      children: [
                        const KsIconButton(
                          icon: KsIcons.creditCard,
                          background: UserColors.white,
                          color: UserColors.surface1,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pay,
                                style: UserText.small.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: UserColors.text,
                                ),
                              ),
                              Text(
                                'Cards, UPI, Play balance',
                                style: UserText.xs.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: UserColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const KsCheck(on: true),
                      ],
                    ),
                  ),
                  const _Card(
                    child: Row(
                      children: [
                        KsIconButton(
                          icon: KsIcons.zap,
                          background: UserColors.white,
                          color: UserColors.surface1,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UPI via Razorpay',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: UserColors.text,
                                ),
                              ),
                              Text(
                                "Google's alternative billing (India) · PhonePe, GPay, Paytm",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: UserColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        KsCheck(on: false),
                      ],
                    ),
                  ),
                  Text(
                    'Both options credit Diamonds instantly. Payment is processed securely by the provider you choose.',
                    style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
                  ),
                  const KsButton(
                    label: 'Continue · ₹249',
                    background: UserColors.gold,
                    foreground: UserColors.goldInk,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class RechargeSuccessScreen extends StatelessWidget {
  const RechargeSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WalletStage(
      builder: (data) {
        final balance = (data?.diamonds ?? 120) + _credited;
        final level = data?.level ?? 2;
        final next = data?.nextLevel ?? 3;
        final name = data?.priyaName ?? 'Priya';
        return Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: UserColors.dimStrong),
            ),
            Positioned(
              top: 180,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                decoration: BoxDecoration(
                  color: UserColors.surface1,
                  borderRadius: BorderRadius.circular(UserRadii.sheet),
                  border: Border.all(color: UserColors.chipGoldBorder),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: UserColors.chipGoldBg,
                        shape: BoxShape.circle,
                      ),
                      child: const KsIcon(KsIcons.gem, color: UserColors.gold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '+${grouped(_credited)}',
                      style: UserText.h1.copyWith(color: UserColors.gold),
                    ),
                    const SizedBox(height: 12),
                    Text('Recharge successful', style: UserText.h2),
                    const SizedBox(height: 12),
                    Text(
                      '$_creditedBase Diamonds + $_creditedBonus first-recharge bonus',
                      textAlign: TextAlign.center,
                      style: UserText.small,
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('New balance', style: UserText.small),
                          ),
                          Text(
                            grouped(balance),
                            style: UserText.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: UserColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Level progress',
                              style: UserText.small.copyWith(
                                color: UserColors.text,
                              ),
                            ),
                          ),
                          Text(
                            'Lv $level → $next',
                            style: UserText.xs.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    KsButton(label: 'Call $name now', icon: KsIcons.video),
                    const SizedBox(height: 12),
                    Text('Back to Discover', style: UserText.small),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FirstOfferScreen extends StatelessWidget {
  const FirstOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: UserColors.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, UserSpace.statusBar, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: KsMediaBox(label: 'Host', height: 236)),
                  SizedBox(width: 12),
                  Expanded(child: KsMediaBox(label: 'Host', height: 236)),
                ],
              ),
            ),
          ),
          Positioned.fill(child: ColoredBox(color: UserColors.dimQueue)),
          Positioned(top: 150, left: 20, right: 20, child: _OfferDialog()),
        ],
      ),
    );
  }
}

class _OfferDialog extends StatelessWidget {
  const _OfferDialog();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [UserColors.offerStart, UserColors.surface1],
        ),
        borderRadius: BorderRadius.circular(UserRadii.sheet),
        border: Border.all(color: UserColors.primary),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: KsIconButton(icon: KsIcons.x),
          ),
          const _Pill('NEW USER OFFER'),
          const SizedBox(height: 12),
          Text(
            'Double Diamonds\non your first recharge',
            textAlign: TextAlign.center,
            style: UserText.h1,
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: UserText.small,
              children: [
                const TextSpan(text: 'Valid once · ends in '),
                TextSpan(
                  text: _offerLeft,
                  style: UserText.small.copyWith(
                    fontWeight: FontWeight.w700,
                    color: UserColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              _OfferTile(_OfferPack(220, 110, 49)),
              SizedBox(width: 12),
              _OfferTile(
                _OfferPack(1200, 600, 249, tag: 'POPULAR', selected: true),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const KsButton(
            label: 'Claim offer',
            background: UserColors.gold,
            foreground: UserColors.goldInk,
          ),
          const SizedBox(height: 12),
          Text(
            'Bonus Diamonds are credited instantly and never expire.',
            textAlign: TextAlign.center,
            style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class VipScreen extends StatelessWidget {
  const VipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WalletStage(
      builder: (data) {
        final plans =
            data?.plans ??
            const [
              WalletPlan(duration: '1 week', priceINR: 129),
              WalletPlan(duration: '1 month', priceINR: 399),
              WalletPlan(duration: '3 months', priceINR: 999),
            ];
        final month = plans
            .where((plan) => plan.duration == '1 month')
            .firstOrNull;
        return Column(
          children: [
            const SizedBox(height: UserSpace.statusBar),
            const KsTopBar(
              leading: KsIconButton(icon: KsIcons.chevronLeft),
              title: 'Kinkstar VIP',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const _VipHero(),
                  const SizedBox(height: 14),
                  const _Perk('15% off every call minute'),
                  const _Perk('30 free Diamonds every day'),
                  const _Perk('Priority in Quick Match and queues'),
                  const _Perk('Unlimited free messages'),
                  const _Perk('VIP badge, entry effect, exclusive gifts'),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      for (var i = 0; i < plans.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        _PlanTile(
                          plans[i],
                          selected: plans[i].duration == '1 month',
                          tag: plans[i].duration == '1 month'
                              ? 'SAVE 30%'
                              : null,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Auto-renews until cancelled. Renewal price shown before you pay.',
                    style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: KsButton(
                label: 'Start VIP · ₹${month?.priceINR ?? 399}/month',
                background: UserColors.gold,
                foreground: UserColors.goldInk,
              ),
            ),
          ],
        );
      },
    );
  }
}

class WalletHistoryScreen extends StatelessWidget {
  const WalletHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WalletStage(
      builder: (data) {
        final priya = data?.priyaName ?? 'Priya';
        final aria = data?.ariaName ?? 'Aria';
        return Column(
          children: [
            const SizedBox(height: UserSpace.statusBar),
            const KsTopBar(
              leading: KsIconButton(icon: KsIcons.chevronLeft),
              title: 'Wallet history',
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _Segments(['Spending', 'Recharges', 'VIP']),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _LedgerRow(
                    leading: _Letter(priya),
                    title: 'Video call · $priya',
                    subtitle: 'Today 9:51 pm · 8:42',
                    amount: '−349',
                  ),
                  const _LedgerRow(
                    leading: _Letter('P'),
                    title: 'Gift · Rose x10',
                    subtitle: 'Today 9:44 pm',
                    amount: '−100',
                  ),
                  const _LedgerRow(
                    leading: _Letter('A'),
                    title: 'Messages · Anjali',
                    subtitle: 'Today 9:10 pm · 4 msgs',
                    amount: '−20',
                  ),
                  const _LedgerRow(
                    leading: KsIconButton(
                      icon: KsIcons.calendar,
                      color: UserColors.gold,
                    ),
                    title: 'Daily check-in',
                    subtitle: 'Today 8:00 pm',
                    amount: '+15',
                    positive: true,
                  ),
                  _LedgerRow(
                    leading: const _Letter(
                      '',
                      icon: KsIcons.bot,
                      background: UserColors.aiAvatar,
                    ),
                    title: 'AI call · $aria',
                    subtitle: 'Yesterday · 6:10',
                    amount: '−93',
                  ),
                  const _LedgerRow(
                    leading: KsIconButton(icon: KsIcons.expand),
                    title: 'Quick Match',
                    subtitle: 'Yesterday',
                    amount: '−10',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Need help with a charge? Report a problem',
                      style: UserText.small.copyWith(
                        color: UserColors.primarySoft,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WalletStage extends StatefulWidget {
  const _WalletStage({required this.builder});

  final Widget Function(WalletData? data) builder;

  @override
  State<_WalletStage> createState() => _WalletStageState();
}

class _WalletStageState extends State<_WalletStage> {
  WalletData? _data;

  @override
  void initState() {
    super.initState();
    loadWallet().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserColors.bg,
      body: widget.builder(_data),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.diamonds, required this.minutes});

  final int diamonds;
  final int minutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.chipGoldBorder),
        gradient: const LinearGradient(
          begin: Alignment(-0.866, -0.5),
          end: Alignment(0.866, 0.5),
          colors: [UserColors.chipGoldBg, UserColors.surface1],
        ),
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
                  'Your balance',
                  style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  '$diamonds',
                  style: UserText.h1.copyWith(fontSize: 26, height: 1.1),
                ),
              ],
            ),
          ),
          Text(
            '≈ $minutes min of calls',
            style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class _OfferBanner extends StatelessWidget {
  const _OfferBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.primary),
      ),
      child: Row(
        children: [
          const _Pill('NEW USER'),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: UserText.small.copyWith(color: UserColors.text),
                children: const [
                  TextSpan(text: 'First recharge: '),
                  TextSpan(
                    text: '+100% Diamonds',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          Text(
            _offerLeft,
            style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class _PackGrid extends StatelessWidget {
  const _PackGrid(this.packs);

  final List<_PackData> packs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < packs.length; row += 3) ...[
          if (row > 0) const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(child: _StoreTile(packs[row + i])),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _StoreTile extends StatelessWidget {
  const _StoreTile(this.pack);

  final _PackData pack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: pack.selected
                ? UserColors.packSelected
                : UserColors.surface2,
            borderRadius: BorderRadius.circular(UserRadii.chip),
            border: Border.all(
              color: pack.selected ? UserColors.gold : UserColors.line,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              _GemLine(grouped(pack.diamonds), bold: true),
              const SizedBox(height: 4),
              Text(
                pack.bonus,
                style: UserText.xs.copyWith(color: UserColors.ok),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${grouped(pack.price)}',
                style: UserText.small.copyWith(color: UserColors.text),
              ),
            ],
          ),
        ),
        if (pack.tag != null)
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Center(child: _Tag(pack.tag!)),
          ),
      ],
    );
  }
}

class _VipRow extends StatelessWidget {
  const _VipRow({required this.price});

  final int price;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          const KsIcon(KsIcons.crown, color: UserColors.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VIP: calls 15% cheaper',
                  style: UserText.small.copyWith(
                    fontWeight: FontWeight.w700,
                    color: UserColors.text,
                  ),
                ),
                Text(
                  '+ 30 Diamonds daily · ₹$price/month',
                  style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          KsButton(
            label: 'View',
            minHeight: UserSpace.buttonSm,
            textStyle: UserText.buttonSm,
            background: UserColors.gold,
            foreground: UserColors.goldInk,
          ),
        ],
      ),
    );
  }
}

class _OfferTile extends StatelessWidget {
  const _OfferTile(this.pack);

  final _OfferPack pack;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: pack.selected
                  ? UserColors.packSelected
                  : UserColors.surface2,
              borderRadius: BorderRadius.circular(UserRadii.chip),
              border: Border.all(
                color: pack.selected ? UserColors.gold : UserColors.line,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                _GemLine(grouped(pack.diamonds), bold: true),
                const SizedBox(height: 4),
                Text(
                  'pay for ${grouped(pack.payFor)}',
                  style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${pack.price}',
                  style: UserText.small.copyWith(
                    fontWeight: FontWeight.w700,
                    color: UserColors.text,
                  ),
                ),
              ],
            ),
          ),
          if (pack.tag != null)
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(child: _Tag(pack.tag!)),
            ),
        ],
      ),
    );
  }
}

class _VipHero extends StatelessWidget {
  const _VipHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: UserColors.chipGoldBorder),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [UserColors.chipGoldBg, UserColors.voiceTop],
        ),
      ),
      child: Column(
        children: [
          const KsIcon(KsIcons.crown, color: UserColors.gold),
          const SizedBox(height: 6),
          Text(
            'VIP Gold',
            style: UserText.h2.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: UserColors.gold,
            ),
          ),
          const SizedBox(height: 6),
          Text('Cancel anytime in Google Play', style: UserText.small),
        ],
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  const _Perk(this.label);

  final String label;

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
          const KsIcon(KsIcons.check, color: UserColors.ok),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: UserText.small.copyWith(color: UserColors.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile(this.plan, {required this.selected, this.tag});

  final WalletPlan plan;
  final bool selected;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
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
                Text(
                  plan.duration,
                  style: UserText.body.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${plan.priceINR}',
                  style: UserText.small.copyWith(color: UserColors.text),
                ),
              ],
            ),
          ),
          if (tag != null)
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(child: _Tag(tag!)),
            ),
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.positive = false,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final String amount;
  final bool positive;

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
          leading,
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
                  ),
                ),
                Text(
                  subtitle,
                  style: UserText.xs.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: UserText.body.copyWith(
              fontWeight: FontWeight.w700,
              color: positive ? UserColors.ok : UserColors.primarySoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _Letter extends StatelessWidget {
  const _Letter(this.name, {this.icon, this.background = UserColors.avatar});

  final String name;
  final KsGlyph? icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final letter = name.isEmpty ? '' : name.characters.first;
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: icon != null
          ? KsIcon(icon!, color: UserColors.white)
          : Text(letter, style: UserText.avatar),
    );
  }
}

class _Segments extends StatelessWidget {
  const _Segments(this.labels);

  final List<String> labels;

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
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == 0 ? UserColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  labels[i],
                  style: UserText.chip.copyWith(
                    color: i == 0 ? UserColors.white : UserColors.muted,
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

class _Sheet extends StatelessWidget {
  const _Sheet({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.border = UserColors.line});

  final Widget child;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }
}

class _GemLine extends StatelessWidget {
  const _GemLine(this.text, {this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const KsIcon(KsIcons.gem, color: UserColors.text),
        const SizedBox(width: 4),
        Text(
          text,
          style: UserText.small.copyWith(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: UserColors.text,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: UserColors.primary,
        borderRadius: BorderRadius.circular(UserRadii.badge),
      ),
      child: Text(label, style: UserText.badge),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: UserColors.gold,
        borderRadius: BorderRadius.circular(UserRadii.tag),
      ),
      child: Text(label, style: UserText.tag),
    );
  }
}
