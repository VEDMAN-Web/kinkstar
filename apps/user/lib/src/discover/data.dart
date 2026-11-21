import 'dart:convert';

import 'package:flutter/services.dart';

class HostGallery {
  const HostGallery({
    required this.profileIndex,
    required this.viewerIndex,
    required this.count,
    required this.tiles,
    required this.viewerLabel,
  });

  final int profileIndex;
  final int viewerIndex;
  final int count;
  final List<String> tiles;
  final String viewerLabel;

  String get profileLabel => '$profileIndex / $count';

  String get viewerCountLabel => '$viewerIndex / $count';

  factory HostGallery.fromJson(Map<String, dynamic> json) {
    final tiles = [
      for (final tile in json['tiles'] as List<dynamic>)
        (tile as Map<String, dynamic>)['label'] as String,
    ];
    final more = json['moreLabel'] as String?;
    return HostGallery(
      profileIndex: json['profileIndex'] as int,
      viewerIndex: json['viewerIndex'] as int,
      count: json['count'] as int,
      tiles: [...tiles, ?more],
      viewerLabel: json['viewerLabel'] as String,
    );
  }
}

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
    required this.subtitle,
    required this.bio,
    required this.verified,
    required this.freeCall,
    required this.topGiftId,
    required this.topGiftCount,
    required this.gallery,
  });

  final String id;
  final String name;
  final int? age;
  final String? city;
  final List<String> languages;
  final double? rating;
  final int? callsCount;
  final int? followers;
  final int? charmLevel;
  final int videoRatePerMin;
  final int? voiceRatePerMin;
  final String status;
  final bool isAI;
  final String? label;
  final String? subtitle;
  final String? bio;
  final bool verified;
  final bool freeCall;
  final String? topGiftId;
  final int? topGiftCount;
  final HostGallery? gallery;

  /// U11 prints `Aria (AI)` from the name plus [isAI].
  String get cardName => isAI ? '$name (AI)' : '$name, $age';

  factory MockHost.fromJson(Map<String, dynamic> json) {
    final gift = json['topGift'] as Map<String, dynamic>?;
    final gallery = json['gallery'] as Map<String, dynamic>?;
    return MockHost(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int?,
      city: json['city'] as String?,
      languages: [
        for (final code in json['languages'] as List<dynamic>) code as String,
      ],
      rating: (json['rating'] as num?)?.toDouble(),
      callsCount: json['callsCount'] as int?,
      followers: json['followers'] as int?,
      charmLevel: json['charmLevel'] as int?,
      videoRatePerMin: json['videoRatePerMin'] as int,
      voiceRatePerMin: json['voiceRatePerMin'] as int?,
      status: json['status'] as String,
      isAI: json['isAI'] as bool,
      label: json['label'] as String?,
      subtitle: json['subtitle'] as String?,
      bio: json['bio'] as String?,
      verified: json['verified'] as bool? ?? false,
      freeCall: json['freeCall'] as bool? ?? false,
      topGiftId: gift?['giftId'] as String?,
      topGiftCount: gift?['count'] as int?,
      gallery: gallery == null ? null : HostGallery.fromJson(gallery),
    );
  }
}

class DiscoverChip {
  const DiscoverChip({required this.label, required this.selected});

  final String label;
  final bool selected;
}

class DiscoverGroup {
  const DiscoverGroup({required this.label, required this.options});

  final String label;
  final List<DiscoverChip> options;
}

class DiscoverBadges {
  const DiscoverBadges({
    required this.online,
    required this.inCall,
    required this.freeCall,
    required this.verified,
  });

  final String online;
  final String inCall;
  final String freeCall;
  final String verified;
}

