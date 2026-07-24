import 'package:flutter/foundation.dart';

import 'package:lifora/domain/entities/event_log.dart';

class EventLogProvider extends ChangeNotifier {
  final List<EventLog> _logs = [];
  int _counter = 0;
  static const int _maxLogs = 200;

  List<EventLog> get logs => List.unmodifiable(_logs);

  void addLog(String title, String description, EventCategory category) {
    final log = EventLog(
      id: (_counter++).toString(),
      timestamp: DateTime.now(),
      title: title,
      description: description,
      category: category,
    );

    _logs.insert(0, log);

    if (_logs.length > _maxLogs) {
      _logs.removeLast();
    }

    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }
}
