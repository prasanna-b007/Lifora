import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lifora/domain/entities/event_log.dart';
import 'package:lifora/presentation/providers/event_log_provider.dart';

class EventLogList extends StatelessWidget {
  const EventLogList({super.key});

  IconData _getIconForCategory(EventCategory category) {
    switch (category) {
      case EventCategory.connection:
        return Icons.bluetooth;
      case EventCategory.battery:
        return Icons.battery_std;
      case EventCategory.gps:
        return Icons.location_on;
      case EventCategory.alert:
        return Icons.warning;
      case EventCategory.trigger:
        return Icons.touch_app;
      case EventCategory.notification:
        return Icons.notifications;
      case EventCategory.system:
        return Icons.settings;
      case EventCategory.history:
        return Icons.history;
    }
  }

  Color _getColorForCategory(EventCategory category, BuildContext context, EventLog log) {
    final theme = Theme.of(context);
    
    // Do not use alert red except for actual SOS-related events
    if (category == EventCategory.alert && (log.title.contains('SOS') || log.title.contains('Alert'))) {
      return theme.colorScheme.error;
    }
    
    return theme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventLogProvider>(
      builder: (context, provider, child) {
        final logs = provider.logs;

        if (logs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No events logged yet.'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            final time = '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}:${log.timestamp.second.toString().padLeft(2, '0')}';
            
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: ListTile(
                leading: Icon(
                  _getIconForCategory(log.category),
                  color: _getColorForCategory(log.category, context, log),
                ),
                title: Text(
                  log.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(log.description),
                trailing: Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
