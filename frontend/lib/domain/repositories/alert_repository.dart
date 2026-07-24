import '../entities/alert.dart';

/// Interface for accessing alert history.
///
/// Implementations handle storage and retrieval of SOS alert
/// events, including their escalation layer states and outcomes.
abstract class AlertRepository {
  /// Returns all stored alerts, most recent first.
  List<Alert> getAlerts();

  /// Returns the alert with [id], or `null` if not found.
  Alert? getAlert(String id);

  /// Adds a new [alert] to the store.
  void addAlert(Alert alert);

  /// Deletes an alert from the store.
  void deleteAlert(String id);
}
