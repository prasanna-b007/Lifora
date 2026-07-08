import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lifora/domain/entities/device.dart';
import 'package:lifora/data/services/device_connection_service.dart';
import 'package:lifora/domain/repositories/device_repository.dart';

/// View model for the Device Settings screen.
///
/// Manages the connection state of the Lifora wearable device.
class DeviceSettingsProvider extends ChangeNotifier {
  DeviceSettingsProvider({
    required DeviceConnectionService connectionService,
    required DeviceRepository deviceRepository,
  })  : _connectionService = connectionService,
        _deviceRepository = deviceRepository {
    // Listen to the stream from the connection service to update the UI
    // when the device state changes (e.g., connected, disconnected, battery update).
    _subscription = _connectionService.deviceStream.listen((updatedDevice) {
      _deviceRepository.updateDevice(updatedDevice);
      notifyListeners();
    });
  }

  final DeviceConnectionService _connectionService;
  final DeviceRepository _deviceRepository;
  StreamSubscription<Device>? _subscription;

  /// Current device state.
  Device get device => _deviceRepository.getDevice();

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
    _subscription?.cancel();
    super.dispose();
  }
}
