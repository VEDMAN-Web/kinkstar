import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';

/// Asset path of the bundled copy of `mock/config.json`.
///
/// Override this in tests. The default is the copy inside `kinkstar_ui`,
/// which is a byte-for-byte snapshot of `feature/mock-data`'s
/// `mock/config.json`. That branch owns the `mock/` folder; this package
/// does not write to it.
final configAssetProvider = Provider<String>(
  (ref) => 'packages/kinkstar_ui/assets/config/config.json',
);

final appConfigProvider = FutureProvider<AppConfig>((ref) async {
  final path = ref.watch(configAssetProvider);
  final raw = await rootBundle.loadString(path);
  return AppConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
});
