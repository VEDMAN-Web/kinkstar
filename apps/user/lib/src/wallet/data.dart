import 'dart:convert';

import 'package:flutter/services.dart';

class WalletPlan {
  const WalletPlan({required this.duration, required this.priceINR});

  final String duration;
  final int priceINR;

  factory WalletPlan.fromJson(Map<String, dynamic> json) {
    return WalletPlan(
      duration: json['duration'] as String,
      priceINR: json['priceINR'] as int,
    );
  }
}

class WalletData {
  const WalletData({
    required this.diamonds,
    required this.level,
    required this.nextLevel,
    required this.priyaName,
    required this.videoRate,
    required this.payLabel,
    required this.plans,
    required this.ariaName,
  });

  final int diamonds;
  final int level;
  final int nextLevel;
  final String priyaName;
  final int videoRate;
  final String payLabel;
  final List<WalletPlan> plans;
  final String ariaName;

  int get callMinutes => diamonds ~/ videoRate;
}

Future<WalletData> loadWallet() async {
  final profile = jsonDecode(
    await rootBundle.loadString('assets/mock/user_profile.json'),
  ) as Map<String, dynamic>;
  final hosts = jsonDecode(
    await rootBundle.loadString('assets/mock/hosts.json'),
  ) as List<dynamic>;
  final wallet = jsonDecode(
    await rootBundle.loadString('assets/mock/wallet.json'),
  ) as Map<String, dynamic>;
  final progress = profile['levelProgress'] as Map<String, dynamic>;
  Map<String, dynamic> host(String id) {
    return hosts.cast<Map<String, dynamic>>().firstWhere(
      (item) => item['id'] == id,
    );
  }

  final priya = host('host_priya');
  return WalletData(
    diamonds: profile['diamondBalance'] as int,
    level: profile['level'] as int,
    nextLevel: progress['nextLevel'] as int,
    priyaName: priya['name'] as String,
    videoRate: priya['videoRatePerMin'] as int,
    payLabel:
        (wallet['paymentMethods'] as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .firstWhere((item) => item['id'] == 'google_play')['label']
            as String,
    plans: [
      for (final item in wallet['vipPlans'] as List<dynamic>)
        WalletPlan.fromJson(item as Map<String, dynamic>),
    ],
    ariaName: host('host_aria')['name'] as String,
  );
}

/// `1300` becomes `1,300`.
String grouped(int value) {
  final negative = value < 0;
  final text = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return negative ? '-$buffer' : buffer.toString();
}
