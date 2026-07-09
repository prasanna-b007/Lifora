import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lifora/data/services/device_connection_service.dart';
import 'package:lifora/data/services/virtual_wearable_service.dart';

class DeveloperModeScreen extends StatelessWidget {
  const DeveloperModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We only expose Developer Mode if we are using VirtualWearableService
    final connectionService = context.read<DeviceConnectionService>();
    if (connectionService is! VirtualWearableService) {
      return Scaffold(
        appBar: AppBar(title: const Text('Developer Mode')),
        body: const Center(child: Text('Developer Mode requires Virtual Wearable (Mock).')),
      );
    }

    final wearable = connectionService;

    return Scaffold(
      appBar: AppBar(title: const Text('Developer Mode')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LiveStatePanel(wearable: wearable),
            const SizedBox(height: 24),
            _SectionTitle('Trigger Simulation'),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: wearable.triggerTripleTap, child: const Text('Trigger Triple Tap')),
                ElevatedButton(onPressed: wearable.triggerLongPress, child: const Text('Trigger Long Press')),
                ElevatedButton(onPressed: wearable.triggerFall, child: const Text('Trigger Fall')),
                ElevatedButton(onPressed: wearable.triggerWhistle, child: const Text('Trigger Whistle')),
              ],
            ),
            const SizedBox(height: 24),
            _SectionTitle('Battery'),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(onPressed: () => wearable.setBatteryLevel(100), child: const Text('100%')),
                OutlinedButton(onPressed: () => wearable.setBatteryLevel(75), child: const Text('75%')),
                OutlinedButton(onPressed: () => wearable.setBatteryLevel(50), child: const Text('50%')),
                OutlinedButton(onPressed: () => wearable.setBatteryLevel(20), child: const Text('20%')),
                OutlinedButton(onPressed: () => wearable.setBatteryLevel(5), child: const Text('5%')),
              ],
            ),
            const SizedBox(height: 24),
            _SectionTitle('Connection'),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(onPressed: () => wearable.connect('lifora-virtual-001'), child: const Text('Connect Band')),
                OutlinedButton(onPressed: wearable.disconnect, child: const Text('Disconnect Band')),
                OutlinedButton(onPressed: () => wearable.setRssi(-90), child: const Text('Weak Signal')),
                OutlinedButton(onPressed: () => wearable.setRssi(-100), child: const Text('Lost Connection')),
                OutlinedButton(onPressed: () { wearable.connect('lifora-virtual-001'); wearable.setRssi(-50); }, child: const Text('Reconnect')),
              ],
            ),
            const SizedBox(height: 24),
            _SectionTitle('Network'),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(onPressed: () => wearable.forceEscalationOutcome(1), child: const Text('BLE Success (Force L1)')),
                OutlinedButton(onPressed: () => wearable.forceEscalationOutcome(2), child: const Text('GSM Success (Force L2)')),
                OutlinedButton(onPressed: () => wearable.forceEscalationOutcome(3), child: const Text('Mesh Success (Force L3)')),
              ],
            ),
            const SizedBox(height: 24),
            _SectionTitle('Logs'),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Event Logs'),
                        content: SingleChildScrollView(
                          child: SelectableText(wearable.exportLogAsJson()),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: wearable.exportLogAsJson()));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                            },
                            child: const Text('Copy'),
                          ),
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                        ],
                      ),
                    );
                  },
                  child: const Text('View / Export Logs'),
                ),
                OutlinedButton(
                  onPressed: () {
                    wearable.clearLog();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logs cleared')));
                  },
                  child: const Text('Clear Logs'),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LiveStatePanel extends StatelessWidget {
  final VirtualWearableService wearable;
  const _LiveStatePanel({required this.wearable});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: wearable,
      builder: (context, child) {
        final state = wearable.device;
        
        final theme = Theme.of(context);
        
        return Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Wearable State',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Divider(),
                _StateRow('Connection', state.isConnected ? 'Connected' : 'Disconnected'),
                _StateRow('Battery', '${state.batteryLevel}%'),
                _StateRow('RSSI', '${wearable.rssi} dBm'),
                _StateRow('Firmware', state.firmwareVersion),
                _StateRow('Last Synced', state.lastSynced != null ? '${state.lastSynced!.hour}:${state.lastSynced!.minute.toString().padLeft(2, '0')}:${state.lastSynced!.second.toString().padLeft(2, '0')}' : 'Never'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StateRow extends StatelessWidget {
  final String label;
  final String value;
  const _StateRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
