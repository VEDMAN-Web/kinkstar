// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kinkstar_ui/kinkstar_ui.dart';

import '../onboarding/cached_image.dart';
import '../onboarding/chrome.dart';
import 'data.dart';

void _go(BuildContext context, String location) {
  if (GoRouter.maybeOf(context) != null) context.go(location);
}

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  DiscoverData? _data;

  @override
  void initState() {
    super.initState();
    loadDiscover().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider).value;
    final title = config?.string('U01_title') ?? 'Discover';
    final tabs = config?.tabs ?? _defaultTabs;
    final banners = config?.homeBanners ?? const <HomeBanner>[];
    final banner =
        banners.where((item) => item.id == 'banner_recharge').firstOrNull ??
        (banners.isEmpty ? null : banners.first);
    final data = _data;
    final diamonds = data?.diamonds ?? 120;
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: UserSpace.statusBar),
          KsTopBar(
            title: title,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                KsChip(label: '$diamonds', gold: true, icon: KsIcons.gem),
                const SizedBox(width: 12),
                const KsIconButton(icon: KsIcons.bell),
              ],
            ),
          ),
          _FilterChips(chips: data?.chips ?? const []),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: KsCachedImage(
              url: banner?.imageUrl ?? '',
              fallback: _RechargePromo(
                title: data?.promoTitle ?? '',
                detail: data?.promoDetail ?? '',
                cta: data?.promoCta ?? '',
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: data == null
                  ? const SizedBox(height: 480)
                  : _HostGrid(data: data),
            ),
          ),
          UserTabBar(tabs: tabs),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.chips});

  final List<DiscoverChip> chips;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: SizedBox(
        height: 32,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              for (final (index, chip) in chips.indexed) ...[
                if (index > 0) const SizedBox(width: 8),
                GestureDetector(
                  onTap: chip.label == 'Filter'
                      ? () => _go(context, '/discover/filters')
                      : null,
                  child: KsChip(
                    label: chip.label,
                    on: chip.selected,
                    icon: chip.label == 'Filter' ? KsIcons.filter : null,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RechargePromo extends StatelessWidget {
  const _RechargePromo({
    required this.title,
    required this.detail,
    required this.cta,
  });

  final String title;
  final String detail;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: UserGradients.rechargeBanner,
        borderRadius: BorderRadius.circular(UserRadii.card),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: UserText.body.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: UserText.xs.copyWith(
                    fontWeight: FontWeight.w400,
                    color: UserColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          KsButton(
            label: cta,
            fullWidth: false,
            minHeight: UserSpace.buttonSm,
            background: UserColors.gold,
            foreground: UserColors.goldInk,
            textStyle: UserText.buttonSm,
          ),
        ],
      ),
    );
  }
}

_HostCard _cardFor(BuildContext context, DiscoverData data, MockHost host) {
  final badges = <Widget>[
    if (host.isAI)
      _StatusBadge.ai(host.label ?? '')
    else if (host.status == 'busy')
      _StatusBadge.plain(data.badges.inCall)
    else ...[
      _StatusBadge.online(data.badges.online),
      if (host.freeCall) _StatusBadge.plain(data.badges.freeCall),
    ],
  ];
  return _HostCard(
    hostId: host.id,
    photoUrl: _photoUrl(context, host.id),
    name: host.cardName,
    detail: data.cardDetail(host),
    rate: '${host.videoRatePerMin}/min',
    badges: badges,
    video: host.status != 'busy',
    onTap: () => _go(context, '/hosts/${host.id}'),
  );
}

class _HostGrid extends StatelessWidget {
  const _HostGrid({required this.data});

  final DiscoverData data;

  @override
  Widget build(BuildContext context) {
    final cards = [
      for (final id in data.cardHostIds) _cardFor(context, data, data.host(id)),
    ];
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 12),
            Expanded(child: cards[1]),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: cards[2]),
            const SizedBox(width: 12),
            Expanded(child: cards[3]),
          ],
        ),
      ],
    );
  }
}

class _HostCard extends StatelessWidget {
  const _HostCard({
    required this.hostId,
    required this.photoUrl,
    required this.name,
    required this.detail,
    required this.rate,
    required this.badges,
    required this.video,
    this.onTap,
  });

