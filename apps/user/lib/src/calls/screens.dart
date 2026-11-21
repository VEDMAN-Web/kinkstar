// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import '../onboarding/chrome.dart';
import 'data.dart';

/// Shown only before `config.calls` loads. The loaded screen reads these
/// strings from JSON.
const _answersIn = 'Online · usually answers in 5s';
const _billing = 'Per second · stops when you hang up';
const _balanceWarning =
    "We'll warn you 60 seconds before your balance runs out. You can top up without ending the call.";
const _dontShow = "Don't show this again for calls under 60/min";
const _notCharged = 'You are not charged until she answers';
const _verifiedLive = 'Verified host · live now';
const _talkedYesterday = 'You talked yesterday';
const _turnOffCallbacks = 'Turn off host call-backs';
const _videoCaption = 'Live video (host camera)';
const _youLabel = 'You';
const _videoClock = '03:12';
const _liveBalance = 88;
const _liveMinutesLeft = 2;
const _roseSent = 10;
const _priyaThanks = 'Thank you so much!';
const _songChip = 'Song';
const _giftClock = '03:40';
const _giftBalance = 64;
const _starName = 'Star';
const _starPrice = 30;
const _crownArtboardPrice = 500;
const _combo = 'Combo x3 active · send again within 3s';
const _lowBalanceClock = '0:58';
const _lowBalanceSeconds = 58;
const _anjaliName = 'Anjali';
const _anjaliVoiceRate = 20;
const _voiceClock = '07:25';
const _queuePlace = 3;
const _queueWait = 'About 2 minutes';
const _queueCopy =
    "All Hindi-speaking hosts are in calls. We'll connect you to the next free one.";
const _voiceHostsAvailable = 12;

