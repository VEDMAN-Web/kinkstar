import 'dart:io';

// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';
import 'package:kinkstar_user/src/onboarding/screens.dart';

import '../../../tool/capture_frame.dart';

void main() {
  final screens = <String, Widget>{
    'U01': const SplashScreen(),
    'U02': const LanguageScreen(),
    'U03': const WelcomeScreen(),
    'U04': const PhoneScreen(),
    'U05': const OtpScreen(),
    'U06': const CountryScreen(),
    'U07': const AgeScreen(),
    'U08': const ProfileScreen(),
    'U09': const PermissionsScreen(),
    'U10': const GuideScreen(),
  };

  for (final entry in screens.entries) {
    testWidgets('writes a 780x1688 capture of ${entry.key}', (tester) async {
      final file = await captureFrame(
        tester,
        widget: ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: UserTheme.data,
            home: entry.value,
          ),
        ),
        outputPath: '../../design/compare/${entry.key}_build.png',
      );
      final bytes = file.readAsBytesSync();
      expect(bytes[0], 0x89);
      final width =
          (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
      final height =
          (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
      expect(width, 780);
      expect(height, 1688);
    }, timeout: const Timeout(Duration(seconds: 30)));
  }

  test('copied mock files match mock/ byte for byte', () {
    expect(
      File('assets/mock/languages.json').readAsBytesSync(),
      File('../../mock/languages.json').readAsBytesSync(),
    );
    expect(
      File('assets/mock/user_profile.json').readAsBytesSync(),
      File('../../mock/user_profile.json').readAsBytesSync(),
    );
  });
}
