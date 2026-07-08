import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifora/domain/entities/device.dart';
import 'package:lifora/presentation/providers/device_settings_provider.dart';

/// Screen for viewing and managing the connected Lifora device.
class DeviceSettingsScreen extends StatelessWidget {
  const DeviceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeviceSettingsProvider>();
    final device = provider.device;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Device Image/Icon
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: device.isConnected
                      ? theme.colorScheme.secondary.withValues(alpha: 0.1)
                      : theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.watch,
                  size: 64,
                  color: device.isConnected
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Connection Status Card
            _ConnectionCard(
              device: device,
              isConnecting: provider.isConnecting,
              onConnect: provider.connect,
              onDisconnect: provider.disconnect,
            ),
            const SizedBox(height: 24),

            // Hardware Info
            Text('Hardware Info', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _HardwareInfoCard(device: device),
          ],
        ),
      ),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.device,
    required this.isConnecting,
    required this.onConnect,
    required this.onDisconnect,
  });

  final Device device;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: device.isConnected
                        ? theme.colorScheme.secondary.withValues(alpha: 0.2)
                        : theme.colorScheme.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    device.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                    color: device.isConnected ? theme.colorScheme.secondary : theme.colorScheme.error,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.isConnected ? 'Connected' : 'Disconnected',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: device.isConnected ? theme.colorScheme.secondary : theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        device.isConnected
                            ? 'Lifora Band is synced and ready.'
                            : 'Ensure your device is powered on and nearby.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isConnecting
                    ? null
                    : (device.isConnected ? onDisconnect : onConnect),
                style: ElevatedButton.styleFrom(
                  backgroundColor: device.isConnected
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.primary,
                  foregroundColor: device.isConnected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onPrimary,
                ),
                child: isConnecting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(device.isConnected ? 'Disconnect' : 'Connect Device'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HardwareInfoCard extends StatelessWidget {
  const _HardwareInfoCard({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info_outline, color: theme.colorScheme.primary),
            title: const Text('Device Model'),
            trailing: Text(
              device.model,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.memory, color: theme.colorScheme.primary),
            title: const Text('Firmware Version'),
            trailing: Text(
              device.firmwareVersion,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              device.batteryLevel > 20 ? Icons.battery_full : Icons.battery_alert,
              color: device.batteryLevel > 20 ? theme.colorScheme.secondary : theme.colorScheme.error,
            ),
            title: const Text('Battery Level'),
            trailing: Text(
              '${device.batteryLevel}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: device.batteryLevel > 20 ? theme.colorScheme.secondary : theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
