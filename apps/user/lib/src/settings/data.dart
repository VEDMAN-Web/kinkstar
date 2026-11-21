import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Profile and version values that match the settings artboards.
/// Contradictions stay as artboard copy and are listed in the pull request.
class SettingsData {
  const SettingsData({
    required this.username,
    required this.diamonds,
    required this.version,
    required this.spoken,
  });

  static const fallback = SettingsData(
    username: 'Rahul_K',
    diamonds: 120,
    version: '1.0.0',
    spoken: ['Hindi', 'English'],
  );

  final String username;
  final int diamonds;
  final String version;
  final List<String> spoken;
}

Future<SettingsData> loadSettings() async {
  final profile = jsonDecode(
    await rootBundle.loadString('assets/mock/user_profile.json'),
  ) as Map<String, dynamic>;
  final languages = jsonDecode(
    await rootBundle.loadString('assets/mock/languages.json'),
  ) as List<dynamic>;
  final config = jsonDecode(
    await rootBundle.loadString('assets/mock/config.json'),
  ) as Map<String, dynamic>;
  final names = {
    for (final item in languages)
      (item as Map<String, dynamic>)['code'] as String: item['name'] as String,
  };
  final codes = (profile['languages'] as List<dynamic>).cast<String>();
  return SettingsData(
    username: profile['username'] as String,
    diamonds: profile['diamondBalance'] as int,
    version: config['version'] as String,
    spoken: [for (final code in codes) names[code] ?? code],
  );
}

final settingsProvider = FutureProvider<SettingsData>((ref) => loadSettings());
