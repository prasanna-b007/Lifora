import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lifora/domain/entities/device.dart';
import 'package:lifora/data/services/device_connection_service.dart';

/// View model for the Device Settings screen.
///
/// Manages the connection state of the Lifora wearable device.
class DeviceSettingsProvider extends ChangeNotifier {
  DeviceSettingsProvider({
    required DeviceConnectionService connectionService,
  })  : _connectionService = connectionService {
    _connectionService.addListener(notifyListeners);
  }

  final DeviceConnectionService _connectionService;

  /// Current device state.
  Device get device => _connectionService.device;

  /// Whether the device is currently in the process of connecting.
  bool get isConnecting => _isConnecting;
  bool _isConnecting = false;

  /// Manually connect to the device.
  Future<void> connect() async {
    if (device.isConnected || _isConnecting) return;

    _isConnecting = true;
    notifyListeners();

    try {
      await _connectionService.connect(device.id);
    } finally {
      _isConnecting = false;
      notifyListeners();
    }
  }

  /// Manually disconnect from the device.
  Future<void> disconnect() async {
    if (!device.isConnected) return;
    await _connectionService.disconnect();
    notifyListeners();
  }

  @override
  void dispose() {
    _connectionService.removeListener(notifyListeners);
    super.dispose();
  }
}
