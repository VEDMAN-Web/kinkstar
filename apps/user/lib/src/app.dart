// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import 'onboarding/screens.dart';
import 'settings/screens.dart';

class UserApp extends StatefulWidget {
  const UserApp({super.key});

  @override
  State<UserApp> createState() => _UserAppState();
}

class _UserAppState extends State<UserApp> {
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const KsPlaceholderHome(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding/language',
        name: 'language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/phone',
        name: 'phone',
        builder: (context, state) => const PhoneScreen(),
      ),
      GoRoute(
        path: '/onboarding/otp',
        name: 'otp',
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/onboarding/country',
        name: 'country',
        builder: (context, state) => const CountryScreen(),
      ),
      GoRoute(
        path: '/onboarding/age',
        name: 'age',
        builder: (context, state) => const AgeScreen(),
      ),
      GoRoute(
        path: '/onboarding/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/onboarding/permissions',
        name: 'permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: '/onboarding/guide',
        name: 'guide',
        builder: (context, state) => const GuideScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/profile',
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings/blocked',
        name: 'blocked',
        builder: (context, state) => const BlockedScreen(),
      ),
      GoRoute(
        path: '/settings/language',
        name: 'appLanguage',
        builder: (context, state) => const AppLanguageScreen(),
      ),
      GoRoute(
        path: '/settings/help',
        name: 'help',
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: '/settings/report',
        name: 'report',
        builder: (context, state) => const ReportScreen(),
      ),
      GoRoute(
        path: '/settings/rate',
        name: 'rate',
        builder: (context, state) => const RateScreen(),
      ),
      GoRoute(
        path: '/settings/about',
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/settings/delete-account',
        name: 'deleteAccount',
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: '/force-update',
        name: 'forceUpdate',
        builder: (context, state) => const ForceUpdateScreen(),
      ),
      GoRoute(
        path: '/offline',
        name: 'offline',
        builder: (context, state) => const OfflineScreen(),
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kinkstar Calls',
      debugShowCheckedModeBanner: false,
      theme: UserTheme.data,
      routerConfig: _router,
    );
  }
}
