// SDK Material, not package:material_ui. That package also pulls intl.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../config/app_config_provider.dart';
import '../icons/ks_icons.dart';

/// Boot screen. Layout is fixed; copy, tabs, and switches come from [AppConfig].
class KsPlaceholderHome extends ConsumerWidget {
  const KsPlaceholderHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    return Scaffold(
      body: config.when(
        loading: () => const Center(child: Text('Loading config…')),
        error: (error, _) => Center(child: Text('Config failed: $error')),
        data: (app) => _Loaded(config: app),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = config.tabs.where((tab) => tab.enabled).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 44),
          Row(
            children: [
              Expanded(
                child: Text(
                  config.string('U01_title'),
                  style: theme.textTheme.headlineLarge,
                ),
              ),
              KsIcon(KsIcons.bell, color: scheme.onSurface),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            config.string('U01_subtitle'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text('v${config.version}', style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
            config.features.maintenanceOn
                ? config.features.maintenanceCopy()
                : 'Maintenance off',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tab in enabled)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      tab.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(enabled.isEmpty ? 'Continue' : enabled.first.label),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
