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
  const CallGift({
    required this.id,
    required this.name,
    required this.price,
    this.tag,
    this.chipLabel,
  });

  final String id;
  final String name;
  final int price;
  final String? tag;
  final String? chipLabel;

  factory CallGift.fromJson(Map<String, dynamic> json) {
    return CallGift(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      tag: json['tag'] as String?,
      chipLabel: json['chipLabel'] as String?,
    );
  }
}

class CallPack {
  const CallPack({
    required this.diamonds,
    required this.priceInr,
    this.tag,
    this.bonusLabel,
  });

  final int diamonds;
  final int priceInr;
  final String? tag;
  final String? bonusLabel;

  String get diamondsLabel {
    final text = '$diamonds';
    if (text.length <= 3) return text;
    return '${text.substring(0, text.length - 3)},${text.substring(text.length - 3)}';
  }
}

class CallChip {
  const CallChip({required this.label, required this.selected});

  final String label;
  final bool selected;
}

/// Artboard strings from `config.json` `calls`.
class CallLines {
  const CallLines({
    required this.answersIn,
    required this.billing,
    required this.warning,
    required this.dontShow,
    required this.startLabel,
    required this.voiceInstead,
    required this.notice,
    required this.incomingBadge,
    required this.talked,
    required this.rateNote,
    required this.turnOff,
    required this.videoClock,
    required this.balanceLine,
    required this.caption,
    required this.youLabel,
    required this.roseSent,
    required this.thanks,
    required this.giftClock,
    required this.giftBalance,
    required this.combo,
    required this.lowClock,
    required this.lowBody,
    required this.lowPay,
    required this.lowOther,
    required this.lowEnd,
    required this.packs,
    required this.voiceLabel,
    required this.voiceClock,
    required this.voiceHostId,
    required this.chips,
    required this.queuePlace,
    required this.queueWait,
    required this.queueBody,
    required this.ariaLine,
    required this.voiceHosts,
    required this.dontWait,
    required this.notify,
    required this.leave,
  });

  final String answersIn;
  final String billing;
  final String warning;
  final String dontShow;
  final String startLabel;
  final String voiceInstead;
  final String notice;
  final String incomingBadge;
  final String talked;
  final String rateNote;
  final String turnOff;
  final String videoClock;
  final String balanceLine;
  final String caption;
  final String youLabel;
  final int roseSent;
  final String thanks;
  final String giftClock;
  final int giftBalance;
  final String combo;
  final String lowClock;
  final String lowBody;
  final String lowPay;
  final String lowOther;
  final String lowEnd;
  final List<CallPack> packs;
  final String voiceLabel;
  final String voiceClock;
  final String voiceHostId;
  final List<CallChip> chips;
  final int queuePlace;
  final String queueWait;
  final String queueBody;
  final String ariaLine;
  final int voiceHosts;
  final String dontWait;
  final String notify;
  final String leave;

  factory CallLines.fromJson(Map<String, dynamic> json) {
    final confirm = json['confirm'] as Map<String, dynamic>;
    final outgoing = json['outgoing'] as Map<String, dynamic>;
    final incoming = json['incoming'] as Map<String, dynamic>;
    final video = json['video'] as Map<String, dynamic>;
    final gifts = json['gifts'] as Map<String, dynamic>;
    final low = json['lowBalance'] as Map<String, dynamic>;
    final voice = json['voice'] as Map<String, dynamic>;
    final summary = json['summary'] as Map<String, dynamic>;
    final queue = json['queue'] as Map<String, dynamic>;
    return CallLines(
      answersIn: confirm['statusLine'] as String,
      billing: confirm['billing'] as String,
      warning: confirm['warning'] as String,
      dontShow: confirm['dontShow'] as String,
      startLabel: confirm['startLabel'] as String,
      voiceInstead: confirm['voiceInstead'] as String,
      notice: outgoing['notice'] as String,
      incomingBadge: incoming['badge'] as String,
      talked: incoming['talked'] as String,
      rateNote: incoming['rateNote'] as String,
      turnOff: incoming['turnOff'] as String,
      videoClock: video['clock'] as String,
      balanceLine: video['balanceLine'] as String,
      caption: video['caption'] as String,
      youLabel: video['youLabel'] as String,
      roseSent: video['roseSent'] as int,
      thanks: video['thanks'] as String,
      giftClock: gifts['clock'] as String,
      giftBalance: gifts['balance'] as int,
      combo: gifts['combo'] as String,
      lowClock: low['clock'] as String,
      lowBody: low['body'] as String,
      lowPay: low['pay'] as String,
      lowOther: low['otherMethods'] as String,
      lowEnd: low['endWhenEmpty'] as String,
      packs: [
        for (final item in low['packs'] as List<dynamic>)
          CallPack(
            diamonds: (item as Map<String, dynamic>)['diamonds'] as int,
            priceInr: item['priceINR'] as int,
            tag: item['tag'] as String?,
            bonusLabel: item['bonusLabel'] as String?,
          ),
      ],
      voiceLabel: voice['label'] as String,
      voiceClock: voice['clock'] as String,
      voiceHostId: voice['hostId'] as String,
      chips: [
        for (final item in summary['chips'] as List<dynamic>)
          CallChip(
            label: (item as Map<String, dynamic>)['label'] as String,
            selected: item['selected'] as bool,
          ),
      ],
      queuePlace: queue['place'] as int,
      queueWait: queue['wait'] as String,
      queueBody: queue['body'] as String,
      ariaLine: queue['ariaLine'] as String,
      voiceHosts: queue['voiceHostsAvailable'] as int,
      dontWait: queue['dontWait'] as String,
      notify: queue['notify'] as String,
      leave: queue['leave'] as String,
    );
  }
}

class CallsData {
  const CallsData({
    required this.priya,
    required this.aria,
    required this.anjali,
    required this.diamonds,
    required this.summary,
    required this.gifts,
    required this.payLabel,
    required this.lines,
  });

  final CallHost priya;
  final CallHost aria;
  final CallHost anjali;
  final int diamonds;
  final CallRecord summary;
  final List<CallGift> gifts;
  final String payLabel;
  final CallLines lines;

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
  final config = jsonDecode(
    await rootBundle.loadString(
      'packages/kinkstar_ui/assets/config/config.json',
    ),
  );
  final lines = CallLines.fromJson(config['calls'] as Map<String, dynamic>);
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
    anjali: host(lines.voiceHostId),
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
    lines: lines,
  );
}

/// `522` becomes `8:42`. Minutes are not zero-padded.
String callClock(int seconds) {
  final minutes = seconds ~/ 60;
  final rest = seconds % 60;
  return '$minutes:${rest.toString().padLeft(2, '0')}';
}
