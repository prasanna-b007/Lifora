import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifora/app/routes.dart';
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
            const _VersionTile(),
            const SizedBox(height: 32),
          ],
        ),
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

class _VersionTile extends StatefulWidget {
  const _VersionTile();

  @override
  State<_VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<_VersionTile> {
  int _tapCount = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('App Version'),
      subtitle: const Text('Current Version'),
      trailing: const Text('1.0.0-beta'),
      onTap: () {
        _tapCount++;
        if (_tapCount >= 7) {
          _tapCount = 0;
          Navigator.pushNamed(context, AppRoutes.developerMode);
        }
      },
    );
  }
}
