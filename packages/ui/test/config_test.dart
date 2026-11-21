import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

void main() {
  test('bundled config.json matches mock/config.json byte for byte', () {
    final bundled = File('assets/config/config.json').readAsBytesSync();
    final source = File('../../mock/config.json').readAsBytesSync();
    expect(bundled, source);
  });

  test('bundled config.json matches the mock config shape', () {
    final raw = File('assets/config/config.json').readAsStringSync();
    final config = AppConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    expect(config.version, '1.0.0');
    expect(config.assetBaseUrl, 'https://cdn.example.com/kinkstar/');
    expect(config.string('U01_title'), 'Discover');
    expect(config.string('U01_title', languageCode: 'hi'), 'खोजें');
    expect(config.string('U48_lowBalance'), 'Less than a minute of balance left');
    expect(config.rechargePackIds, [
      'pack_100',
      'pack_300',
      'pack_700',
      'pack_1500',
      'pack_4000',
      'pack_9000',
    ]);
    expect(config.homeBanners, hasLength(2));
    expect(config.homeBanners.first.deeplink, 'kinkstar://recharge');
    expect(config.homeBanners.first.serverDriven, isTrue);
    expect(config.tabs.map((tab) => tab.id), [
      'discover',
      'match',
      'live',
      'messages',
      'me',
    ]);
    expect(config.features.quickMatch, isTrue);
    expect(config.features.liveRooms, isTrue);
    expect(config.features.aiCompanion, isTrue);
    expect(config.features.vip, isTrue);
    expect(config.features.chatPaidMessages, isTrue);
    expect(config.features.forceUpdateMinVersion, '1.2.0');
    expect(config.features.maintenanceOn, isFalse);
    expect(config.limits.freeMatchesPerDay, 3);
    expect(config.limits.freeMessagesPerHost, 3);
    expect(config.limits.lowBalanceWarningSec, 60);
    expect(
      config.assetUrl('banners/recharge.png'),
      'https://cdn.example.com/kinkstar/banners/recharge.png',
    );
  });
}
