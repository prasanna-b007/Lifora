/// Represents the Lifora wearable device state.
///
/// Tracks connection status, battery level, firmware version,
/// and last sync time for the ESP32-C3 based wearable.
class Device {
  /// Unique identifier for the device.
  final String id;

  /// User-facing display name of the device.
  final String name;

  /// Hardware model identifier, e.g., 'ESP32-C3'.
  final String model;

  /// Current battery level as a percentage (0–100).
  final int batteryLevel;

  /// Currently running firmware version string.
  final String firmwareVersion;

  /// Whether the device is currently connected via BLE.
  final bool isConnected;

  /// Timestamp of the last successful data sync, or `null` if never synced.
  final DateTime? lastSynced;

  const Device({
    required this.id,
    required this.name,
    required this.model,
    required this.batteryLevel,
    required this.firmwareVersion,
    required this.isConnected,
    this.lastSynced,
  });

  /// Returns a copy of this [Device] with the given fields replaced.
  Device copyWith({
    String? id,
    String? name,
    String? model,
    int? batteryLevel,
    String? firmwareVersion,
    bool? isConnected,
    DateTime? lastSynced,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      isConnected: isConnected ?? this.isConnected,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }
}
