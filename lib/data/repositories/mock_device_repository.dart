import 'package:lifora/domain/entities/device.dart';
import 'package:lifora/domain/repositories/device_repository.dart';

/// In-memory mock implementation of [DeviceRepository].
///
/// Pre-populated with a single Lifora Band (ESP32-C3) device
/// for development and testing without persistent storage.
class MockDeviceRepository implements DeviceRepository {
  Device _device = Device(
    id: 'lifora-esp32-001',
    name: 'Lifora Band',
    model: 'ESP32-C3',
    batteryLevel: 78,
    firmwareVersion: 'v1.2.0',
    isConnected: true,
    lastSynced: DateTime.now().subtract(const Duration(minutes: 5)),
  );

  @override
  Device getDevice() => _device;

  @override
  void updateDevice(Device device) {
    _device = device;
  }
}
