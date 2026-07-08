import '../entities/device.dart';

/// Interface for accessing device state.
///
/// Implementations of this interface provide the mechanism for
/// reading and updating the current state of the Lifora wearable
/// device (connection status, battery, firmware, etc.).
abstract class DeviceRepository {
  /// Returns the current [Device] state.
  Device getDevice();

  /// Persists an updated [Device] state.
  void updateDevice(Device device);
}
