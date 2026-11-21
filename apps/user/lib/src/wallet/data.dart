import 'dart:convert';

import 'package:flutter/services.dart';

class WalletPlan {
  const WalletPlan({
    required this.duration,
    required this.priceINR,
    this.tag,
    this.selected = false,
  });

  final String duration;
  final int priceINR;
  final String? tag;
  final bool selected;

  factory WalletPlan.fromJson(Map<String, dynamic> json) {
    return WalletPlan(
      duration: json['duration'] as String,
      priceINR: json['priceINR'] as int,
      tag: json['tag'] as String?,
      selected: json['selected'] as bool? ?? false,
    );
  }
}

class StorePack {
  const StorePack({
    required this.diamonds,
    required this.bonusLabel,
    required this.priceINR,
    this.tag,
    this.selected = false,
  });

  final int diamonds;
  final String bonusLabel;
  final int priceINR;
  final String? tag;
  final bool selected;

  factory StorePack.fromJson(Map<String, dynamic> json) {
    final tags = json['tags'] as List<dynamic>?;
    return StorePack(
      diamonds: json['diamonds'] as int,
      bonusLabel: json['bonusLabel'] as String,
      priceINR: json['priceINR'] as int,
      tag: tags == null || tags.isEmpty ? null : tags.first as String,
      selected: json['selected'] as bool? ?? false,
    );
  }
}

class OfferPack {
  const OfferPack({
    required this.diamonds,
    required this.payFor,
    required this.priceINR,
    this.tag,
    this.selected = false,
  });

  final int diamonds;
  final int payFor;
  final int priceINR;
  final String? tag;
  final bool selected;
}

class PayMethod {
  const PayMethod({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.selected,
  });

  final String id;
  final String label;
  final String subtitle;
  final bool selected;
}