class DiscoverData {
  const DiscoverData({
    required this.hosts,
    required this.languageNames,
    required this.diamonds,
    required this.giftNames,
    required this.cardHostIds,
    required this.chips,
    required this.badges,
    required this.filtersTitle,
    required this.filtersReset,
    required this.filterGroups,
    required this.submitLabel,
    required this.chatLabel,
    required this.videoCallLabel,
    required this.liveCallTemplate,
    required this.promoTitle,
    required this.promoDetail,
    required this.promoCta,
  });

  final List<MockHost> hosts;
  final Map<String, String> languageNames;
  final int diamonds;
  final Map<String, String> giftNames;
  final List<String> cardHostIds;
  final List<DiscoverChip> chips;
  final DiscoverBadges badges;
  final String filtersTitle;
  final String filtersReset;
  final List<DiscoverGroup> filterGroups;
  final String submitLabel;
  final String chatLabel;
  final String videoCallLabel;
  final String liveCallTemplate;
  final String promoTitle;
  final String promoDetail;
  final String promoCta;

  MockHost host(String id) {
    return hosts.firstWhere((item) => item.id == id, orElse: () => hosts.first);
  }

  String languageList(List<String> codes, {String separator = ' · '}) {
    return [for (final code in codes) languageNames[code] ?? code]
        .join(separator);
  }

  String giftName(String? id) => giftNames[id] ?? giftNames.values.first;

  String liveCall(String name, int rate) {
    return liveCallTemplate
        .replaceAll(r'$name', name)
        .replaceAll(r'$rate', '$rate');
  }

  String cardDetail(MockHost host) {
    return host.subtitle ?? languageList(host.languages);
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
  final configRaw = await rootBundle.loadString(
    'packages/kinkstar_ui/assets/config/config.json',
  );
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
  final giftNames = {
    for (final item in gifts)
      (item as Map<String, dynamic>)['id'] as String: item['name'] as String,
  };
  final config = jsonDecode(configRaw) as Map<String, dynamic>;
  final discover = config['discover'] as Map<String, dynamic>;
  final badges = discover['badges'] as Map<String, dynamic>;
  final filters = discover['filters'] as Map<String, dynamic>;
  final profileCopy = discover['profile'] as Map<String, dynamic>;
  final viewer = discover['viewer'] as Map<String, dynamic>;
  final banners = config['homeBanners'] as List<dynamic>;
  final banner = banners.cast<Map<String, dynamic>>().firstWhere(
    (item) => item['id'] == 'banner_recharge',
  );
  return DiscoverData(
    hosts: hosts,
    languageNames: languageNames,
    diamonds: profile['diamondBalance'] as int,
    giftNames: giftNames,
    cardHostIds: (discover['cardHostIds'] as List<dynamic>).cast<String>(),
    chips: [
      for (final item in discover['chips'] as List<dynamic>)
        DiscoverChip(
          label: (item as Map<String, dynamic>)['label'] as String,
          selected: item['selected'] as bool,
        ),
    ],
    badges: DiscoverBadges(
      online: badges['online'] as String,
      inCall: badges['inCall'] as String,
      freeCall: badges['freeCall'] as String,
      verified: badges['verified'] as String,
    ),
    filtersTitle: filters['title'] as String,
    filtersReset: filters['resetLabel'] as String,
    filterGroups: [
      for (final group in filters['groups'] as List<dynamic>)
        DiscoverGroup(
          label: (group as Map<String, dynamic>)['label'] as String,
          options: [
            for (final option in group['options'] as List<dynamic>)
              DiscoverChip(
                label: (option as Map<String, dynamic>)['label'] as String,
                selected: option['selected'] as bool,
              ),
          ],
        ),
    ],
    submitLabel: filters['submitLabel'] as String,
    chatLabel: profileCopy['chatLabel'] as String,
    videoCallLabel: profileCopy['videoCallLabel'] as String,
    liveCallTemplate: viewer['liveCallLabel'] as String,
    promoTitle: banner['title'] as String,
    promoDetail: banner['detail'] as String,
    promoCta: banner['cta'] as String,
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
