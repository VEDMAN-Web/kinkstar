import 'dart:convert';

import 'package:flutter/services.dart';

/// Values the artboard and the mock agree on. Everything else on U19–U21
/// and U42 is artboard copy, because the mock has no threads or notices.
class MessagesData {
  const MessagesData({
    required this.priya,
    required this.aria,
    required this.diamonds,
    required this.freeLeft,
    required this.priceAfter,
    required this.gifts,
  });

  final String priya;
  final String aria;
  final int diamonds;
  final int freeLeft;
  final int priceAfter;
  final Map<String, (String, int)> gifts;

  String giftName(String id, String fallback) => gifts[id]?.$1 ?? fallback;

  int giftPrice(String id, int fallback) => gifts[id]?.$2 ?? fallback;

  static const fallback = MessagesData(
    priya: 'Priya',
    aria: 'Aria',
    diamonds: 120,
    freeLeft: 3,
    priceAfter: 5,
    gifts: {},
  );
}

Future<MessagesData> loadMessages() async {
  final hostsRaw = await rootBundle.loadString('assets/mock/hosts.json');
  final profileRaw = await rootBundle.loadString(
    'assets/mock/user_profile.json',
  );
  final hosts = jsonDecode(hostsRaw) as List<dynamic>;
  final profile = jsonDecode(profileRaw) as Map<String, dynamic>;
  String name(String id, String fallback) {
    for (final item in hosts) {
      final host = item as Map<String, dynamic>;
      if (host['id'] == id) return host['name'] as String;
    }
    return fallback;
  }

  final free = profile['freeMessages'] as Map<String, dynamic>;
  final giftsRaw = jsonDecode(
    await rootBundle.loadString('assets/mock/gifts.json'),
  ) as List<dynamic>;
  return MessagesData(
    priya: name('host_priya', MessagesData.fallback.priya),
    aria: name('host_aria', MessagesData.fallback.aria),
    diamonds: profile['diamondBalance'] as int,
    freeLeft: free['left'] as int,
    priceAfter: free['priceAfter'] as int,
    gifts: {
      for (final item in giftsRaw)
        (item as Map<String, dynamic>)['id'] as String: (
          item['name'] as String,
          item['price'] as int,
        ),
    },
  );
}
