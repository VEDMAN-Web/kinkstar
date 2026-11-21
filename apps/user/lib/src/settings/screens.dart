import 'dart:math' as math;

// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import '../onboarding/chrome.dart';
import 'data.dart';

final _button = UserText.button.copyWith(height: 1.21);
final _buttonSm = UserText.buttonSm.copyWith(height: 1.21);

TextStyle get _sm => UserText.small.copyWith(color: UserColors.text);

TextStyle get _xsMuted =>
    UserText.xs.copyWith(fontWeight: FontWeight.w400, color: UserColors.muted);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(settingsProvider).value?.version ?? '1.0.0';
    return _Page(
      title: 'Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Head('CALLS', top: 6, bottom: 6),
          const _Line(
            icon: KsIcons.camera,
            label: 'Camera on when call starts',
            trailing: KsSwitch(on: true),
          ),
          const _Line(
            icon: KsIcons.mic,
            label: 'Microphone on when call starts',
            trailing: KsSwitch(on: true),
          ),
          const _Line(
            icon: KsIcons.phone,
            label: 'Allow host call-backs',
            trailing: KsSwitch(on: true),
          ),
          const _Line(
            icon: KsIcons.info,
            label: 'Confirm price before calls',
            trailing: KsSwitch(on: true),
          ),
          const _Head('NOTIFICATIONS', top: 14, bottom: 6),
          const _Line(
            icon: KsIcons.bell,
            label: 'Followed hosts online',
            trailing: KsSwitch(on: true),
          ),
          const _Line(
            icon: KsIcons.gift,
            label: 'Offers and events',
            trailing: KsSwitch(on: false),
          ),
          const _Head('ACCOUNT', top: 14, bottom: 6),
          const _Line(
            icon: KsIcons.globe,
            label: 'App language',
            trailing: _Muted('English'),
          ),
          const _Line(icon: KsIcons.shield, label: 'Privacy & data'),
          _Line(
            icon: KsIcons.info,
            label: 'About',
            trailing: _Muted('v$version'),
          ),
          const _Line(icon: KsIcons.logOut, label: 'Sign out'),
          const _Line(
            icon: KsIcons.trash2,
            label: 'Delete account',
            color: UserColors.dangerText,
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(settingsProvider).value ?? SettingsData.fallback;
    final letter = data.username.isEmpty ? 'R' : data.username[0];
    return _Page(
      title: 'Edit profile',
      trailing: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(
          'Save',
          style: UserText.small.copyWith(
            color: UserColors.primarySoft,
            decoration: TextDecoration.underline,
            decorationColor: UserColors.primarySoft,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              width: 88,
              height: 88,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: UserColors.avatar,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      letter,
                      style: UserText.avatarLarge.copyWith(height: 1.5),
                    ),
                  ),
                  const Positioned(
                    right: -6,
                    bottom: -6,
                    child: KsIconButton(
                      icon: KsIcons.camera,
                      size: 36,
                      background: UserColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _Field(label: 'Nickname', value: data.username),
          const SizedBox(height: 14),
          const _Field(label: 'Date of birth', value: '14 Mar 1996'),
          const SizedBox(height: 14),
          const _Area(
            label: 'About me (optional)',
            value: 'Movie buff from Delhi',
          ),
          const SizedBox(height: 14),
          Text('Languages', style: UserText.small),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final name in data.spoken) KsChip(label: name, on: true),
              const KsChip(label: '+ Add'),
            ],
          ),
          const SizedBox(height: 14),
          const _Note(
            'Photos are checked automatically. Nudity or contact details in profiles lead to a ban.',
          ),
        ],
      ),
    );
  }
}