  final String hostId;
  final String photoUrl;
  final String name;
  final String detail;
  final String rate;
  final List<Widget> badges;
  final bool video;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _NetPhoto(
        url: photoUrl,
        height: 236,
        overlay: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: _spaced(badges, 6)),
              const Spacer(),
              Text(
                name,
                style: UserText.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: UserColors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(detail, style: UserText.xs),
              const SizedBox(height: 2),
              Row(
                children: [
                  _PriceBadge(rate),
                  const Spacer(),
                  KsIconButton(
                    icon: video ? KsIcons.video : KsIcons.clock4,
                    size: 40,
                    background: video
                        ? UserColors.primary
                        : UserColors.surface2,
                    color: UserColors.text,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  DiscoverData? _data;

  @override
  void initState() {
    super.initState();
    loadDiscover().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final title =
        ref.watch(appConfigProvider).value?.string('U01_title') ?? 'Discover';
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: UserSpace.statusBar),
              KsTopBar(title: title),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: KsMediaBox(label: 'Host', height: 236)),
                        SizedBox(width: 12),
                        Expanded(child: KsMediaBox(label: 'Host', height: 236)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Positioned.fill(child: ColoredBox(color: UserColors.dim)),
          Align(
            alignment: Alignment.bottomCenter,
            child: _FilterSheet(data: _data),
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet({required this.data});

  final DiscoverData? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: UserColors.surface1,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UserRadii.sheet),
        ),
        border: Border(top: BorderSide(color: UserColors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: UserColors.line,
                borderRadius: BorderRadius.circular(UserRadii.hairline),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(data?.filtersTitle ?? '', style: UserText.h2),
              ),
              Text(
                data?.filtersReset ?? '',
                style: UserText.small.copyWith(color: UserColors.primarySoft),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final group
              in data?.filterGroups ?? const <DiscoverGroup>[]) ...[
            _FilterGroup(
              label: group.label,
              wrap: group.options.length > 4,
              chips: [
                for (final option in group.options)
                  (option.label, option.selected),
              ],
            ),
            const SizedBox(height: 14),
          ],
          KsButton(label: data?.submitLabel ?? ''),
        ],
      ),
    );
  }
}

class _FilterGroup extends StatelessWidget {
  const _FilterGroup({
    required this.label,
    required this.chips,
    this.wrap = false,
  });

  final String label;
  final List<(String, bool)> chips;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final children = [
      for (final chip in chips) KsChip(label: chip.$1, on: chip.$2),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserText.small),
        const SizedBox(height: 8),
        if (wrap)
          Wrap(spacing: 8, runSpacing: 8, children: children)
        else
          Row(children: _spaced(children, 8)),
      ],
    );
  }
}

class HostProfileScreen extends ConsumerStatefulWidget {
  const HostProfileScreen({super.key, required this.hostId});

  final String hostId;

  @override
  ConsumerState<HostProfileScreen> createState() => _HostProfileScreenState();
}

class _HostProfileScreenState extends ConsumerState<HostProfileScreen> {
  DiscoverData? _data;

