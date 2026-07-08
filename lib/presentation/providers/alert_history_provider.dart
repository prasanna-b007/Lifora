import 'package:flutter/foundation.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/domain/repositories/alert_repository.dart';

/// View model for the Alert History and Alert Detail screens.
class AlertHistoryProvider extends ChangeNotifier {
  AlertHistoryProvider({
    required AlertRepository alertRepository,
  }) : _alertRepository = alertRepository;

  final AlertRepository _alertRepository;

  /// Returns all past alerts, sorted by timestamp (newest first).
  List<Alert> get alerts {
    final list = _alertRepository.getAlerts();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  /// Retrieves a specific alert by ID.
  Alert? getAlert(String id) {
    return _alertRepository.getAlert(id);
  }

  /// Adds a new alert to history (used when a live alert resolves).
  void addAlert(Alert alert) {
    _alertRepository.addAlert(alert);
    notifyListeners();
  }
}
