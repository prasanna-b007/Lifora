import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifora/presentation/providers/app_settings_provider.dart';

/// Screen for application-wide settings (Appearance, Notifications, Permissions, About).
class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppSettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // Appearance
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Appearance',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text('Theme'),
              subtitle: Text(_themeModeName(provider.themeMode)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showThemeDialog(context, provider),
            ),
            const Divider(),

            // Notifications
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Notifications',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.warning_amber_rounded),
              title: const Text('Emergency Alerts'),
              value: provider.emergencyAlerts,
              onChanged: provider.setEmergencyAlerts,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: const Text('Push Notifications'),
              value: provider.pushNotifications,
              onChanged: provider.setPushNotifications,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.volume_up_outlined),
              title: const Text('Sound'),
              value: provider.sound,
              onChanged: provider.setSound,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.vibration),
              title: const Text('Vibration'),
              value: provider.vibration,
              onChanged: provider.setVibration,
            ),
            const Divider(),

            // Permissions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Permissions',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Location'),
              trailing: Text('Granted'),
            ),
            const ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('Bluetooth'),
              trailing: Text('Granted'),
            ),
            const ListTile(
              leading: Icon(Icons.notifications_active_outlined),
              title: Text('Notifications'),
              trailing: Text('Granted'),
            ),
            const Divider(),

            // About Lifora
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'About Lifora',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('App Version'),
              subtitle: Text('Current Version'),
              trailing: Text('1.0.0-beta'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prototype Status', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      _statusRow(theme, true, 'BLE Architecture Ready'),
                      _statusRow(theme, true, 'UI Complete'),
                      _statusRow(theme, false, 'Hardware Integration Pending'),
                      _statusRow(theme, false, 'GSM Pending'),
                      _statusRow(theme, false, 'Mesh Pending'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _statusRow(ThemeData theme, bool isComplete, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isComplete ? theme.colorScheme.secondary : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isComplete ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _themeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showThemeDialog(BuildContext context, AppSettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              return RadioListTile<ThemeMode>(
                title: Text(_themeModeName(mode)),
                value: mode,
                // ignore: deprecated_member_use
                groupValue: provider.themeMode,
                // ignore: deprecated_member_use
                onChanged: (value) {
                  if (value != null) provider.setThemeMode(value);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
