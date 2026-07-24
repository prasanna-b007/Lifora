import 'package:flutter/foundation.dart';

enum EventCategory {
  connection,
  battery,
  trigger,
  gps,
  alert,
  notification,
  system,
  history,
}

@immutable
class EventLog {
  final String id;
  final DateTime timestamp;
  final String title;
  final String description;
  final EventCategory category;

  const EventLog({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventLog &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