class BlockedScreen extends StatelessWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: 'Blocked users',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "Blocked hosts can't call, message or see that you're online.",
              style: _smMuted,
            ),
          ),
          const _Line(avatar: 'D', label: 'Disha', trailing: _Unblock()),
          const _Line(avatar: 'M', label: 'Mona', trailing: _Unblock()),
          Expanded(
            child: Opacity(
              opacity: 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KsIconButton(icon: KsIcons.ban, size: 64),
                  SizedBox(height: 8),
                  Text(
                    'Empty state: "No blocked users"',
                    style: UserText.small,
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

class AppLanguageScreen extends StatelessWidget {
  const AppLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('Same as phone', false),
      ('English', true),
      ('हिन्दी', false),
      ('বাংলা', false),
      ('தமிழ்', false),
      ('తెలుగు', false),
      ('मराठी', false),
      ('ಕನ್ನಡ', false),
    ];
    return _Page(
      title: 'App language',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final row in rows)
            _Line(
              label: row.$1,
              trailing: KsCheck(on: row.$2),
            ),
          const SizedBox(height: 14),
          _Card(
            child: Row(
              children: [
                const KsIcon(KsIcons.globe),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Auto-translate chat messages', style: _sm),
                ),
                const SizedBox(width: 12),
                const KsSwitch(on: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const topics = [
      'Diamonds not received after paying',
      'How call billing works',
      'Request a refund',
      'Calls not connecting',
      'Report a host',
      'Delete my account',
    ];
    return _Page(
      title: 'Help & feedback',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Field(
            label: 'Search help',
            placeholder: 'e.g. Diamonds not received',
          ),
          const SizedBox(height: 14),
          for (final topic in topics)
            _Line(
              label: topic,
              small: true,
              trailing: const KsIcon(KsIcons.plus),
            ),
          const SizedBox(height: 14),
          const _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Still need help?', style: _boldSmStyle),
                SizedBox(height: 8),
                Text('Average reply time: 2 hours', style: _xsMutedStyle),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _Bar(
                        label: 'Chat with support',
                        icon: KsIcons.messageSquare,
                        filled: true,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: _Bar(label: 'Email')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Grievance Officer: [NAME], [EMAIL] · IT Rules 2021',
            style: _xsMutedStyle,
          ),
        ],
      ),
    );
  }
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const reasons = [
      ('Nudity or sexual content', false),
      ('Camera off / not showing face', true),
      ('Asked for money or contact details', false),
      ('Fake profile photos', false),
      ('Rude or abusive', false),
      ('Looks under 18', false),
    ];
    return Scaffold(
      backgroundColor: UserColors.video,
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: UserColors.video)),
          Positioned(
            top: UserSpace.frameHeight * 0.46,
            left: 0,
            right: 0,
            child: Text(
              'Live video (host camera)',
              textAlign: TextAlign.center,
              style: UserText.caption.copyWith(height: 1.21),
            ),
          ),
          const Positioned.fill(child: ColoredBox(color: UserColors.dim)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: UserColors.surface1,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(UserRadii.sheet),
                ),
                border: Border(top: BorderSide(color: UserColors.line)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
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
                    Text(
                      'Report Priya',
                      style: UserText.h2.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Your report is private. The last 30 seconds of the call are reviewed by our safety team.',
                      style: _smMuted,
                    ),
                    const SizedBox(height: 14),
                    for (final reason in reasons)
                      _Line(
                        leading: KsCheck(on: reason.$2),
                        label: reason.$1,
                        small: true,
                      ),
                    const SizedBox(height: 14),
                    const _Area(label: 'Details (optional)', height: 72),
                    const SizedBox(height: 14),
                    const Row(
                      children: [
                        KsCheck(on: true),
                        SizedBox(width: 8),
                        Text('Also block Priya', style: _smText),
                      ],
                    ),
                    const SizedBox(height: 14),
                    KsButton(label: 'Submit report', textStyle: _button),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RateScreen extends StatelessWidget {
  const RateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserColors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: UserSpace.statusBar),
              const KsTopBar(title: 'Discover'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: _HostTile()),
                    SizedBox(width: 12),
                    Expanded(child: _HostTile()),
                  ],
                ),
              ),
            ],
          ),
          const Positioned.fill(child: ColoredBox(color: UserColors.dim)),
          const Positioned(left: 20, right: 20, bottom: 40, child: _PlayCard()),
        ],
      ),
    );
  }
}

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(settingsProvider).value?.version ?? '1.0.0';
    const links = [
      'Terms of Service',
      'Privacy Policy',
      'Community Rules',
      'Refund Policy',
      'Grievance Redressal',
      'Open-source licences',
    ];
    return _Page(
      title: 'About',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: UserColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Center(
                  child: KsIcon(KsIcons.star, color: UserColors.text),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Kinkstar Calls',
            textAlign: TextAlign.center,
            style: UserText.kpi.copyWith(height: 1.5),
          ),
          const SizedBox(height: 14),
          Text(
            'Version $version (100)',
            textAlign: TextAlign.center,
            style: UserText.small,
          ),
          const SizedBox(height: 24),
          for (final link in links) _Line(label: link),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 28),
            child: Text(
              'Operated by SparkBeta Tech, Cyber City, Utran, Surat, Gujarat, India',
              textAlign: TextAlign.center,
              style: _xsMutedStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteAccountScreen extends ConsumerWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diamonds =
        ref.watch(settingsProvider).value?.diamonds ??
        SettingsData.fallback.diamonds;
    const reasons = [
      'Too expensive',
      'Not enough hosts',
      'Privacy concerns',
      'Other',
    ];
    return _Page(
      title: 'Delete account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What happens', style: _boldSmStyle),
                SizedBox(height: 8),
                Text(
                  'Your profile, chats and call history are deleted within 30 days. Payment records are kept as required by law.',
                  style: _smMuted,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Card(
            border: UserColors.chipGoldBorder,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const KsIcon(KsIcons.gem, color: UserColors.gold),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: _sm,
                      children: [
                        const TextSpan(text: 'You have '),
                        TextSpan(
                          text: '$diamonds Diamonds',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(text: '. '),
                        const TextSpan(
                          text: 'Request a refund of unused Diamonds',
                          style: TextStyle(
                            color: UserColors.primarySoft,
                            decoration: TextDecoration.underline,
                            decorationColor: UserColors.primarySoft,
                          ),
                        ),
                        const TextSpan(text: ' before deleting.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('Why are you leaving? (optional)', style: _smMuted),
          const SizedBox(height: 14),
          for (final reason in reasons)
            _Line(
              leading: const KsCheck(on: false),
              label: reason,
              small: true,
            ),
          const Spacer(),
          KsButton(
            label: 'Delete my account',
            background: UserColors.danger,
            textStyle: _button,
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: KsButton(
              label: 'Keep my account',
              background: Colors.transparent,
              borderColor: UserColors.line,
              foreground: UserColors.text,
              textStyle: _button,
            ),
          ),
        ],
      ),
    );
  }
}

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserColors.bg,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: KsIconButton(
                icon: KsIcons.upload,
                size: 72,
                color: UserColors.gold,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Update required',
              textAlign: TextAlign.center,
              style: UserText.h1,
            ),
            const SizedBox(height: 14),
            Text(
              'This version is no longer supported. Update for faster calls and new gifts.',
              textAlign: TextAlign.center,
              style: UserText.body.copyWith(color: UserColors.muted),
            ),
            const SizedBox(height: 14),
            const _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What's new in 1.2.0", style: _boldSmStyle),
                  SizedBox(height: 4),
                  Text(
                    '· HD video on slow networks\n· Festival gifts\n· Bug fixes',
                    style: _xsMutedStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            KsButton(label: 'Update on Google Play', textStyle: _button),
            const SizedBox(height: 14),
            const Text(
              'Soft-update variant shows "Later" as well',
              textAlign: TextAlign.center,
              style: _xsMutedStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserColors.bg,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: KsIconButton(icon: KsIcons.wifi, size: 72)),
            const SizedBox(height: 14),
            Text(
              'No internet',
              textAlign: TextAlign.center,
              style: UserText.h1,
            ),
            const SizedBox(height: 14),
            Text(
              'Check your connection. Your balance and chats are safe.',
              textAlign: TextAlign.center,
              style: UserText.body.copyWith(color: UserColors.muted),
            ),
            const SizedBox(height: 14),
            KsButton(label: 'Try again', textStyle: _button),
            const SizedBox(height: 38),
            const _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Maintenance variant', style: _boldSmStyle),
                  SizedBox(height: 8),
                  Text(
                    '"We\'re upgrading Kinkstar Calls. Back at 4:00 am." Message and time come from Remote Config.',
                    style: _xsMutedStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserColors.bg,
      body: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            leading: const KsIconButton(icon: KsIcons.chevronLeft),
            title: title,
            trailing: trailing,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Head extends StatelessWidget {
  const _Head(this.text, {required this.top, required this.bottom});

  final String text;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: Text(text, style: _xsMuted),
    );
  }
}

class _Muted extends StatelessWidget {
  const _Muted(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _xsMuted);
  }
}

