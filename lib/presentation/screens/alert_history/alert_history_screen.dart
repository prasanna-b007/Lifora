import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifora/app/routes.dart';
import 'package:lifora/app/theme/app_colors.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/presentation/providers/alert_history_provider.dart';

/// Screen displaying a list of all past SOS alerts.
class AlertHistoryScreen extends StatelessWidget {
  const AlertHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alertProvider = context.watch<AlertHistoryProvider>();
    final alerts = alertProvider.alerts;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert History'),
      ),
      body: alerts.isEmpty
          ? _buildEmptyState(context, theme)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _HistoryCard(alert: alerts[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_toggle_off,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Alerts Triggered',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your emergency alert history will appear here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.alert});

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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _statusColor(alert.status, theme).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _statusIcon(alert.status),
                  size: 24,
                  color: _statusColor(alert.status, theme),
                ),
              ),
              const SizedBox(width: 16),

              // Alert info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _statusLabel(alert.status),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(alert.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Resolved at Layer ${alert.resolvedAtLayer}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
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

  String _formatDateTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays == 0) return 'Today at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    if (diff.inDays == 1) return 'Yesterday at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    return '${time.day}/${time.month}/${time.year} at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