  @override
  void initState() {
    super.initState();
    loadDiscover().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final host = data?.host(widget.hostId);
    final name = host == null ? '' : host.cardName;
    final meta = host == null
        ? ''
        : '${host.city} · ${data!.languageList(host.languages, separator: ', ')} · ★ ${host.rating} (${compactCount(host.callsCount ?? 0)} calls)';
    final video = host?.videoRatePerMin ?? 0;
    final voice = host?.voiceRatePerMin ?? 0;
    final level = host?.charmLevel ?? 0;
    final followers = host?.followers ?? 0;
    final gift = data?.giftName(host?.topGiftId) ?? '';
    final giftCount = host?.topGiftCount ?? 0;
    final gallery = host?.gallery;
    final photo = _photoUrl(context, host?.id ?? widget.hostId);
    return Scaffold(
      body: Column(
        children: [
          _NetPhoto(
            url: photo,
            height: 470,
            radius: 0,
            overlay: Padding(
              padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      KsIconButton(
                        icon: KsIcons.chevronLeft,
                        background: UserColors.overlay40,
                        color: UserColors.text,
                        onPressed: () => _go(context, '/discover'),
                      ),
                      const Spacer(),
                      const KsIconButton(
                        icon: KsIcons.share2,
                        background: UserColors.overlay40,
                        color: UserColors.text,
                      ),
                      const SizedBox(width: 10),
                      const KsIconButton(
                        icon: KsIcons.ellipsisVertical,
                        background: UserColors.overlay40,
                        color: UserColors.text,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      if (data != null) _StatusBadge.online(data.badges.online),
                      if (host?.verified == true) ...[
                        const SizedBox(width: 6),
                        _StatusBadge.plain(
                          data!.badges.verified,
                          icon: KsIcons.shield,
                        ),
                      ],
                      if (gallery != null) ...[
                        const SizedBox(width: 6),
                        _StatusBadge.plain(gallery.profileLabel),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: UserText.balance.copyWith(color: UserColors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meta,
                    style: UserText.small.copyWith(color: UserColors.text),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32,
                    width: double.infinity,
                    child: OverflowBox(
                      alignment: Alignment.centerLeft,
                      minHeight: 32,
                      maxHeight: 32,
                      maxWidth: 420,
                      child: Row(
                        children: [
                          KsChip(
                            label: '$video / min video',
                            gold: true,
                            icon: KsIcons.gem,
                          ),
                          const SizedBox(width: 8),
                          KsChip(
                            label: '$voice / min voice',
                            icon: KsIcons.gem,
                          ),
                          const SizedBox(width: 8),
                          KsChip(label: 'Level $level'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    host?.bio ?? '',
                    style: UserText.small.copyWith(color: UserColors.text),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      for (final entry
                          in (gallery?.tiles ?? const <String>[]).indexed) ...[
                        if (entry.$1 > 0) const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _go(
                            context,
                            '/hosts/${host?.id ?? widget.hostId}/media',
                          ),
                          child: _NetPhoto(
                            url: _photoUrl(
                              context,
                              '${host?.id ?? widget.hostId}/${entry.$1}',
                            ),
                            height: 80,
                            width: 80,
                            label: entry.$2,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const KsIcon(KsIcons.gift, color: UserColors.muted),
                      const SizedBox(width: 12),
                      Text(
                        'Top gift: $gift x$giftCount ·',
                        style: UserText.small,
                      ),
                      const SizedBox(width: 12),
                      const KsIcon(KsIcons.heart, color: UserColors.muted),
                      const SizedBox(width: 12),
                      Text(
                        '${compactCount(followers)} followers',
                        style: UserText.small,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Row(
              children: [
                const KsIconButton(icon: KsIcons.heart, size: 52),
                const SizedBox(width: 10),
                Expanded(
                  flex: 10,
                  child: KsButton(
                    label: data?.chatLabel ?? '',
                    icon: KsIcons.messageSquare,
                    fullWidth: false,
                    background: Colors.transparent,
                    foreground: UserColors.text,
                    borderColor: UserColors.line,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 14,
                  child: KsButton(
                    label: data?.videoCallLabel ?? '',
                    icon: KsIcons.video,
                    fullWidth: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HostMediaScreen extends ConsumerStatefulWidget {
  const HostMediaScreen({super.key, required this.hostId});

  final String hostId;

  @override
  ConsumerState<HostMediaScreen> createState() => _HostMediaScreenState();
}

class _HostMediaScreenState extends ConsumerState<HostMediaScreen> {
  DiscoverData? _data;

  @override
  void initState() {
    super.initState();
    loadDiscover().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final host = data?.host(widget.hostId);
    final name = host?.name ?? '';
    final rate = host?.videoRatePerMin ?? 0;
    final gallery = host?.gallery;
    return Scaffold(
      backgroundColor: UserColors.viewer,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 52, 16, 8),
            child: Row(
              children: [
                KsIconButton(
                  icon: KsIcons.x,
                  background: UserColors.white12,
                  color: UserColors.text,
                  onPressed: () => _go(context, '/hosts/${widget.hostId}'),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: UserColors.glass,
                    borderRadius: BorderRadius.circular(UserRadii.glass),
                  ),
                  child: Text(
                    gallery?.viewerCountLabel ?? '',
                    style: UserText.glass,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _NetPhoto(
                url: _photoUrl(context, '${widget.hostId}/intro'),
                radius: 0,
                center: true,
                label: gallery?.viewerLabel ?? '',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Dot(),
                SizedBox(width: 6),
                _Dot(),
                SizedBox(width: 6),
                _Dot(active: true),
                SizedBox(width: 6),
                _Dot(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: KsButton(
              label: data?.liveCall(name, rate) ?? '',
              icon: KsIcons.video,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? UserColors.white : UserColors.dotInactive,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _NetPhoto extends StatelessWidget {
  const _NetPhoto({
    required this.url,
    this.height,
    this.width,
    this.radius = UserRadii.chip,
    this.label = '',
    this.center = false,
    this.overlay,
  });

  final String url;
  final double? height;
  final double? width;
  final double radius;
  final String label;
  final bool center;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            KsCachedImage(
              url: url,
              fallback: KsMediaBox(label: label, radius: 0, center: center),
            ),
            ?overlay,
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.label, {this.background, this.foreground, this.icon});

  const _StatusBadge.online(String label)
    : this(label, background: UserColors.ok, foreground: UserColors.onlineInk);

  const _StatusBadge.ai(String label)
    : this(label, background: UserColors.info, foreground: UserColors.infoInk);

  const _StatusBadge.plain(String label, {KsGlyph? icon})
    : this(label, icon: icon);

  final String label;
  final Color? background;
  final Color? foreground;
  final KsGlyph? icon;

  @override
  Widget build(BuildContext context) {
    final color = foreground ?? UserColors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background ?? UserColors.badgeScrim,
        borderRadius: BorderRadius.circular(UserRadii.badge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            KsIcon(icon!, color: color),
            const SizedBox(width: 4),
          ],
          Text(label, style: UserText.badge.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: UserColors.badgeScrim,
        borderRadius: BorderRadius.circular(UserRadii.badge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const KsIcon(KsIcons.gem, color: UserColors.white),
          const SizedBox(width: 4),
          Text(label, style: UserText.badge),
        ],
      ),
    );
  }
}

String _photoUrl(BuildContext context, String id) {
  final config = ProviderScope.containerOf(context)
      .read(appConfigProvider)
      .value;
  final path = 'hosts/$id.jpg';
  return config?.assetUrl(path) ?? path;
}

List<Widget> _spaced(List<Widget> children, double gap) {
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) SizedBox(width: gap),
      children[i],
    ],
  ];
}

const _defaultTabs = [
  ConfigTab(id: 'discover', label: 'Home', enabled: true),
  ConfigTab(id: 'match', label: 'Match', enabled: true),
  ConfigTab(id: 'live', label: 'Live', enabled: true),
  ConfigTab(id: 'messages', label: 'Messages', enabled: true),
  ConfigTab(id: 'me', label: 'Me', enabled: true),
];
