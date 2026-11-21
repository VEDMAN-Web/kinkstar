import 'dart:convert';

import 'package:flutter/services.dart';

class MockLanguage {
  const MockLanguage({required this.code, required this.name});

  final String code;
  final String name;

  /// Design picker label. `languages.json` only stores the English name.
  /// Kannada is in that file and is not on the U02 picker.
  String get pickerLabel => switch (code) {
    'en' => 'English',
    'hi' => 'हिन्दी (Hindi)',
    'bn' => 'বাংলা (Bengali)',
    'ta' => 'தமிழ் (Tamil)',
    'te' => 'తెలుగు (Telugu)',
    'mr' => 'मराठी (Marathi)',
    _ => name,
  };
}

/// Order of the U02 artboard. English is pre-selected there.
const designLanguageOrder = ['en', 'hi', 'bn', 'ta', 'te', 'mr'];

Future<List<MockLanguage>> loadLanguages() async {
  final raw = await rootBundle.loadString('assets/mock/languages.json');
  final list = jsonDecode(raw) as List<dynamic>;
  final byCode = {
    for (final item in list)
      (item as Map<String, dynamic>)['code'] as String: MockLanguage(
        code: item['code'] as String,
        name: item['name'] as String,
      ),
  };
  return [
    for (final code in designLanguageOrder)
      if (byCode.containsKey(code)) byCode[code]!,
  ];
}

class MockUser {
  const MockUser({required this.username, required this.languages});

  final String username;
  final List<String> languages;

  String get initial => username.isEmpty ? '?' : username[0];
}

Future<MockUser> loadUser() async {
  final raw = await rootBundle.loadString('assets/mock/user_profile.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return MockUser(
    username: json['username'] as String,
    languages: [
      for (final code in json['languages'] as List<dynamic>) code as String,
    ],
  );
}
