// Shape of mock/config.json on main. This file parses that object.
// It does not add fields the JSON does not have. Pack prices, hosts, and
// ledger rows live in the other files under mock/ and are not loaded here.

/// Local stand-in for the remote app config.
class AppConfig {
  const AppConfig({
    required this.version,
    required this.assetBaseUrl,
    required this.strings,
    required this.rechargePackIds,
    required this.homeBanners,
    required this.tabs,
    required this.features,
    required this.limits,
  });

  final String version;
  final String assetBaseUrl;

  /// Copy keyed by string id, then by language code (`en`, `hi`, …).
  final Map<String, Map<String, String>> strings;
  final List<String> rechargePackIds;
  final List<HomeBanner> homeBanners;
  final List<ConfigTab> tabs;
  final AppFeatures features;
  final AppLimits limits;

  /// [languageCode] defaults to `en` because the design's first-run picker
  /// pre-selects English. The JSON itself has no default-language field.
  String string(String key, {String languageCode = 'en'}) {
    final translations = strings[key];
    if (translations == null) {
      return key;
    }
    return translations[languageCode] ?? translations['en'] ?? key;
  }

  /// Prefixes a relative media path with [assetBaseUrl]. Absolute URLs
  /// are returned unchanged.
  String assetUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final base = assetBaseUrl.endsWith('/')
        ? assetBaseUrl
        : '$assetBaseUrl/';
    final relative = path.startsWith('/') ? path.substring(1) : path;
    return '$base$relative';
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      version: json['version'] as String,
      assetBaseUrl: json['assetBaseUrl'] as String,
      strings: _stringTable(json['strings']),
      rechargePackIds: (json['rechargePackIds'] as List<dynamic>)
          .cast<String>(),
      homeBanners: (json['homeBanners'] as List<dynamic>)
          .map((item) => HomeBanner.fromJson(item as Map<String, dynamic>))
          .toList(),
      tabs: (json['tabs'] as List<dynamic>)
          .map((item) => ConfigTab.fromJson(item as Map<String, dynamic>))
          .toList(),
      features: AppFeatures.fromJson(json['features'] as Map<String, dynamic>),
      limits: AppLimits.fromJson(json['limits'] as Map<String, dynamic>),
    );
  }
}

class HomeBanner {
  const HomeBanner({
    required this.id,
    required this.imageUrl,
    required this.deeplink,
    required this.startAt,
    required this.endAt,
    required this.serverDriven,
  });

  final String id;
  final String imageUrl;
  final String deeplink;
  final DateTime startAt;
  final DateTime endAt;
  final bool serverDriven;

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      deeplink: json['deeplink'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      serverDriven: json['serverDriven'] as bool,
    );
  }
}

class ConfigTab {
  const ConfigTab({
    required this.id,
    required this.label,
    required this.enabled,
  });

  final String id;
  final String label;
  final bool enabled;

  factory ConfigTab.fromJson(Map<String, dynamic> json) {
    return ConfigTab(
      id: json['id'] as String,
      label: json['label'] as String,
      enabled: json['enabled'] as bool,
    );
  }
}

class AppFeatures {
  const AppFeatures({
    required this.quickMatch,
    required this.liveRooms,
    required this.aiCompanion,
    required this.vip,
    required this.chatPaidMessages,
    required this.forceUpdateMinVersion,
    required this.maintenanceOn,
    required this.maintenanceMessage,
  });

  final bool quickMatch;
  final bool liveRooms;
  final bool aiCompanion;

  /// Whether VIP plans can be shown. Not the signed-in user's VIP state.
  final bool vip;
  final bool chatPaidMessages;
  final String forceUpdateMinVersion;
  final bool maintenanceOn;
  final Map<String, String> maintenanceMessage;

  String maintenanceCopy({String languageCode = 'en'}) {
    return maintenanceMessage[languageCode] ??
        maintenanceMessage['en'] ??
        '';
  }

  factory AppFeatures.fromJson(Map<String, dynamic> json) {
    final forceUpdate = json['forceUpdate'] as Map<String, dynamic>;
    final maintenance = json['maintenance'] as Map<String, dynamic>;
    return AppFeatures(
      quickMatch: json['quickMatch'] as bool,
      liveRooms: json['liveRooms'] as bool,
      aiCompanion: json['aiCompanion'] as bool,
      vip: json['vip'] as bool,
      chatPaidMessages: json['chatPaidMessages'] as bool,
      forceUpdateMinVersion: forceUpdate['minVersion'] as String,
      maintenanceOn: maintenance['on'] as bool,
      maintenanceMessage: (maintenance['message'] as Map<String, dynamic>).map(
        (code, text) => MapEntry(code, text as String),
      ),
    );
  }
}

class AppLimits {
  const AppLimits({
    required this.freeMatchesPerDay,
    required this.freeMessagesPerHost,
    required this.lowBalanceWarningSec,
  });

  final int freeMatchesPerDay;
  final int freeMessagesPerHost;
  final int lowBalanceWarningSec;

  factory AppLimits.fromJson(Map<String, dynamic> json) {
    return AppLimits(
      freeMatchesPerDay: json['freeMatchesPerDay'] as int,
      freeMessagesPerHost: json['freeMessagesPerHost'] as int,
      lowBalanceWarningSec: json['lowBalanceWarningSec'] as int,
    );
  }
}

Map<String, Map<String, String>> _stringTable(Object? raw) {
  final map = raw as Map<String, dynamic>;
  return map.map((key, value) {
    final langs = (value as Map<String, dynamic>).map(
      (code, text) => MapEntry(code, text as String),
    );
    return MapEntry(key, langs);
  });
}
