// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import 'onboarding/screens.dart';
import 'wallet/screens.dart';

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
        path: '/wallet',
        name: 'wallet',
        builder: (context, state) => const DiamondStoreScreen(),
      ),
      GoRoute(
        path: '/wallet/pay',
        name: 'walletPay',
        builder: (context, state) => const PayMethodScreen(),
      ),
      GoRoute(
        path: '/wallet/success',
        name: 'walletSuccess',
        builder: (context, state) => const RechargeSuccessScreen(),
      ),
      GoRoute(
        path: '/wallet/offer',
        name: 'walletOffer',
        builder: (context, state) => const FirstOfferScreen(),
      ),
      GoRoute(
        path: '/wallet/vip',
        name: 'walletVip',
        builder: (context, state) => const VipScreen(),
      ),
      GoRoute(
        path: '/wallet/history',
        name: 'walletHistory',
        builder: (context, state) => const WalletHistoryScreen(),
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
