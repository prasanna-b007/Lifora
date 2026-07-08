/// The current state of a single fallback layer during SOS escalation.
enum LayerState {
  /// The layer has not yet been attempted.
  pending,

  /// The layer is currently being attempted.
  attempting,

  /// The layer successfully delivered the alert.
  succeeded,

  /// The layer failed and escalation continues to the next layer.
  failed,
}

/// State of a single fallback layer during SOS escalation.
///
/// Lifora uses a three-layer delivery model:
///   1. BLE to Phone
///   2. GSM/SMS Fallback
///   3. BLE Mesh Relay
///
/// Each [LayerStatus] tracks the progress of one such layer.
class LayerStatus {
  /// The layer number (1, 2, or 3).
  final int layer;

  /// Human-readable label, e.g., 'BLE to Phone', 'GSM/SMS Fallback'.
  final String label;

  /// Current state of this layer.
  final LayerState state;

  /// Optional detail message providing additional status info.
  final String? detail;

  const LayerStatus({
    required this.layer,
    required this.label,
    required this.state,
    this.detail,
  });

  /// Returns a copy of this [LayerStatus] with the given fields replaced.
  LayerStatus copyWith({
    int? layer,
    String? label,
    LayerState? state,
    String? detail,
  }) {
    return LayerStatus(
      layer: layer ?? this.layer,
      label: label ?? this.label,
      state: state ?? this.state,
      detail: detail ?? this.detail,
    );
  }
}