class _Line extends StatelessWidget {
  const _Line({
    this.icon,
    this.avatar,
    this.leading,
    required this.label,
    this.trailing,
    this.color = UserColors.text,
    this.small = false,
  });

  final KsGlyph? icon;
  final String? avatar;
  final Widget? leading;
  final String label;
  final Widget? trailing;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final style = (small ? _sm : UserText.body).copyWith(color: color);
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: UserColors.line)),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          if (icon != null) ...[
            KsIcon(icon!, color: color),
            const SizedBox(width: 12),
          ],
          if (avatar != null) ...[
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: UserColors.avatar,
                shape: BoxShape.circle,
              ),
              child: Text(
                avatar!,
                style: UserText.avatar.copyWith(height: 1.5),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(child: Text(label, style: style)),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.circular(UserRadii.card),
        border: Border.all(color: border),
      ),
      child: Padding(padding: const EdgeInsets.all(15), child: child),
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
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Text(
          text,
          style: UserText.small.copyWith(color: UserColors.noteText),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, this.value = '', this.placeholder = ''});

  final String label;
  final String value;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final shown = value.isEmpty ? placeholder : value;
    final faded = value.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserText.label.copyWith(height: 1.21)),
        const SizedBox(height: 6),
        DecoratedBox(
          decoration: BoxDecoration(
            color: UserColors.surface2,
            borderRadius: BorderRadius.circular(UserRadii.input),
            border: Border.all(color: UserColors.line, width: 1.5),
          ),
          child: SizedBox(
            height: UserSpace.buttonMin,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  shown,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: UserText.input.copyWith(
                    height: 1.21,
                    color: faded ? UserColors.muted : UserColors.text,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Area extends StatelessWidget {
  const _Area({required this.label, this.value = '', this.height = 96});

  final String label;
  final String value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserText.label.copyWith(height: 1.21)),
        const SizedBox(height: 6),
        Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: UserColors.surface2,
            borderRadius: BorderRadius.circular(UserRadii.input),
            border: Border.all(color: UserColors.line, width: 1.5),
          ),
          child: Text(value, style: UserText.input.copyWith(height: 1.21)),
        ),
      ],
    );
  }
}

