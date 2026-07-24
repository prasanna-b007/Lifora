import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lifora/app/routes.dart';
import 'package:lifora/app/theme/app_colors.dart';
import 'package:lifora/core/constants.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/domain/entities/contact.dart';
import 'package:lifora/domain/entities/device.dart';
import 'package:lifora/data/services/device_connection_service.dart';
import 'package:lifora/presentation/providers/home_provider.dart';
import 'package:lifora/presentation/widgets/sos_trigger_button.dart';

/// Home / Dashboard screen — the first screen the user sees.
///
/// Layout (top to bottom):
/// 1. Greeting + device status card
/// 2. SOS trigger button (dominant center element)
/// 3. Quick emergency contacts
/// 4. Most recent alert preview
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifora'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'App Settings',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.appSettings),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Greeting ────────────────────────────────────────
              Text(
                'Hello, ${AppConstants.mockUserName}',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Your safety companion is ready.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              // ── Device Status Card ──────────────────────────────
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.liforaBand),
                child: _DeviceStatusCard(device: homeProvider.device),
              ),
              const SizedBox(height: 28),

              // ── SOS Trigger Section ─────────────────────────────
              Center(
                child: Column(
                  children: [
                    SosTriggerButton(
                      onPressed: () {
                        context.read<DeviceConnectionService>().sendSosAlert();
                        Navigator.pushNamed(context, AppRoutes.liveAlert);
                      },
                      enabled: homeProvider.device.isConnected,
                    ),
                    const SizedBox(height: 12),

                    // "Simulate SOS" — visually distinct demo action
                    TextButton.icon(
                      onPressed: () {
                        context.read<DeviceConnectionService>().sendSosAlert();
                        Navigator.pushNamed(context, AppRoutes.liveAlert);
                      },
                      icon: Icon(
                        Icons.play_circle_outline,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      label: Text(
                        'Simulate SOS (Demo)',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Quick Contacts ──────────────────────────────────
              _SectionHeader(
                title: 'Emergency Contacts',
                actionLabel: homeProvider.totalContactCount > 3
                    ? 'View all (${homeProvider.totalContactCount})'
                    : 'Manage',
                onAction: () async {
                  await Navigator.pushNamed(context, AppRoutes.contacts);
                  if (context.mounted) {
                    context.read<HomeProvider>().refresh();
                  }
                },
              ),
              const SizedBox(height: 8),
              ...homeProvider.quickContacts.map(
                (contact) => _ContactTile(contact: contact),
              ),
              if (homeProvider.quickContacts.isEmpty)
                _EmptyHint(
                  message: 'No emergency contacts added yet.',
                  actionLabel: 'Add contacts',
                  onAction: () async {
                    await Navigator.pushNamed(context, AppRoutes.contacts);
                    if (context.mounted) {
                      context.read<HomeProvider>().refresh();
                    }
                  },
                ),
              const SizedBox(height: 24),

              // ── Recent Alert ────────────────────────────────────
              _SectionHeader(
                title: 'Recent Alert',
                actionLabel: 'History',
                onAction: () =>
                    Navigator.pushNamed(context, AppRoutes.alertHistory),
              ),
              const SizedBox(height: 8),
              if (homeProvider.latestAlert != null)
                _AlertPreviewCard(alert: homeProvider.latestAlert!)
              else
                _EmptyHint(
                  message: 'No alerts triggered yet.',
                  actionLabel: 'View history',
                  onAction: () =>
                      Navigator.pushNamed(context, AppRoutes.alertHistory),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Private sub-widgets
// ═══════════════════════════════════════════════════════════════════════

/// Section header with a title and an optional trailing text action.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Device connection status card.
///
/// Shows device name, model, connection status, battery level,
/// and last sync time.
class _DeviceStatusCard extends StatelessWidget {
  const _DeviceStatusCard({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Device icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: device.isConnected
                    ? theme.colorScheme.secondary.withValues(alpha: 0.15)
                    : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.watch,
                color: device.isConnected
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Device info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        device.name,
                        style: theme.textTheme.titleSmall,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: device.isConnected
                              ? theme.colorScheme.secondary
                                  .withValues(alpha: 0.15)
                              : theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          device.isConnected ? 'Connected' : 'Disconnected',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: device.isConnected
                                ? LiforaColors.secondary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${device.model} · ${device.firmwareVersion}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Battery level
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _batteryIcon(device.batteryLevel),
                      size: 20,
                      color: device.batteryLevel > 20
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${device.batteryLevel}%',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: device.batteryLevel > 20
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
                if (device.lastSynced != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatSyncTime(device.lastSynced!),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _batteryIcon(int level) {
    if (level > 80) return Icons.battery_full;
    if (level > 60) return Icons.battery_5_bar;
    if (level > 40) return Icons.battery_4_bar;
    if (level > 20) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }

  String _formatSyncTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Synced just now';
    if (diff.inMinutes < 60) return 'Synced ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Synced ${diff.inHours}h ago';
    return 'Synced ${diff.inDays}d ago';
  }
}

/// Single contact row for the quick-view section.
class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
          child: Text(
            contact.name[0].toUpperCase(),
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(contact.name, style: theme.textTheme.titleSmall),
            if (contact.isPrimary) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.star_rounded,
                size: 16,
                color: theme.colorScheme.secondary,
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.relationship,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              contact.phoneNumber,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (contact.email != null && contact.email!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                contact.email!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        dense: true,
      ),
    );
  }
}

/// Preview card for the most recent alert.
class _AlertPreviewCard extends StatelessWidget {
  const _AlertPreviewCard({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.alertDetail,
          arguments: alert.id,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _statusColor(alert.status, theme)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _statusIcon(alert.status),
                  size: 20,
                  color: _statusColor(alert.status, theme),
                ),
              ),
              const SizedBox(width: 14),

              // Alert info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _statusLabel(alert.status),
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Layer ${alert.resolvedAtLayer} · '
                      '${_formatTimestamp(alert.timestamp)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(AlertStatus status, ThemeData theme) {
    switch (status) {
      case AlertStatus.delivered:
        return theme.colorScheme.secondary;
      case AlertStatus.cancelled:
        return theme.colorScheme.onSurfaceVariant;
      case AlertStatus.triggered:
      case AlertStatus.inProgress:
        // Active SOS — uses alert color. This is one of the few
        // legitimate uses of LiforaColors.alert outside the SOS button.
        return LiforaColors.alert;
    }
  }

  IconData _statusIcon(AlertStatus status) {
    switch (status) {
      case AlertStatus.delivered:
        return Icons.check_circle_outline;
      case AlertStatus.cancelled:
        return Icons.cancel_outlined;
      case AlertStatus.triggered:
      case AlertStatus.inProgress:
        return Icons.crisis_alert;
    }
  }

  String _statusLabel(AlertStatus status) {
    switch (status) {
      case AlertStatus.delivered:
        return 'Alert Delivered';
      case AlertStatus.cancelled:
        return 'Alert Cancelled';
      case AlertStatus.triggered:
        return 'Alert Triggered';
      case AlertStatus.inProgress:
        return 'Alert In Progress';
    }
  }

  String _formatTimestamp(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}

/// Empty state hint with an optional action.
class _EmptyHint extends StatelessWidget {
  const _EmptyHint({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
