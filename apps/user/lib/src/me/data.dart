import 'dart:convert';

import 'package:flutter/services.dart';

/// Profile and Aria values that match the artboards. Contradictions stay as
/// artboard copy in the screens and are listed in the pull request.
class MeData {
  const MeData({
    required this.username,
    required this.diamonds,
    required this.level,
    required this.spent,
    required this.goal,
    required this.nextLevel,
    required this.percent,
    required this.vip,
    required this.ariaName,
    required this.ariaLabel,
    required this.ariaLanguages,
    required this.ariaVideo,
  });

  static const fallback = MeData(
    username: 'Rahul_K',
    diamonds: 120,
    level: 2,
    spent: 320,
    goal: 500,
    nextLevel: 3,
    percent: 64,
    vip: false,
    ariaName: 'Aria',
    ariaLabel: 'AI companion',
    ariaLanguages: 'Hindi, English',
    ariaVideo: 15,
  );

  final String username;
  final int diamonds;
  final int level;
  final int spent;
  final int goal;
  final int nextLevel;
  final int percent;
  final bool vip;
  final String ariaName;
  final String ariaLabel;
  final String ariaLanguages;
  final int ariaVideo;
}

Future<MeData> loadMe() async {
  final profile = jsonDecode(
    await rootBundle.loadString('assets/mock/user_profile.json'),
  ) as Map<String, dynamic>;
  final hosts = jsonDecode(
    await rootBundle.loadString('assets/mock/hosts.json'),
  ) as List<dynamic>;
  final languages = jsonDecode(
    await rootBundle.loadString('assets/mock/languages.json'),
  ) as List<dynamic>;
  final names = {
    for (final item in languages)
      (item as Map<String, dynamic>)['code'] as String: item['name'] as String,
  };
  final progress = profile['levelProgress'] as Map<String, dynamic>;
  final aria = hosts.cast<Map<String, dynamic>>().firstWhere(
    (host) => host['id'] == 'host_aria',
  );
  final codes = (aria['languages'] as List<dynamic>).cast<String>();
  return MeData(
    username: profile['username'] as String,
    diamonds: profile['diamondBalance'] as int,
    level: profile['level'] as int,
    spent: progress['current'] as int,
    goal: progress['required'] as int,
    nextLevel: progress['nextLevel'] as int,
    percent: progress['percent'] as int,
    vip: (profile['vip'] as Map<String, dynamic>)['active'] as bool,
    ariaName: aria['name'] as String,
    ariaLabel: aria['label'] as String? ?? 'AI companion',
    ariaLanguages: codes.map((code) => names[code] ?? code).join(', '),
    ariaVideo: aria['videoRatePerMin'] as int,
  );
}
