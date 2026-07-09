import 'layer_status.dart';

/// The overall status of a triggered SOS alert.
enum AlertStatus {
  /// The alert has been triggered but processing has not started.
  triggered,

  /// The alert is currently being delivered through fallback layers.
  inProgress,

  /// The alert has been successfully delivered to contacts.
  delivered,

  /// The alert was cancelled by the user before delivery.
  cancelled,
}

/// Represents a triggered SOS alert event.
///
/// An alert captures the moment of emergency activation, including
/// GPS coordinates, the fallback layer escalation state, and which
/// contacts were notified.
class Alert {
  /// Unique identifier for the alert.
  final String id;

  /// Timestamp when the alert was triggered.
  final DateTime timestamp;

  /// Current overall status of the alert.
  final AlertStatus status;

  /// Which fallback layer ultimately delivered the alert (1, 2, or 3).
  final int resolvedAtLayer;

  /// Escalation state of each fallback layer.
  final List<LayerStatus> layers;

  /// GPS latitude at the time of the alert.
  final double latitude;

  /// GPS longitude at the time of the alert.
  final double longitude;

  /// GPS accuracy in meters at the time of the alert.
  final double accuracy;

  /// IDs of contacts that were successfully notified.
  final List<String> notifiedContactIds;

  const Alert({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.resolvedAtLayer,
    required this.layers,
    required this.latitude,
    required this.longitude,
    this.accuracy = 0.0,
    required this.notifiedContactIds,
  });

  /// Returns a copy of this [Alert] with the given fields replaced.
  Alert copyWith({
    String? id,
    DateTime? timestamp,
    AlertStatus? status,
    int? resolvedAtLayer,
    List<LayerStatus>? layers,
    double? latitude,
    double? longitude,
    double? accuracy,
    List<String>? notifiedContactIds,
  }) {
    return Alert(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      resolvedAtLayer: resolvedAtLayer ?? this.resolvedAtLayer,
      layers: layers ?? this.layers,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      notifiedContactIds: notifiedContactIds ?? this.notifiedContactIds,
    );
  }
}