class ConfirmCallScreen extends StatelessWidget {
  const ConfirmCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CallStage(
      builder: (data) {
        final name = data?.priya.name ?? 'Priya';
        final video = data?.priya.videoRatePerMin ?? 40;
        final voice = data?.priya.voiceRatePerMin ?? 20;
        final diamonds = data?.diamonds ?? 120;
        final minutes = data?.talkMinutes ?? (diamonds ~/ video);
        return Stack(
          children: [
            const Positioned.fill(child: KsMediaBox(label: '', radius: 0)),
            const Positioned.fill(child: ColoredBox(color: UserColors.dim)),
            Align(
              alignment: Alignment.bottomCenter,
              child: _Sheet(
                children: [
                  _Grab(),
                  Row(
                    children: [
                      _Avatar(name, online: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Video call with $name',
                              style: UserText.body.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              data?.lines.answersIn ?? _answersIn,
                              style: UserText.xs.copyWith(
                                fontWeight: FontWeight.w400,
                                color: UserColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _Card(
                    child: Column(
                      children: [
                        _Stat('Rate', _GemText('$video / minute', bold: true)),
                        const SizedBox(height: 10),
                        _Stat(
                          'Your balance',
                          Text(
                            '$diamonds Diamonds',
                            style: UserText.small.copyWith(
                              fontWeight: FontWeight.w700,
                              color: UserColors.gold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _Stat(
                          'Talk time',
                          Text(
                            'about $minutes minutes',
                            style: UserText.small.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _Stat(
                          'Billing',
                          Text(
                            data?.lines.billing ?? _billing,
                            style: UserText.small,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Note(data?.lines.warning ?? _balanceWarning),
                  Row(
                    children: [
                      const KsCheck(on: true),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data?.lines.dontShow ?? _dontShow,
                          style: UserText.small,
                        ),
                      ),
                    ],
                  ),
                  KsButton(
                    label: data?.lines.startLabel ?? 'Start video call',
                    icon: KsIcons.video,
                  ),
                  KsButton(
                    label:
                        data?.lines.voiceInstead ??
                        'Voice call instead · $voice/min',
                    background: Colors.transparent,
                    foreground: UserColors.text,
                    borderColor: UserColors.line,
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

class OutgoingCallScreen extends StatelessWidget {
  const OutgoingCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CallStage(
      builder: (data) {
        final name = data?.priya.name ?? 'Priya';
        final video = data?.priya.videoRatePerMin ?? 40;
        return DecoratedBox(
          decoration: const BoxDecoration(gradient: UserGradients.calling),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 48),
            child: Column(
              children: [
                _Avatar(name, size: 140, fontSize: 44, rings: true),
                const SizedBox(height: 34),
                Text(name, style: UserText.h1),
                const SizedBox(height: 14),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Calling… · ',
                      style: UserText.small.copyWith(color: UserColors.muted),
                    ),
                    const KsIcon(KsIcons.gem, color: UserColors.muted),
                    Text(
                      ' $video/min',
                      style: UserText.small.copyWith(color: UserColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  data?.lines.notice ?? _notCharged,
                  style: UserText.xs.copyWith(
                    fontWeight: FontWeight.w400,
                    color: UserColors.muted,
                  ),
                ),
                const Spacer(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoundControl(
                      icon: KsIcons.camera,
                      label: 'Camera',
                      size: 60,
                      muted: true,
                    ),
                    SizedBox(width: 32),
                    _RoundControl(
                      icon: KsIcons.phoneOff,
                      label: 'Cancel',
                      size: 72,
                      background: UserColors.danger,
                    ),
                    SizedBox(width: 32),
                    _RoundControl(
                      icon: KsIcons.mic,
                      label: 'Mic',
                      size: 60,
                      muted: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CallStage(
      builder: (data) {
        final name = data?.priya.name ?? 'Priya';
        final video = data?.priya.videoRatePerMin ?? 40;
        return Stack(
          children: [
            const Positioned.fill(child: KsMediaBox(label: '', radius: 0)),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: UserGradients.videoScrim),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 96, 24, 56),
              child: Column(
                children: [
                  _Glass(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const KsIcon(KsIcons.shield, color: UserColors.white),
                        const SizedBox(width: 6),
                        Text(
                          data?.lines.incomingBadge ?? _verifiedLive,
                          style: UserText.small.copyWith(
                            color: UserColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _Avatar(name, size: 120, fontSize: 40),
                  const SizedBox(height: 10),
                  Text(
                    '$name is calling you',
                    style: UserText.h1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  _GemText(
                    '${data?.lines.talked ?? _talkedYesterday} · ${data?.lines.rateNote ?? '$video/min if you answer'}',
                    color: UserColors.muted,
                  ),
                  const Spacer(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _RoundControl(
                        icon: KsIcons.phoneOff,
                        label: 'Decline',
                        size: 72,
                        background: UserColors.danger,
                      ),
                      SizedBox(width: 56),
                      _RoundControl(
                        icon: KsIcons.video,
                        label: 'Answer',
                        size: 72,
                        background: UserColors.successSolid,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data?.lines.turnOff ?? _turnOffCallbacks,
                    style: UserText.small.copyWith(color: UserColors.muted),
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

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CallStage(
      builder: (data) {
        final name = data?.priya.name ?? 'Priya';
        final video = data?.priya.videoRatePerMin ?? 40;
        final rose = data?.gift('gift_rose').name ?? 'Rose';
        final wave = data?.gift('gift_wave').price ?? 20;
        final singGift = data?.gift('gift_sing');
        final sing = singGift?.price ?? 99;
        final songChip = singGift?.chipLabel ?? _songChip;
        final dance = data?.gift('gift_dance').price ?? 199;
        final lines = data?.lines;
        return Stack(
          children: [
            _VideoBackdrop(
              caption: lines?.caption ?? _videoCaption,
              youLabel: lines?.youLabel ?? _youLabel,
            ),
            Positioned(
              top: 52,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  _Glass(
                    padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Avatar(name, size: 36, fontSize: 14),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: UserText.small.copyWith(
                                fontWeight: FontWeight.w700,
                                color: UserColors.white,
                              ),
                            ),
                            _GemText(
                              '$video/min',
                              color: UserColors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const KsIconButton(
                    icon: KsIcons.heart,
                    size: 40,
                    background: UserColors.overlay40,
                    color: UserColors.white,
                  ),
                  const Spacer(),
                  _Glass(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '●',
                          style: UserText.glass.copyWith(color: UserColors.ok),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lines?.videoClock ?? _videoClock,
                          style: UserText.glass,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const KsIconButton(
                    icon: KsIcons.flag,
                    background: UserColors.overlay40,
                    color: UserColors.white,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 112,
              left: 16,
              child: _Glass(
                child: _GemText(
                  'Balance ${lines?.balanceLine ?? '$_liveBalance · ~$_liveMinutesLeft min left'}',
                  color: UserColors.white,
                  size: 12,
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Glass(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${lines?.youLabel ?? _youLabel} ',
                          style: UserText.small.copyWith(
                            fontWeight: FontWeight.w700,
                            color: UserColors.white,
                          ),
                        ),
                        Text(
                          'sent $rose x${lines?.roseSent ?? _roseSent}',
                          style: UserText.small.copyWith(
                            color: UserColors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const KsIcon(KsIcons.heart, color: UserColors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  _Glass(
                    child: Text.rich(
                      TextSpan(
                        style: UserText.small.copyWith(color: UserColors.white),
                        children: [
                          TextSpan(
                            text: name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: ': ${lines?.thanks ?? _priyaThanks}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 128,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      'Interactive:',
                      style: UserText.xs.copyWith(color: UserColors.white),
                    ),
                    const SizedBox(width: 8),
                    _DarkChip('$songChip · $sing'),
                    const SizedBox(width: 8),
                    _DarkChip('Wave · $wave'),
                    const SizedBox(width: 8),
                    _DarkChip('Dance · $dance'),
                  ],
                ),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KsIconButton(
                    icon: KsIcons.mic,
                    size: 52,
                    background: UserColors.overlay50,
                    color: UserColors.white,
                  ),
                  KsIconButton(
                    icon: KsIcons.switchCamera,
                    size: 52,
                    background: UserColors.overlay50,
                    color: UserColors.white,
                  ),
                  KsIconButton(
                    icon: KsIcons.messageSquare,
                    size: 52,
                    background: UserColors.overlay50,
                    color: UserColors.white,
                  ),
                  KsIconButton(
                    icon: KsIcons.gift,
                    size: 52,
                    background: UserColors.gold,
                    color: UserColors.goldInk,
                  ),
                  KsIconButton(
                    icon: KsIcons.phoneOff,
                    size: 60,
                    background: UserColors.danger,
                    color: UserColors.white,
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

class GiftPanelScreen extends StatelessWidget {
  const GiftPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CallStage(
      builder: (data) {
        final rose = data?.gift('gift_rose');
        final sing = data?.gift('gift_sing');
        final star = data?.gift('gift_star');
        final crown = data?.gift('gift_crown');
        final lines = data?.lines;
        return Stack(
          children: [
            _VideoBackdrop(
              caption: lines?.caption ?? _videoCaption,
              youLabel: lines?.youLabel ?? _youLabel,
            ),
            Positioned(
              top: 52,
              left: 16,
              child: _Glass(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '●',
                      style: UserText.glass.copyWith(color: UserColors.ok),
                    ),
                    const SizedBox(width: 6),
                    Text(lines?.giftClock ?? _giftClock, style: UserText.glass),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _Sheet(
                color: UserColors.sheet,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Gifts', style: UserText.h2)),
                      _GoldChip('${lines?.giftBalance ?? _giftBalance}'),
                      const SizedBox(width: 12),
                      KsButton(
                        label: 'Top up',
                        minHeight: 36,
                        background: UserColors.gold,
                        foreground: UserColors.goldInk,
                        textStyle: UserText.buttonSm,
                      ),
                    ],
                  ),
                  const _Segmented([
                    'Popular',
                    'Interactive',
                    'Luxury',
                    'Event',
                  ]),
                  Row(
                    children: [
                      _Pack(
                        selected: true,
                        icon: KsIcons.heart,
                        iconColor: UserColors.primarySoft,
                        name: rose?.name ?? 'Rose',
                        price: '${rose?.price ?? 10}',
                      ),
                      const SizedBox(width: 8),
                      _Pack(
                        icon: KsIcons.star,
                        iconColor: UserColors.gold,
                        name: star?.name ?? _starName,
                        price: '${star?.price ?? _starPrice}',
                      ),
                      const SizedBox(width: 8),
                      _Pack(
                        tag: sing?.tag ?? 'SONG',
                        icon: KsIcons.mic,
                        name: sing?.name ?? 'Sing for me',
                        price: '${sing?.price ?? 99}',
                      ),
                      const SizedBox(width: 8),
                      _Pack(
                        icon: KsIcons.crown,
                        iconColor: UserColors.gold,
                        name: crown?.name ?? 'Crown',
                        price: '${crown?.price ?? _crownArtboardPrice}',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lines?.combo ?? _combo,
                          style: UserText.small,
                        ),
                      ),
                      const SizedBox(width: 8),
                      KsButton(
                        label: 'Send ${rose?.name ?? 'Rose'}',
                        minHeight: UserSpace.buttonSm,
                        textStyle: UserText.buttonSm,
                      ),
                    ],
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

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CallStage(
      builder: (data) {
        final name = data?.priya.name ?? 'Priya';
        final lines = data?.lines;
        final packs = lines?.packs;
        return Stack(
          children: [
            _VideoBackdrop(
              caption: lines?.caption ?? _videoCaption,
              youLabel: lines?.youLabel ?? _youLabel,
            ),
            Positioned(
              top: 52,
              left: 16,
              child: _Glass(
                color: UserColors.lowBalance,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const KsIcon(KsIcons.clock4, color: UserColors.white),
                    const SizedBox(width: 6),
                    Text(
                      lines?.lowClock ?? '$_lowBalanceClock left',
                      style: UserText.glass,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _Sheet(
                children: [
                  _Grab(),
                  Text('Keep talking to $name', style: UserText.h2),
                  Text(
                    lines?.lowBody ??
                        'Your balance runs out in $_lowBalanceSeconds seconds. The call continues while you pay.',
                    style: UserText.small,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < (packs?.length ?? 3); i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        if (packs == null && i == 0)
                          const _PayPack(diamonds: '100', price: '₹49')
                        else if (packs == null && i == 1)
                          const _PayPack(
                            diamonds: '600',
                            price: '₹249',
                            bonus: '+20% bonus',
                            tag: 'BEST',
                            selected: true,
                          )
                        else if (packs == null)
                          const _PayPack(diamonds: '1,300', price: '₹499')
                        else
                          _PayPack(
                            diamonds: packs[i].diamondsLabel,
                            price: '₹${packs[i].priceInr}',
                            bonus: packs[i].bonusLabel,
                            tag: packs[i].tag,
                            selected: packs[i].tag != null,
                          ),
                      ],
                    ],
                  ),
                  KsButton(
                    label: lines?.lowPay ?? 'Pay ₹249 with Google Play',
                    background: UserColors.gold,
                    foreground: UserColors.goldInk,
                  ),
                  Text(
                    lines?.lowOther ?? 'Other payment methods',
                    textAlign: TextAlign.center,
                    style: UserText.small,
                  ),
                  KsButton(
                    label: lines?.lowEnd ?? 'End call when balance runs out',
                    background: Colors.transparent,
                    foreground: UserColors.text,
                    borderColor: UserColors.line,
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

class VoiceCallScreen extends StatelessWidget {
  const VoiceCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CallStage(
      builder: (data) {
        final anjali = data?.anjali.name ?? _anjaliName;
        final lines = data?.lines;
        return DecoratedBox(
          decoration: BoxDecoration(gradient: UserGradients.voiceCall),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 110, 24, 48),
            child: Column(
              children: [
                _Glass(
                  child: _GemText(
                    lines?.voiceLabel ?? 'Voice call · $_anjaliVoiceRate/min',
                    color: UserColors.white,
                  ),
                ),
                SizedBox(height: 20),
                _Avatar(anjali, size: 150, fontSize: 48),
                SizedBox(height: 12),
                Text(anjali, style: UserText.h1),
                SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    style: UserText.body,
                    children: [
                      TextSpan(
                        text: '● ',
                        style: TextStyle(color: UserColors.ok),
                      ),
                      TextSpan(
                        text: lines?.voiceClock ?? _voiceClock,
                        style: TextStyle(color: UserColors.muted),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                _Waveform(),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RoundControl(
                      icon: KsIcons.micOff,
                      label: 'Mute',
                      size: 56,
                      muted: true,
                    ),
                    _RoundControl(
                      icon: KsIcons.video,
                      label: 'Video',
                      size: 56,
                      muted: true,
                    ),
                    _RoundControl(
                      icon: KsIcons.gift,
                      label: 'Gift',
                      size: 56,
                      muted: true,
                      color: UserColors.gold,
                    ),
                    _RoundControl(
                      icon: KsIcons.phoneOff,
                      label: 'End',
                      size: 56,
                      background: UserColors.danger,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CallSummaryScreen extends StatelessWidget {
  const CallSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CallStage(
      builder: (data) {
        final name = data?.priya.name ?? 'Priya';
        final duration = callClock(data?.summary.durationSec ?? 522);
        final spent = data?.summary.diamondsCharged ?? 349;
        final gifts = data?.summary.giftsCount ?? 2;
        return Column(
          children: [
            const SizedBox(height: UserSpace.statusBar),
            const KsTopBar(trailing: KsIconButton(icon: KsIcons.x)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _Avatar(name, size: 88, fontSize: 28),
                    const SizedBox(height: 14),
                    Text('Call with $name ended', style: UserText.h2),
                    const SizedBox(height: 14),
                    _Card(
                      child: Row(
                        children: [
                          _SummaryStat(duration, 'Duration'),
                          _SummaryStat('$spent', 'Diamonds used', gold: true),
                          _SummaryStat('$gifts', 'Gifts sent'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How was $name?',
                      style: UserText.small.copyWith(color: UserColors.text),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        KsIcon(KsIcons.star, color: UserColors.gold),
                        SizedBox(width: 8),
                        KsIcon(KsIcons.star, color: UserColors.gold),
                        SizedBox(width: 8),
                        KsIcon(KsIcons.star, color: UserColors.gold),
                        SizedBox(width: 8),
                        KsIcon(KsIcons.star, color: UserColors.gold),
                        SizedBox(width: 8),
                        KsIcon(KsIcons.star, color: UserColors.gold),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final chip
                            in data?.lines.chips ??
                                const [
                                  CallChip(label: 'Friendly', selected: true),
                                  CallChip(label: 'Good talk', selected: false),
                                  CallChip(
                                    label: 'Camera off',
                                    selected: false,
                                  ),
                                  CallChip(label: 'Rude', selected: false),
                                ])
                          KsChip(label: chip.label, on: chip.selected),
                      ],
                    ),
                    const Spacer(),
                    const KsButton(label: 'Call again', icon: KsIcons.video),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(
                          child: KsButton(
                            label: 'Follow',
                            icon: KsIcons.heart,
                            background: Colors.transparent,
                            foreground: UserColors.text,
                            borderColor: UserColors.line,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: KsButton(
                            label: 'Report',
                            icon: KsIcons.flag,
                            background: Colors.transparent,
                            foreground: UserColors.text,
                            borderColor: UserColors.line,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _CallStage(
      builder: (data) {
        final aria = data?.aria.name ?? 'Aria';
        final lines = data?.lines;
        return Column(
          children: [
            const SizedBox(height: UserSpace.statusBar),
            const KsTopBar(
              leading: KsIconButton(icon: KsIcons.chevronLeft),
              title: 'Waiting for a host',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _QueueRing(lines?.queuePlace ?? _queuePlace),
                    const SizedBox(height: 16),
                    Text(lines?.queueWait ?? _queueWait, style: UserText.h2),
                    const SizedBox(height: 16),
                    Text(
                      lines?.queueBody ?? _queueCopy,
                      textAlign: TextAlign.center,
                      style: UserText.small,
                    ),
                    const SizedBox(height: 16),
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lines?.dontWait ?? "Don't want to wait?",
                            style: UserText.small.copyWith(
                              fontWeight: FontWeight.w700,
                              color: UserColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const _Avatar(
                                '',
                                icon: KsIcons.bot,
                                background: UserColors.aiAvatar,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Talk to $aria now',
                                          style: UserText.small.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: UserColors.text,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const _AiBadge(),
                                      ],
                                    ),
                                    Text(
                                      lines?.ariaLine ??
                                          'AI companion · ${data?.aria.videoRatePerMin ?? 15}/min',
                                      style: UserText.xs.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: UserColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              KsButton(
                                label: 'Call',
                                minHeight: UserSpace.buttonSm,
                                textStyle: UserText.buttonSm,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const KsIconButton(icon: KsIcons.phone),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Voice-only hosts',
                                      style: UserText.small.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: UserColors.text,
                                      ),
                                    ),
                                    Text(
                                      '${lines?.voiceHosts ?? _voiceHostsAvailable} available now',
                                      style: UserText.xs.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: UserColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              KsButton(
                                label: 'See',
                                minHeight: UserSpace.buttonSm,
                                textStyle: UserText.buttonSm,
                                background: Colors.transparent,
                                foreground: UserColors.text,
                                borderColor: UserColors.line,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const KsSwitch(on: true),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            lines?.notify ?? "Notify me when it's my turn",
                            style: UserText.small.copyWith(
                              color: UserColors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    KsButton(
                      label: lines?.leave ?? 'Leave queue',
                      background: Colors.transparent,
                      foreground: UserColors.text,
                      borderColor: UserColors.line,
                    ),
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

class _CallStage extends StatefulWidget {
  const _CallStage({required this.builder});

  final Widget Function(CallsData? data) builder;

  @override
  State<_CallStage> createState() => _CallStageState();
}

class _CallStageState extends State<_CallStage> {
  CallsData? _data;

  @override
  void initState() {
    super.initState();
    loadCalls().then((data) {
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

class _VideoBackdrop extends StatelessWidget {
  const _VideoBackdrop({required this.caption, required this.youLabel});

  final String caption;
  final String youLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: UserColors.video)),
        Positioned(
          top: 844 * 0.46,
          left: 0,
          right: 0,
          child: Text(
            caption,
            textAlign: TextAlign.center,
            style: UserText.caption,
          ),
        ),
        Positioned(right: 16, top: 100, child: _Pip(youLabel)),
      ],
    );
  }
}

class _Pip extends StatelessWidget {
  const _Pip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 150,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: UserColors.pip,
        borderRadius: BorderRadius.circular(UserRadii.chip),
        border: Border.all(color: UserColors.pipBorder, width: 2),
      ),
      child: Text(label, style: UserText.badge),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.children, this.color = UserColors.surface1});

  final List<Widget> children;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UserRadii.sheet),
        ),
        border: const Border(top: BorderSide(color: UserColors.line)),
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

class _Grab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: UserColors.line,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

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
      child: child,
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: UserColors.noteBg,
        borderRadius: BorderRadius.circular(UserRadii.note),
        border: Border.all(color: UserColors.noteBorder),
      ),
      child: Text(
        text,
        style: UserText.small.copyWith(color: UserColors.noteText),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: UserText.small)),
        value,
      ],
    );
  }
}

class _GemText extends StatelessWidget {
  const _GemText(this.text, {this.color, this.bold = false, this.size});

  final String text;
  final Color? color;
  final bool bold;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final style = (size == 12 ? UserText.xs : UserText.small).copyWith(
      color: color,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KsIcon(
          KsIcons.gem,
          size: size == 12 ? 16 : 22,
          color: color ?? UserColors.text,
        ),
        const SizedBox(width: 4),
        Text(text, style: style),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(
    this.name, {
    this.size = 48,
    this.fontSize = 16,
    this.online = false,
    this.rings = false,
    this.icon,
    this.background = UserColors.avatar,
  });

  final String name;
  final double size;
  final double fontSize;
  final bool online;
  final bool rings;
  final KsGlyph? icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final letter = name.isEmpty ? '' : name.characters.first;
    final disc = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (icon != null)
            KsIcon(icon!, color: UserColors.white)
          else
            Text(letter, style: UserText.avatar.copyWith(fontSize: fontSize)),
          if (online)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: UserColors.ok,
                  shape: BoxShape.circle,
                  border: Border.all(color: UserColors.bg, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
    if (!rings) return disc;
    // CSS box-shadow: 0 0 0 12px rgba(225,29,72,.18), 0 0 0 26px rgba(225,29,72,.08).
    // Drawn as discs so the shadow blur filter cannot feather or widen them.
    return CustomPaint(painter: const _CallRings(), child: disc);
  }
}

class _CallRings extends CustomPainter {
  const _CallRings();

  static const _color = Color(0xFFE11D48);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(
      center,
      radius + 26,
      Paint()
        ..color = _color.withValues(alpha: 0.08)
        ..isAntiAlias = true,
    );
    canvas.drawCircle(
      center,
      radius + 12,
      Paint()
        ..color = _color.withValues(alpha: 0.18)
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant _CallRings oldDelegate) => false;
}

class _RoundControl extends StatelessWidget {
  const _RoundControl({
    required this.icon,
    required this.label,
    required this.size,
    this.background = UserColors.surface2,
    this.color = UserColors.text,
    this.muted = false,
  });

  final KsGlyph icon;
  final String label;
  final double size;
  final Color background;
  final Color color;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KsIconButton(
          icon: icon,
          size: size,
          background: background,
          color: color,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: UserText.xs.copyWith(
            fontWeight: FontWeight.w400,
            color: muted ? UserColors.muted : UserColors.text,
          ),
        ),
      ],
    );
  }
}

class _Glass extends StatelessWidget {
  const _Glass({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.color = UserColors.glass,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(UserRadii.glass),
      ),
      child: child,
    );
  }
}

class _DarkChip extends StatelessWidget {
  const _DarkChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: UserColors.overlay50,
        borderRadius: BorderRadius.circular(UserRadii.chip),
        border: Border.all(color: UserColors.line),
      ),
      child: Text(label, style: UserText.chip.copyWith(color: UserColors.text)),
    );
  }
}

class _GoldChip extends StatelessWidget {
  const _GoldChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: UserColors.chipGoldBg,
        borderRadius: BorderRadius.circular(UserRadii.chip),
        border: Border.all(color: UserColors.chipGoldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const KsIcon(KsIcons.gem, color: UserColors.gold),
          const SizedBox(width: 6),
          Text(label, style: UserText.chip.copyWith(color: UserColors.gold)),
        ],
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented(this.labels);

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

class _Pack extends StatelessWidget {
  const _Pack({
    required this.icon,
    required this.name,
    required this.price,
    this.iconColor = UserColors.text,
    this.selected = false,
    this.tag,
  });

  final KsGlyph icon;
  final Color iconColor;
  final String name;
  final String price;
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
                KsIcon(icon, color: iconColor),
                const SizedBox(height: 4),
                Text(name, textAlign: TextAlign.center, style: UserText.xs),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: UserText.xs.copyWith(color: UserColors.gold),
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

class _PayPack extends StatelessWidget {
  const _PayPack({
    required this.diamonds,
    required this.price,
    this.bonus,
    this.tag,
    this.selected = false,
  });

  final String diamonds;
  final String price;
  final String? bonus;
  final String? tag;
  final bool selected;

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
                _GemText(diamonds, bold: true, color: UserColors.text),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: UserText.xs.copyWith(
                    fontWeight: FontWeight.w400,
                    color: UserColors.muted,
                  ),
                ),
                if (bonus != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    bonus!,
                    style: UserText.xs.copyWith(color: UserColors.ok),
                  ),
                ],
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

class _SummaryStat extends StatelessWidget {
  const _SummaryStat(this.value, this.label, {this.gold = false});

  final String value;
  final String label;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
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
            ),
          ),
        ],
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  static const _heights = [14.0, 30.0, 20.0, 36.0, 12.0];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < _heights.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Container(
              width: 4,
              height: _heights[i],
              decoration: BoxDecoration(
                color: UserColors.primarySoft,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QueueRing extends StatelessWidget {
  const _QueueRing(this.place);

  final int place;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _QueueRingPainter(),
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('#$place', style: UserText.display48),
            Text('in queue', style: UserText.small),
          ],
        ),
      ),
    );
  }
}

class _QueueRingPainter extends CustomPainter {
  const _QueueRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final deflated = rect.deflate(3);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = UserColors.surface2;
    final top = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = UserColors.primary;
    canvas.drawArc(deflated, 0, 6.283185307179586, false, base);
    canvas.drawArc(
      deflated,
      -2.356194490192345,
      1.5707963267948966,
      false,
      top,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AiBadge extends StatelessWidget {
  const _AiBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: UserColors.info,
        borderRadius: BorderRadius.circular(UserRadii.badge),
      ),
      child: Text(
        'AI',
        style: UserText.badge.copyWith(color: UserColors.infoInk),
      ),
    );
  }
}
