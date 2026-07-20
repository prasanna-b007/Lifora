import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/domain/entities/layer_status.dart';
import 'package:lifora/domain/repositories/alert_repository.dart';

/// In-memory mock implementation of [AlertRepository].
///
/// Pre-populated with two past SOS alerts that demonstrate different
/// fallback layer outcomes:
///   - Alert 1: resolved at Layer 1 (BLE to Phone) — all contacts notified.
///   - Alert 2: resolved at Layer 2 (GSM/SMS) after BLE failed — phone
///     was out of BLE range.
///
/// Both alerts use GPS coordinates for Coimbatore, Tamil Nadu (11.0168°N, 76.9558°E).
class MockAlertRepository implements AlertRepository {
  final List<Alert> _alerts = [
    // Alert 1 — Resolved at Layer 1 (BLE to Phone), 2 days ago.
    Alert(
      id: 'a1',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      status: AlertStatus.delivered,
      resolvedAtLayer: 1,
      layers: const [
        LayerStatus(
          layer: 1,
          label: 'BLE to Phone',
          state: LayerState.succeeded,
        ),
        LayerStatus(
          layer: 2,
          label: 'GSM/SMS Fallback',
          state: LayerState.pending,
        ),
        LayerStatus(
          layer: 3,
          label: 'BLE Mesh Relay',
          state: LayerState.pending,
        ),
      ],
      latitude: 11.0168,
      longitude: 76.9558,
      notifiedContactIds: ['c1', 'c2', 'c3'],
    ),

    // Alert 2 — Resolved at Layer 2 (GSM/SMS), 5 days ago.
    // Layer 1 failed because the phone was out of BLE range.
    Alert(
      id: 'a2',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      status: AlertStatus.delivered,
      resolvedAtLayer: 2,
      layers: const [
        LayerStatus(
          layer: 1,
          label: 'BLE to Phone',
          state: LayerState.failed,
          detail: 'Phone out of BLE range',
        ),
        LayerStatus(
          layer: 2,
          label: 'GSM/SMS Fallback',
          state: LayerState.succeeded,
        ),
        LayerStatus(
          layer: 3,
          label: 'BLE Mesh Relay',
          state: LayerState.pending,
        ),
      ],
      latitude: 11.0168,
      longitude: 76.9558,
      notifiedContactIds: ['c1', 'c2'],
    ),

    // Alert 3 — Resolved at Layer 3 (Mesh), 14 days ago.
    // Both Phone and GSM failed, resolved via nearby Mesh node.
    Alert(
      id: 'a3',
      timestamp: DateTime.now().subtract(const Duration(days: 14)),
      status: AlertStatus.delivered,
      resolvedAtLayer: 3,
      layers: const [
        LayerStatus(
          layer: 1,
          label: 'BLE to Phone',
          state: LayerState.failed,
          detail: 'Phone out of BLE range',
        ),
        LayerStatus(
          layer: 2,
          label: 'GSM/SMS Fallback',
          state: LayerState.failed,
          detail: 'No cellular signal available',
        ),
        LayerStatus(
          layer: 3,
          label: 'BLE Mesh Relay',
          state: LayerState.succeeded,
          detail: 'Delivered via nearby node',
        ),
      ],
      latitude: 11.0168,
      longitude: 76.9558,
      notifiedContactIds: ['c1'],
    ),
  ];

  @override
  List<Alert> getAlerts() => List.unmodifiable(_alerts);

  @override
  Alert? getAlert(String id) {
    try {
      return _alerts.firstWhere((alert) => alert.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  void addAlert(Alert alert) {
    _alerts.insert(0, alert); // Most recent first.
  }

  @override
  void deleteAlert(String id) {
    _alerts.removeWhere((alert) => alert.id == id);
  }
}
