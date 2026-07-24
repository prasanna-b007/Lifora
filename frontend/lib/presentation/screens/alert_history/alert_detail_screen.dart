import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifora/app/theme/app_colors.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/domain/entities/layer_status.dart';
import 'package:lifora/presentation/providers/alert_history_provider.dart';
import 'package:lifora/presentation/providers/contacts_provider.dart';

/// Screen displaying the details of a specific past alert.
class AlertDetailScreen extends StatelessWidget {
  const AlertDetailScreen({super.key, required this.alertId});

  final String alertId;

  @override
  Widget build(BuildContext context) {
    final alertProvider = context.watch<AlertHistoryProvider>();
    final alert = alertProvider.getAlert(alertId);
    final theme = Theme.of(context);

    if (alert == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Alert Details')),
        body: const Center(child: Text('Alert not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Status and Timestamp
            _HeaderCard(alert: alert),
            const SizedBox(height: 24),
            
            // Location Details
            Text('Location', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _LocationCard(alert: alert),
            const SizedBox(height: 24),

            // Resolution Layers Breakdown
            Text('Escalation Layers', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _EscalationCard(alert: alert),
            const SizedBox(height: 24),

            // Notified Contacts
            Text('Notified Contacts', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _NotifiedContactsCard(alert: alert),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSuccess = alert.status == AlertStatus.delivered;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSuccess
            ? theme.colorScheme.secondary.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSuccess
              ? theme.colorScheme.secondary.withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_outline : Icons.info_outline,
            size: 48,
            color: isSuccess ? theme.colorScheme.secondary : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            _statusLabel(alert.status),
            style: theme.textTheme.titleLarge?.copyWith(
              color: isSuccess ? theme.colorScheme.secondary : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatFullDateTime(alert.timestamp),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(AlertStatus status) {
    switch (status) {
      case AlertStatus.delivered:
        return 'Successfully Delivered';
      case AlertStatus.cancelled:
        return 'Cancelled by User';
      case AlertStatus.triggered:
      case AlertStatus.inProgress:
        return 'In Progress';
    }
  }

  String _formatFullDateTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.location_on, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GPS Coordinates', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    '${alert.latitude.toStringAsFixed(5)}° N, ${alert.longitude.toStringAsFixed(5)}° E',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EscalationCard extends StatelessWidget {
  const _EscalationCard({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: alert.layers.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return _LayerTile(layer: alert.layers[index]);
        },
      ),
    );
  }
}

class _LayerTile extends StatelessWidget {
  const _LayerTile({required this.layer});

  final LayerStatus layer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLayerIcon(theme),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Layer ${layer.layer}: ${layer.label}',
                      style: theme.textTheme.titleSmall,
                    ),
                    _buildStateBadge(theme),
                  ],
                ),
                if (layer.detail != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    layer.detail!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerIcon(ThemeData theme) {
    IconData icon;
    switch (layer.layer) {
      case 1:
        icon = Icons.bluetooth;
        break;
      case 2:
        icon = Icons.cell_tower;
        break;
      case 3:
        icon = Icons.hub;
        break;
      default:
        icon = Icons.layers;
    }

    Color color;
    switch (layer.state) {
      case LayerState.succeeded:
        color = theme.colorScheme.secondary;
        break;
      case LayerState.failed:
        color = theme.colorScheme.error;
        break;
      default:
        color = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }

  Widget _buildStateBadge(ThemeData theme) {
    String text;
    Color color;

    switch (layer.state) {
      case LayerState.succeeded:
        text = 'Succeeded';
        color = theme.colorScheme.secondary;
        break;
      case LayerState.failed:
        text = 'Failed';
        color = theme.colorScheme.error;
        break;
      case LayerState.attempting:
        text = 'Attempting';
        color = LiforaColors.alert;
        break;
      case LayerState.pending:
        text = 'Pending';
        color = theme.colorScheme.onSurfaceVariant;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NotifiedContactsCard extends StatelessWidget {
  const _NotifiedContactsCard({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contactsProvider = context.watch<ContactsProvider>();
    
    if (alert.notifiedContactIds.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No contacts were notified.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '${alert.notifiedContactIds.length} contacts notified',
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: alert.notifiedContactIds.map((id) {
                final match = contactsProvider.contacts.where((c) => c.id == id).toList();
                final contact = match.isNotEmpty ? match.first : null;
                final name = contact?.name ?? 'Removed contact';
                final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

                return Card(
                  color: theme.colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Text(
                                initial,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                name,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Phone',
                          style: theme.textTheme.labelSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contact?.phoneNumber ?? '-',
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (contact?.email != null && contact!.email!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Email',
                            style: theme.textTheme.labelSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            contact.email!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
