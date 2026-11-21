import 'dart:convert';

import 'package:flutter/services.dart';

class MockHost {
  const MockHost({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.languages,
    required this.rating,
    required this.callsCount,
    required this.followers,
    required this.charmLevel,
    required this.videoRatePerMin,
    required this.voiceRatePerMin,
    required this.status,
    required this.isAI,
    required this.label,
  });

  final String id;
  final String name;
  final int? age;
  final String? city;
  final List<String> languages;
  final double? rating;
  final int callsCount;
  final int followers;
  final int? charmLevel;
  final int videoRatePerMin;
  final int voiceRatePerMin;
  final String status;
  final bool isAI;
  final String? label;

  factory MockHost.fromJson(Map<String, dynamic> json) {
    return MockHost(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int?,
      city: json['city'] as String?,
      languages: [
        for (final code in json['languages'] as List<dynamic>) code as String,
      ],
      rating: (json['rating'] as num?)?.toDouble(),
      callsCount: json['callsCount'] as int,
      followers: json['followers'] as int,
      charmLevel: json['charmLevel'] as int?,
      videoRatePerMin: json['videoRatePerMin'] as int,
      voiceRatePerMin: json['voiceRatePerMin'] as int,
      status: json['status'] as String,
      isAI: json['isAI'] as bool,
      label: json['label'] as String?,
    );
  }
}

class DiscoverData {
  const DiscoverData({
    required this.hosts,
    required this.languageNames,
    required this.diamonds,
    required this.giftName,
  });

  final List<MockHost> hosts;
  final Map<String, String> languageNames;
  final int diamonds;
  final String giftName;

  MockHost host(String id) {
    return hosts.firstWhere((item) => item.id == id, orElse: () => hosts.first);
  }

  String languageList(List<String> codes, {String separator = ' · '}) {
    return [for (final code in codes) languageNames[code] ?? code]
        .join(separator);
  }
}

Future<DiscoverData> loadDiscover() async {
  final hostsRaw = await rootBundle.loadString('assets/mock/hosts.json');
  final languagesRaw = await rootBundle.loadString(
    'assets/mock/languages.json',
  );
  final profileRaw = await rootBundle.loadString(
    'assets/mock/user_profile.json',
  );
  final giftsRaw = await rootBundle.loadString('assets/mock/gifts.json');
  final hosts = [
    for (final item in jsonDecode(hostsRaw) as List<dynamic>)
      MockHost.fromJson(item as Map<String, dynamic>),
  ];
  final languageNames = {
    for (final item in jsonDecode(languagesRaw) as List<dynamic>)
      (item as Map<String, dynamic>)['code'] as String: item['name'] as String,
  };
  final profile = jsonDecode(profileRaw) as Map<String, dynamic>;
  final gifts = jsonDecode(giftsRaw) as List<dynamic>;
  final rose = gifts.cast<Map<String, dynamic>>().firstWhere(
    (gift) => gift['id'] == 'gift_rose',
    orElse: () => gifts.first as Map<String, dynamic>,
  );
  return DiscoverData(
    hosts: hosts,
    languageNames: languageNames,
    diamonds: profile['diamondBalance'] as int,
    giftName: rose['name'] as String,
  );
}

/// `2400` becomes `2.4k`. Counts under 1000 stay as digits.
String compactCount(int value) {
  if (value < 1000) return '$value';
  final scaled = value / 1000;
  final text = scaled.toStringAsFixed(1);
  return text.endsWith('.0')
      ? '${text.substring(0, text.length - 2)}k'
      : '${text}k';
}
