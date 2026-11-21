// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import 'cached_image.dart';
import 'chrome.dart';
import 'onboarding_data.dart';

void _go(BuildContext context, String location) {
  if (GoRouter.maybeOf(context) != null) context.go(location);
}

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(appConfigProvider).value?.version ?? '1.0.0';
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(gradient: UserGradients.splash),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: UserColors.primary,
                        borderRadius: BorderRadius.circular(UserRadii.logo),
                      ),
                      child: const Center(
                        child: KsIcon(KsIcons.star, color: UserColors.white),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('Kinkstar Calls', style: UserText.h1),
                    const SizedBox(height: 18),
                    Text(
                      'Real people. Real video calls.',
                      style: UserText.body.copyWith(color: UserColors.muted),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '18+ only · v$version · Loading config…',
              textAlign: TextAlign.center,
              style: UserText.xs.copyWith(
                fontWeight: FontWeight.w400,
                color: UserColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<MockLanguage> _languages = const [];
  String _selected = 'en';

  @override
  void initState() {
    super.initState();
    loadLanguages().then((languages) {
      if (!mounted) return;
      setState(() => _languages = languages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          const KsTopBar(title: 'Choose your language'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'You can change this later in Settings.',
                    style: UserText.body.copyWith(color: UserColors.muted),
                  ),
                  const SizedBox(height: 14),
                  for (final language in _languages) ...[
                    _LanguageRow(
                      label: language.pickerLabel,
                      selected: language.code == _selected,
                      onTap: () => setState(() => _selected = language.code),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: KsButton(
              label: 'Continue',
              onPressed: () => _go(context, '/welcome'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: UserColors.surface1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UserRadii.card),
        side: BorderSide(
          color: selected ? UserColors.primary : UserColors.line,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UserRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Text(label, style: UserText.body),
              ),
              KsCheck(on: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = ref.watch(appConfigProvider).value?.homeBanners.firstOrNull;
    final fallback = const KsMediaBox(
      label: '[Hero image: real host collage – licensed photos]',
      height: 420,
      radius: 0,
      alignEnd: true,
      padding: EdgeInsets.all(24),
    );
    return Scaffold(
      body: Column(
        children: [
          if (banner == null)
            fallback
          else
            SizedBox(
              height: 420,
              width: double.infinity,
              child: KsCachedImage(
                url: banner.imageUrl,
                fallback: fallback,
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Meet real people,\nface to face', style: UserText.h1),
                  const SizedBox(height: 14),
                  Text(
                    'Verified hosts online now. First call free for new users.',
                    style: UserText.body.copyWith(color: UserColors.muted),
                  ),
                  const SizedBox(height: 14),
                  KsButton(
                    label: 'Continue instantly',
                    icon: KsIcons.zap,
                    onPressed: () => _go(context, '/onboarding/age'),
                  ),
                  const SizedBox(height: 14),
                  KsButton(
                    label: 'Continue with Google',
                    icon: KsIcons.globe,
                    background: UserColors.white,
                    foreground: UserColors.surface1,
                    onPressed: () => _go(context, '/onboarding/age'),
                  ),
                  const SizedBox(height: 14),
                  KsButton(
                    label: 'Continue with phone',
                    icon: KsIcons.phone,
                    background: Colors.transparent,
                    foreground: UserColors.text,
                    borderColor: UserColors.line,
                    onPressed: () => _go(context, '/onboarding/phone'),
                  ),
                  const SizedBox(height: 14),
                  Text.rich(
                    TextSpan(
                      style: UserText.xs.copyWith(
                        fontWeight: FontWeight.w400,
                        color: UserColors.muted,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'By continuing you confirm you are 18+ and agree to the ',
                        ),
                        TextSpan(
                          text: 'Terms',
                          style: UserText.xs.copyWith(
                            fontWeight: FontWeight.w400,
                            color: UserColors.primarySoft,
                            decoration: TextDecoration.underline,
                            decorationColor: UserColors.primarySoft,
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: UserText.xs.copyWith(
                            fontWeight: FontWeight.w400,
                            color: UserColors.primarySoft,
                            decoration: TextDecoration.underline,
                            decorationColor: UserColors.primarySoft,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
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

class PhoneScreen extends StatelessWidget {
  const PhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            leading: KsIconButton(
              icon: KsIcons.chevronLeft,
              onPressed: () => _go(context, '/welcome'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Your phone number', style: UserText.h1),
                  const SizedBox(height: 14),
                  Text(
                    "We'll send a 6-digit code by SMS.",
                    style: UserText.body.copyWith(color: UserColors.muted),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      KsField(
                        label: 'Code',
                        value: 'IN +91',
                        width: 110,
                        chevron: true,
                        onTap: () => _go(context, '/onboarding/country'),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: KsField(
                          label: 'Mobile number',
                          value: '98765 43210',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Standard SMS rates may apply.',
                    style: UserText.xs.copyWith(
                      fontWeight: FontWeight.w400,
                      color: UserColors.muted,
                    ),
                  ),
                  const Spacer(),
                  KsButton(
                    label: 'Send code',
                    onPressed: () => _go(context, '/onboarding/otp'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  static const _cells = ['4', '8', '2', '|', '', ''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            leading: KsIconButton(
              icon: KsIcons.chevronLeft,
              onPressed: () => _go(context, '/onboarding/phone'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Enter the code', style: UserText.h1),
                  const SizedBox(height: 14),
                  Text.rich(
                    TextSpan(
                      style: UserText.body.copyWith(color: UserColors.muted),
                      children: [
                        const TextSpan(text: 'Sent to +91 98765 43210 · '),
                        TextSpan(
                          text: 'Edit',
                          style: UserText.body.copyWith(
                            color: UserColors.primarySoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      for (var i = 0; i < _cells.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        _OtpCell(text: _cells[i], active: i == 3),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text.rich(
                    TextSpan(
                      style: UserText.small,
                      children: [
                        const TextSpan(text: 'Resend code in '),
                        TextSpan(
                          text: '0:24',
                          style: UserText.small.copyWith(
                            color: UserColors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _Note(
                    'Auto-read enabled: the code fills in automatically when the SMS arrives.',
                  ),
                  const Spacer(),
                  KsButton(
                    label: 'Verify',
                    onPressed: () => _go(context, '/onboarding/age'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpCell extends StatelessWidget {
  const _OtpCell({required this.text, required this.active});

  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: UserColors.surface2,
        borderRadius: BorderRadius.circular(UserRadii.note),
        border: Border.all(
          color: active ? UserColors.primary : UserColors.line,
          width: 1.5,
        ),
      ),
      child: Text(text, style: UserText.otp),
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
          style: UserText.small.copyWith(color: UserColors.noteText),
        ),
      ),
    );
  }
}

class CountryScreen extends StatelessWidget {
  const CountryScreen({super.key});

  static const _countries = [
    ('Bangladesh', '+880', false),
    ('India', '+91', true),
    ('Indonesia', '+62', false),
    ('Nepal', '+977', false),
    ('Pakistan', '+92', false),
    ('Philippines', '+63', false),
    ('Sri Lanka', '+94', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            leading: KsIconButton(
              icon: KsIcons.chevronLeft,
              onPressed: () => _go(context, '/onboarding/phone'),
            ),
            title: 'Select country code',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const KsField(label: 'Search country', placeholder: 'Search'),
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
                        Text(
                          'Detected from your network',
                          style: UserText.small,
                        ),
                        const Spacer(),
                        Text(
                          'India +91',
                          style: UserText.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'ALL COUNTRIES',
                    style: UserText.xs.copyWith(
                      fontWeight: FontWeight.w400,
                      color: UserColors.muted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final country in _countries)
                    _CountryRow(
                      name: country.$1,
                      dial: country.$2,
                      selected: country.$3,
                      onTap: () => _go(context, '/onboarding/phone'),
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

class _CountryRow extends StatelessWidget {
  const _CountryRow({
    required this.name,
    required this.dial,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String dial;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: UserColors.line)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(name, style: UserText.body)),
            Text(dial, style: UserText.body.copyWith(color: UserColors.muted)),
            if (selected) ...[
              const SizedBox(width: 12),
              const KsIcon(KsIcons.check),
            ],
          ],
        ),
      ),
    );
  }
}

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  var _adult = true;
  var _terms = true;
  var _offers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 68, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: UserColors.surface2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: KsIcon(KsIcons.shield, color: UserColors.gold),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text('Before you start', style: UserText.h1),
            const SizedBox(height: 14),
            Text(
              'Kinkstar Calls is for adults only. Nudity, harassment and sharing contact details are not allowed.',
              style: UserText.body.copyWith(color: UserColors.muted),
            ),
            const SizedBox(height: 14),
            const KsField(label: 'Date of birth', value: '14 / 03 / 1996'),
            const SizedBox(height: 14),
            _ConsentRow(
              on: _adult,
              onTap: () => setState(() => _adult = !_adult),
              text: const TextSpan(text: 'I confirm I am 18 or older'),
            ),
            const SizedBox(height: 14),
            _ConsentRow(
              on: _terms,
              onTap: () => setState(() => _terms = !_terms),
              text: TextSpan(
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms',
                    style: UserText.small.copyWith(
                      color: UserColors.primarySoft,
                      decoration: TextDecoration.underline,
                      decorationColor: UserColors.primarySoft,
                    ),
                  ),
                  const TextSpan(text: ', '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: UserText.small.copyWith(
                      color: UserColors.primarySoft,
                      decoration: TextDecoration.underline,
                      decorationColor: UserColors.primarySoft,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Community Rules',
                    style: UserText.small.copyWith(
                      color: UserColors.primarySoft,
                      decoration: TextDecoration.underline,
                      decorationColor: UserColors.primarySoft,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ConsentRow(
              on: _offers,
              onTap: () => setState(() => _offers = !_offers),
              text: const TextSpan(
                text: 'Send me offers and updates (optional)',
              ),
            ),
            const Spacer(),
            KsButton(
              label: 'Agree and continue',
              onPressed: () => _go(context, '/onboarding/profile'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.on,
    required this.onTap,
    required this.text,
  });

  final bool on;
  final VoidCallback onTap;
  final InlineSpan text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KsCheck(on: on),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(style: UserText.small.copyWith(color: UserColors.text), children: [text]),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MockUser? _user;

  @override
  void initState() {
    super.initState();
    loadUser().then((user) {
      if (!mounted) return;
      setState(() => _user = user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final spoken = user?.languages.toSet() ?? {'hi', 'en'};
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            title: 'Set up your profile',
            trailing: GestureDetector(
              onTap: () => _go(context, '/onboarding/permissions'),
              child: Text('Skip', style: UserText.small),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Center(
                            child: Container(
                              width: 88,
                              height: 88,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: UserColors.avatar,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                user?.initial ?? 'R',
                                style: UserText.avatarLarge,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 2,
                            bottom: 2,
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
                  KsField(
                    label: 'Nickname',
                    value: user?.username ?? 'Rahul_K',
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'I want to talk in',
                    style: UserText.small,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final chip in _talk)
                        KsChip(label: chip.$1, on: spoken.contains(chip.$2)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Interests (helps us suggest hosts)',
                    style: UserText.small,
                  ),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      KsChip(label: 'Music', on: true),
                      KsChip(label: 'Movies'),
                      KsChip(label: 'Travel', on: true),
                      KsChip(label: 'Fitness'),
                      KsChip(label: 'Cricket'),
                      KsChip(label: 'Cooking'),
                    ],
                  ),
                  const Spacer(),
                  KsButton(
                    label: 'Save and continue',
                    onPressed: () => _go(context, '/onboarding/permissions'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _talk = [
  ('Hindi', 'hi'),
  ('English', 'en'),
  ('Tamil', 'ta'),
  ('Bengali', 'bn'),
  ('Telugu', 'te'),
];

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 68, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Turn on calls', style: UserText.h1),
            const SizedBox(height: 14),
            Text(
              'We ask only when needed. You can change these anytime.',
              style: UserText.body.copyWith(color: UserColors.muted),
            ),
            const SizedBox(height: 14),
            const _PermissionRow(
              icon: KsIcons.camera,
              title: 'Camera',
              detail: 'For video calls',
              on: true,
            ),
            const SizedBox(height: 14),
            const _PermissionRow(
              icon: KsIcons.mic,
              title: 'Microphone',
              detail: 'For voice and video calls',
              on: true,
            ),
            const SizedBox(height: 14),
            const _PermissionRow(
              icon: KsIcons.bell,
              title: 'Notifications',
              detail: 'Know when hosts you follow are online',
              on: false,
            ),
            const SizedBox(height: 14),
            const _PermissionRow(
              icon: KsIcons.phone,
              title: 'Full-screen call alerts',
              detail: 'Ring when a host calls you back',
              on: false,
            ),
            const Spacer(),
            KsButton(
              label: 'Allow',
              onPressed: () => _go(context, '/onboarding/guide'),
            ),
            const SizedBox(height: 14),
            KsButton(
              label: 'Not now',
              background: Colors.transparent,
              foreground: UserColors.text,
              borderColor: UserColors.line,
              onPressed: () => _go(context, '/onboarding/guide'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.on,
  });

  final IconData icon;
  final String title;
  final String detail;
  final bool on;

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
          KsIconButton(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: UserText.body.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  detail,
                  style: UserText.xs.copyWith(
                    fontWeight: FontWeight.w400,
                    color: UserColors.muted,
                  ),
                ),
              ],
            ),
          ),
          KsSwitch(on: on),
        ],
      ),
    );
  }
}

class GuideScreen extends ConsumerWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(appConfigProvider).value?.tabs ??
        const [
          ConfigTab(id: 'discover', label: 'Discover', enabled: true),
          ConfigTab(id: 'match', label: 'Match', enabled: true),
          ConfigTab(id: 'live', label: 'Live', enabled: true),
          ConfigTab(id: 'messages', label: 'Messages', enabled: true),
          ConfigTab(id: 'me', label: 'Me', enabled: true),
        ];
    final title = ref.watch(appConfigProvider).value?.string('U01_title') ?? 'Discover';
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
            children: [
              const SizedBox(height: UserSpace.statusBar),
              KsTopBar(
                title: title,
                trailing: const KsChip(label: '0', gold: true, icon: KsIcons.gem),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: (390 - 32 - 12) / 2 / 230,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      KsMediaBox(label: 'Host', height: 230),
                      KsMediaBox(label: 'Host', height: 230),
                      KsMediaBox(label: 'Host', height: 230),
                      KsMediaBox(label: 'Host', height: 230),
                    ],
                  ),
                ),
              ),
              _TabBar(tabs: tabs),
            ],
          ),
          ),
          const Positioned.fill(child: ColoredBox(color: UserColors.dim)),
          Positioned(
            left: 24,
            top: 120,
            child: Container(
              width: 160,
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UserRadii.card),
                border: Border.all(color: UserColors.gold, width: 3),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 380,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: UserColors.white,
                borderRadius: BorderRadius.circular(UserRadii.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1 of 3 · Tap a host to see her profile',
                    style: UserText.h2.copyWith(color: UserColors.surface1),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Green dot = online now. Price per minute is shown before every call.',
                    style: UserText.small.copyWith(color: UserColors.coachBody),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Skip tour',
                        style: UserText.small.copyWith(
                          color: UserColors.coachSkip,
                          decoration: TextDecoration.underline,
                          decorationColor: UserColors.coachSkip,
                        ),
                      ),
                      const Spacer(),
                      KsButton(
                        label: 'Next',
                        minHeight: UserSpace.buttonSm,
                        textStyle: UserText.buttonSm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 96,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: UserColors.gold,
                borderRadius: BorderRadius.circular(UserRadii.card),
              ),
              child: Text.rich(
                TextSpan(
                  style: UserText.body.copyWith(color: UserColors.goldInk),
                  children: const [
                    TextSpan(
                      text: 'Your first call is free',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: ' · up to 60 seconds with any host marked "Free call"',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.tabs});

  final List<ConfigTab> tabs;

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
                  color: tab.id == 'discover'
                      ? UserColors.primarySoft
                      : UserColors.muted,
                ),
                const SizedBox(height: 2),
                Text(
                  // The artboard prints "Home" on the first tab. Config's
                  // discover tab label is "Discover", which is the page title.
                  tab.id == 'discover' ? 'Home' : tab.label,
                  style: UserText.tab.copyWith(
                    color: tab.id == 'discover'
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