class HistoryRow {
  const HistoryRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    this.hostId,
  });

  final String title;
  final String subtitle;
  final String amount;
  final String? hostId;

  bool get positive => amount.startsWith('+');
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
    required this.storeTitle,
    required this.historyLabel,
    required this.balanceLabel,
    required this.talkTime,
    required this.storeBadge,
    required this.promo,
    required this.countdown,
    required this.gst,
    required this.refund,
    required this.buy,
    required this.vipTitle,
    required this.vipDetail,
    required this.vipView,
    required this.packs,
    required this.payTitle,
    required this.payDiamonds,
    required this.payPrice,
    required this.payNote,
    required this.payCta,
    required this.methods,
    required this.creditLabel,
    required this.successTitle,
    required this.successLine,
    required this.newBalanceLabel,
    required this.newBalance,
    required this.progressLabel,
    required this.levelLabel,
    required this.callLabel,
    required this.backLabel,
    required this.offerBadge,
    required this.offerTitle,
    required this.offerValid,
    required this.offerCountdown,
    required this.offerCta,
    required this.offerNote,
    required this.offerPacks,
    required this.vipPageTitle,
    required this.vipName,
    required this.vipCancel,
    required this.vipRenewal,
    required this.vipCta,
    required this.perks,
    required this.historyTitle,
    required this.historyTabs,
    required this.historyRows,
    required this.historyHelp,
  });

  final int diamonds;
  final int level;
  final int nextLevel;
  final String priyaName;
  final int videoRate;
  final String payLabel;
  final List<WalletPlan> plans;
  final String ariaName;
  final String storeTitle;
  final String historyLabel;
  final String balanceLabel;
  final String talkTime;
  final String storeBadge;
  final String promo;
  final String countdown;
  final String gst;
  final String refund;
  final String buy;
  final String vipTitle;
  final String vipDetail;
  final String vipView;
  final List<StorePack> packs;
  final String payTitle;
  final String payDiamonds;
  final String payPrice;
  final String payNote;
  final String payCta;
  final List<PayMethod> methods;
  final String creditLabel;
  final String successTitle;
  final String successLine;
  final String newBalanceLabel;
  final int newBalance;
  final String progressLabel;
  final String levelLabel;
  final String callLabel;
  final String backLabel;
  final String offerBadge;
  final String offerTitle;
  final String offerValid;
  final String offerCountdown;
  final String offerCta;
  final String offerNote;
  final List<OfferPack> offerPacks;
  final String vipPageTitle;
  final String vipName;
  final String vipCancel;
  final String vipRenewal;
  final String vipCta;
  final List<String> perks;
  final String historyTitle;
  final List<String> historyTabs;
  final List<HistoryRow> historyRows;
  final String historyHelp;

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
  final store = wallet['store'] as Map<String, dynamic>;
  final payment = wallet['payment'] as Map<String, dynamic>;
  final success = wallet['success'] as Map<String, dynamic>;
  final offer = wallet['firstRechargeOffer'] as Map<String, dynamic>;
  final membership = wallet['membership'] as Map<String, dynamic>;
  final history = wallet['history'] as Map<String, dynamic>;
  final methods = (wallet['paymentMethods'] as List<dynamic>)
      .cast<Map<String, dynamic>>();
  return WalletData(
    diamonds: profile['diamondBalance'] as int,
    level: profile['level'] as int,
    nextLevel: progress['nextLevel'] as int,
    priyaName: priya['name'] as String,
    videoRate: priya['videoRatePerMin'] as int,
    payLabel:
        methods.firstWhere((item) => item['id'] == 'google_play')['label']
            as String,
    plans: [
      for (final item in wallet['vipPlans'] as List<dynamic>)
        WalletPlan.fromJson(item as Map<String, dynamic>),
    ],
    ariaName: host('host_aria')['name'] as String,
    storeTitle: store['title'] as String,
    historyLabel: store['historyLabel'] as String,
    balanceLabel: store['balanceLabel'] as String,
    talkTime: store['talkTime'] as String,
    storeBadge: store['badge'] as String,
    promo: store['promo'] as String,
    countdown: store['countdown'] as String,
    gst: store['gst'] as String,
    refund: store['refund'] as String,
    buy: store['buy'] as String,
    vipTitle: store['vipTitle'] as String,
    vipDetail: store['vipDetail'] as String,
    vipView: store['vipView'] as String,
    packs: [
      for (final item in wallet['packs'] as List<dynamic>)
        StorePack.fromJson(item as Map<String, dynamic>),
    ],
    payTitle: payment['title'] as String,
    payDiamonds: payment['diamondsLabel'] as String,
    payPrice: payment['priceLabel'] as String,
    payNote: payment['note'] as String,
    payCta: payment['cta'] as String,
    methods: [
      for (final item in methods)
        PayMethod(
          id: item['id'] as String,
          label: item['label'] as String,
          subtitle: item['subtitle'] as String,
          selected: item['selected'] as bool,
        ),
    ],
    creditLabel: success['creditLabel'] as String,
    successTitle: success['title'] as String,
    successLine: success['line'] as String,
    newBalanceLabel: success['balanceLabel'] as String,
    newBalance: success['newBalance'] as int,
    progressLabel: success['progressLabel'] as String,
    levelLabel: success['levelLabel'] as String,
    callLabel: success['call'] as String,
    backLabel: success['back'] as String,
    offerBadge: offer['badge'] as String,
    offerTitle: offer['title'] as String,
    offerValid: offer['validLine'] as String,
    offerCountdown: offer['countdown'] as String,
    offerCta: offer['cta'] as String,
    offerNote: offer['note'] as String,
    offerPacks: [
      for (final item in offer['packs'] as List<dynamic>)
        OfferPack(
          diamonds: (item as Map<String, dynamic>)['diamonds'] as int,
          payFor: item['payFor'] as int,
          priceINR: item['priceINR'] as int,
          tag: item['tag'] as String?,
          selected: item['selected'] as bool? ?? false,
        ),
    ],
    vipPageTitle: membership['pageTitle'] as String,
    vipName: membership['name'] as String,
    vipCancel: membership['cancel'] as String,
    vipRenewal: membership['renewal'] as String,
    vipCta: membership['cta'] as String,
    perks: [
      for (final item in wallet['vipPerks'] as List<dynamic>) item as String,
    ],
    historyTitle: history['title'] as String,
    historyTabs: [
      for (final item in history['tabs'] as List<dynamic>)
        (item as Map<String, dynamic>)['label'] as String,
    ],
    historyRows: [
      for (final item in history['rows'] as List<dynamic>)
        HistoryRow(
          title: (item as Map<String, dynamic>)['title'] as String,
          subtitle: item['subtitle'] as String,
          amount: item['amount'] as String,
          hostId: item['hostId'] as String?,
        ),
    ],
    historyHelp: history['help'] as String,
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