class _Unblock extends StatelessWidget {
  const _Unblock();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UserColors.line, width: 1.5),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: SizedBox(
          height: 36,
          child: Center(child: Text('Unblock', style: _buttonSmStyle)),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.label, this.icon, this.filled = false});

  final String label;
  final KsGlyph? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? UserColors.white : UserColors.text;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled ? UserColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        border: filled ? null : Border.all(color: UserColors.line, width: 1.5),
      ),
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              KsIcon(icon!, color: fg),
              const SizedBox(width: 8),
            ],
            Text(label, style: _buttonSm.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}

class _HostTile extends StatelessWidget {
  const _HostTile();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UserRadii.chip),
      child: const SizedBox(
        height: 236,
        width: double.infinity,
        child: CustomPaint(
          painter: _HatchPainter(),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text('Host', style: _hostLabel),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayCard extends StatelessWidget {
  const _PlayCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: UserColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const KsIcon(KsIcons.star, color: UserColors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rate Kinkstar Calls',
                        style: UserText.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: UserColors.playCard,
                        ),
                      ),
                      Text(
                        'Google Play · public review',
                        style: UserText.xs.copyWith(
                          fontWeight: FontWeight.w400,
                          color: UserColors.playMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KsIcon(KsIcons.star, color: UserColors.playStar),
                SizedBox(width: 10),
                KsIcon(KsIcons.star, color: UserColors.playStar),
                SizedBox(width: 10),
                KsIcon(KsIcons.star, color: UserColors.playStar),
                SizedBox(width: 10),
                KsIcon(KsIcons.star, color: UserColors.playStar),
                SizedBox(width: 10),
                KsIcon(KsIcons.star, color: UserColors.playStar),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Google Play's own In-App Review card, shown to every eligible user with no question before it. Quota controlled by Google.",
              textAlign: TextAlign.center,
              style: UserText.xs.copyWith(
                fontWeight: FontWeight.w400,
                color: UserColors.playMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _hostLabel = TextStyle(
  fontFamily: 'packages/kinkstar_ui/Inter',
  fontSize: 12,
  fontWeight: FontWeight.w500,
  height: 1.21,
  color: UserColors.mediaText,
  fontFamilyFallback: [
    'Noto Sans Devanagari',
    'Noto Sans Bengali',
    'Noto Sans Tamil',
    'Noto Sans Telugu',
    'Noto Sans Kannada',
  ],
);

const _xsMutedStyle = TextStyle(
  fontFamily: 'packages/kinkstar_ui/Inter',
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.45,
  color: UserColors.muted,
  fontFamilyFallback: [
    'Noto Sans Devanagari',
    'Noto Sans Bengali',
    'Noto Sans Tamil',
    'Noto Sans Telugu',
    'Noto Sans Kannada',
  ],
);

const _smMuted = TextStyle(
  fontFamily: 'packages/kinkstar_ui/Inter',
  fontSize: 13,
  fontWeight: FontWeight.w400,
  height: 1.45,
  color: UserColors.muted,
  fontFamilyFallback: [
    'Noto Sans Devanagari',
    'Noto Sans Bengali',
    'Noto Sans Tamil',
    'Noto Sans Telugu',
    'Noto Sans Kannada',
  ],
);

const _smText = TextStyle(
  fontFamily: 'packages/kinkstar_ui/Inter',
  fontSize: 13,
  fontWeight: FontWeight.w400,
  height: 1.45,
  color: UserColors.text,
  fontFamilyFallback: [
    'Noto Sans Devanagari',
    'Noto Sans Bengali',
    'Noto Sans Tamil',
    'Noto Sans Telugu',
    'Noto Sans Kannada',
  ],
);

const _boldSmStyle = TextStyle(
  fontFamily: 'packages/kinkstar_ui/Inter',
  fontSize: 13,
  fontWeight: FontWeight.w700,
  height: 1.45,
  color: UserColors.text,
  fontFamilyFallback: [
    'Noto Sans Devanagari',
    'Noto Sans Bengali',
    'Noto Sans Tamil',
    'Noto Sans Telugu',
    'Noto Sans Kannada',
  ],
);

const _buttonSmStyle = TextStyle(
  fontFamily: 'packages/kinkstar_ui/Inter',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  height: 1.21,
  color: UserColors.text,
  fontFamilyFallback: [
    'Noto Sans Devanagari',
    'Noto Sans Bengali',
    'Noto Sans Tamil',
    'Noto Sans Telugu',
    'Noto Sans Kannada',
  ],
);

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
