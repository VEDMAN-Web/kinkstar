import 'dart:convert';

import 'package:flutter/services.dart';

class CallHost {
  const CallHost({
    required this.id,
    required this.name,
    required this.videoRatePerMin,
    required this.voiceRatePerMin,
    required this.isAI,
  });

  final String id;
  final String name;
  final int videoRatePerMin;
  final int voiceRatePerMin;
  final bool isAI;

  factory CallHost.fromJson(Map<String, dynamic> json) {
    return CallHost(
      id: json['id'] as String,
      name: json['name'] as String,
      videoRatePerMin: json['videoRatePerMin'] as int,
      voiceRatePerMin: json['voiceRatePerMin'] as int,
      isAI: json['isAI'] as bool,
    );
  }
}

class CallRecord {
  const CallRecord({
    required this.id,
    required this.durationSec,
    required this.diamondsCharged,
    required this.giftsCount,
  });

  final String id;
  final int durationSec;
  final int diamondsCharged;
  final int giftsCount;

  factory CallRecord.fromJson(Map<String, dynamic> json) {
    return CallRecord(
      id: json['id'] as String,
      durationSec: json['durationSec'] as int,
      diamondsCharged: json['diamondsCharged'] as int,
      giftsCount: json['giftsCount'] as int,
    );
  }
}

class CallGift {
  const CallGift({required this.id, required this.name, required this.price});

  final String id;
  final String name;
  final int price;

  factory CallGift.fromJson(Map<String, dynamic> json) {
    return CallGift(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
    );
  }
}

class CallsData {
  const CallsData({
    required this.priya,
    required this.aria,
    required this.diamonds,
    required this.summary,
    required this.gifts,
    required this.payLabel,
  });

  final CallHost priya;
  final CallHost aria;
  final int diamonds;
  final CallRecord summary;
  final List<CallGift> gifts;
  final String payLabel;

  CallGift gift(String id) => gifts.firstWhere((item) => item.id == id);

  /// Whole minutes of video the current balance buys.
  int get talkMinutes => diamonds ~/ priya.videoRatePerMin;
}

Future<CallsData> loadCalls() async {
  final hosts = jsonDecode(
    await rootBundle.loadString('assets/mock/hosts.json'),
  );
  final profile = jsonDecode(
    await rootBundle.loadString('assets/mock/user_profile.json'),
  );
  final calls = jsonDecode(
    await rootBundle.loadString('assets/mock/calls.json'),
  );
  final gifts = jsonDecode(
    await rootBundle.loadString('assets/mock/gifts.json'),
  );
  final wallet = jsonDecode(
    await rootBundle.loadString('assets/mock/wallet.json'),
  );
  CallHost host(String id) {
    final json = (hosts as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .firstWhere((item) => item['id'] == id);
    return CallHost.fromJson(json);
  }

  final records = [
    for (final item in calls as List<dynamic>)
      CallRecord.fromJson(item as Map<String, dynamic>),
  ];
  return CallsData(
    priya: host('host_priya'),
    aria: host('host_aria'),
    diamonds: profile['diamondBalance'] as int,
    summary: records.firstWhere((item) => item.id == 'call_priya_842'),
    gifts: [
      for (final item in gifts as List<dynamic>)
        CallGift.fromJson(item as Map<String, dynamic>),
    ],
    payLabel:
        (wallet['paymentMethods'] as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .firstWhere((item) => item['id'] == 'google_play')['label']
            as String,
  );
}

/// `522` becomes `8:42`. Minutes are not zero-padded.
String callClock(int seconds) {
  final minutes = seconds ~/ 60;
  final rest = seconds % 60;
  return '$minutes:${rest.toString().padLeft(2, '0')}';
}
