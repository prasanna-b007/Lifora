import 'package:hive/hive.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'package:lifora/domain/repositories/alert_repository.dart';
import 'package:lifora/data/models/alert_hive_model.dart';
import 'package:lifora/data/repositories/mock_alert_repository.dart';

import 'package:lifora/domain/entities/event_log.dart';
import 'package:lifora/presentation/providers/event_log_provider.dart';

class HiveAlertRepository implements AlertRepository {
  final Box<AlertHiveModel> _box;
  final EventLogProvider? eventLogger;

  HiveAlertRepository(this._box, {this.eventLogger}) {
    _initSeedData();
  }

  void _initSeedData() {
    if (_box.isEmpty) {
      final mockRepo = MockAlertRepository();
      // Reverse the list or just add them sequentially so they have correct order.
      // MockAlertRepository returns most recent first, but we want to put them in.
      // Wait, let's just put them into Hive using their IDs.
      for (final alert in mockRepo.getAlerts()) {
        final hiveModel = AlertHiveModel.fromDomain(alert);
        _box.put(alert.id, hiveModel);
      }
    }
  }

  @override
  List<Alert> getAlerts() {
    // Sort by timestamp descending
    final alerts = _box.values.map((model) => model.toDomain()).toList();
    alerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return alerts;
  }

  @override
  Alert? getAlert(String id) {
    return _box.get(id)?.toDomain();
  }

  @override
  void addAlert(Alert alert) {
    final hiveModel = AlertHiveModel.fromDomain(alert);
    _box.put(alert.id, hiveModel);
    eventLogger?.addLog('Alert Saved', 'Alert successfully saved to history.', EventCategory.history);
  }

  @override
  void deleteAlert(String id) {
    _box.delete(id);
    eventLogger?.addLog('Alert Deleted', 'Alert successfully removed from history.', EventCategory.history);
  }
}
