import 'dart:convert';

import 'package:flutter/services.dart';

/// Values the Match artboards share with `mock/`. Everything else on U15–U18
/// is artboard copy, listed in the pull request.
class MatchData {
  const MatchData({
    required this.diamonds,
    required this.freeLeft,
    required this.freeTotal,
    required this.languages,
  });

  /// Shown until the JSON load finishes. These match `user_profile.json`.
  static const fallback = MatchData(
    diamonds: 120,
    freeLeft: 2,
    freeTotal: 3,
    languages: ['Hindi', 'English'],
  );

  final int diamonds;
  final int freeLeft;
  final int freeTotal;
  final List<String> languages;
}

Future<MatchData> loadMatch() async {
  final profile = jsonDecode(
    await rootBundle.loadString('assets/mock/user_profile.json'),
  ) as Map<String, dynamic>;
  final catalogue = jsonDecode(
    await rootBundle.loadString('assets/mock/languages.json'),
  ) as List<dynamic>;
  final names = {
    for (final item in catalogue)
      (item as Map<String, dynamic>)['code'] as String: item['name'] as String,
  };
  final codes = (profile['languages'] as List<dynamic>).cast<String>();
  return MatchData(
    diamonds: profile['diamondBalance'] as int,
    freeLeft: profile['freeMatchesLeft'] as int,
    freeTotal: profile['freeMatchesTotal'] as int,
    languages: [for (final code in codes) names[code] ?? code],
  );
}
