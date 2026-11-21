// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import 'me/screens.dart';
import 'onboarding/screens.dart';

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
        path: '/me',
        name: 'me',
        builder: (context, state) => const MeScreen(),
      ),
      GoRoute(
        path: '/me/level',
        name: 'level',
        builder: (context, state) => const LevelScreen(),
      ),
      GoRoute(
        path: '/me/check-in',
        name: 'checkIn',
        builder: (context, state) => const CheckInScreen(),
      ),
      GoRoute(
        path: '/me/events',
        name: 'events',
        builder: (context, state) => const EventsScreen(),
      ),
      GoRoute(
        path: '/me/refer',
        name: 'refer',
        builder: (context, state) => const ReferScreen(),
      ),
      GoRoute(
        path: '/ai/:hostId',
        name: 'ai',
        builder: (context, state) => const AiProfileScreen(),
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
