import 'dart:async';

import 'package:lifora/domain/entities/device.dart';

import 'device_connection_service.dart';

/// Mock implementation of [DeviceConnectionService] for development and testing.
///
/// Simulates a connected Lifora Band (ESP32-C3) wearable device without
/// requiring real BLE hardware. The device starts in a connected state
/// with realistic mock data.
class MockDeviceConnectionService implements DeviceConnectionService {
  bool _isConnected = true;

  final StreamController<Device> _deviceController =
      StreamController<Device>.broadcast();

  /// The simulated device instance.
  Device _currentDevice = Device(
    id: 'lifora-esp32-001',
    name: 'Lifora Band',
    model: 'ESP32-C3',
    batteryLevel: 78,
    firmwareVersion: 'v1.2.0',
    isConnected: true,
    lastSynced: DateTime.now().subtract(const Duration(minutes: 5)),
  );

  @override
  bool get isConnected => _isConnected;

  @override
  int get batteryLevel => 78;

  @override
  Stream<Device> get deviceStream => _deviceController.stream;

  @override
  Future<void> connect(String deviceId) async {
    // Simulate a brief connection delay.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    _isConnected = true;
    _currentDevice = _currentDevice.copyWith(
      isConnected: true,
      lastSynced: DateTime.now(),
    );
    _deviceController.add(_currentDevice);
  }

  @override
  Future<void> disconnect() async {
    // Simulate a brief disconnection delay.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    _isConnected = false;
    _currentDevice = _currentDevice.copyWith(isConnected: false);
    _deviceController.add(_currentDevice);
  }

  @override
  Future<void> sendSosAlert() async {
    // Simulate the time it takes for the device to acknowledge the SOS.
    await Future<void>.delayed(const Duration(seconds: 1));

    // In a real implementation this would trigger the hardware alert
    // sequence on the ESP32-C3 and wait for acknowledgement.
  }

  /// Releases resources held by this service.
  ///
  /// Call this when the service is no longer needed to prevent
  /// memory leaks from the internal [StreamController].
  void dispose() {
    _deviceController.close();
  }
}
