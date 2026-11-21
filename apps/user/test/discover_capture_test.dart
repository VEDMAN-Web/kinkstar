import 'dart:io';

// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';
import 'package:kinkstar_user/src/discover/screens.dart';

import '../../../tool/capture_frame.dart';

void main() {
  final screens = <String, Widget>{
    'U11': const DiscoverScreen(),
    'U12': const FilterScreen(),
    'U13': const HostProfileScreen(hostId: 'host_priya'),
    'U14': const HostMediaScreen(hostId: 'host_priya'),
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
    for (final name in ['hosts.json', 'gifts.json']) {
      expect(
        File('assets/mock/$name').readAsBytesSync(),
        File('../../mock/$name').readAsBytesSync(),
      );
    }
    expect(
      File('../../packages/ui/assets/config/config.json').readAsBytesSync(),
      File('../../mock/config.json').readAsBytesSync(),
    );
  });
}
