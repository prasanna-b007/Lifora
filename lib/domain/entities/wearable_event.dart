/// Types of events that can be emitted by the wearable device.
enum WearableEventType {
  tripleTap,
  longPress,
  fall,
  whistle,
  manualSos,
  batteryChanged,
  connected,
  disconnected,
  firmwareUpdated,
}

/// Represents a discrete event emitted by the wearable device.
///
/// This covers both user triggers (taps, falls) and state changes (battery updates, connection events).
class WearableEvent {
  /// The unique identifier of the device emitting the event.
  final String deviceId;
  
  /// The specific type of the event.
  final WearableEventType type;
  
  /// The exact moment the event occurred.
  final DateTime timestamp;
  
  /// Additional contextual data associated with the event.
  /// Example: {'batteryLevel': 20}, {'rssi': -90}
  final Map<String, dynamic> payload;

  const WearableEvent({
    required this.deviceId,
    required this.type,
    required this.timestamp,
    this.payload = const {},
  });
}
