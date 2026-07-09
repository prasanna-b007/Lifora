import 'package:hive/hive.dart';
import 'package:lifora/domain/entities/alert.dart';
import 'layer_status_hive_model.dart';

part 'alert_hive_model.g.dart';

@HiveType(typeId: 3)
enum AlertStatusHiveModel {
  @HiveField(0)
  triggered,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  delivered,

  @HiveField(3)
  cancelled,
}

extension AlertStatusHiveModelMapper on AlertStatusHiveModel {
  AlertStatus toDomain() {
    switch (this) {
      case AlertStatusHiveModel.triggered:
        return AlertStatus.triggered;
      case AlertStatusHiveModel.inProgress:
        return AlertStatus.inProgress;
      case AlertStatusHiveModel.delivered:
        return AlertStatus.delivered;
      case AlertStatusHiveModel.cancelled:
        return AlertStatus.cancelled;
    }
  }
}

extension AlertStatusMapper on AlertStatus {
  AlertStatusHiveModel toHiveModel() {
    switch (this) {
      case AlertStatus.triggered:
        return AlertStatusHiveModel.triggered;
      case AlertStatus.inProgress:
        return AlertStatusHiveModel.inProgress;
      case AlertStatus.delivered:
        return AlertStatusHiveModel.delivered;
      case AlertStatus.cancelled:
        return AlertStatusHiveModel.cancelled;
    }
  }
}

@HiveType(typeId: 4)
class AlertHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final AlertStatusHiveModel status;

  @HiveField(3)
  final int resolvedAtLayer;

  @HiveField(4)
  final List<LayerStatusHiveModel> layers;

  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  @HiveField(7)
  final double accuracy;

  @HiveField(8)
  final List<String> notifiedContactIds;

  @HiveField(9)
  final int? batteryAtTrigger;

  AlertHiveModel({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.resolvedAtLayer,
    required this.layers,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.notifiedContactIds,
    this.batteryAtTrigger,
  });

  factory AlertHiveModel.fromDomain(Alert alert) {
    return AlertHiveModel(
      id: alert.id,
      timestamp: alert.timestamp,
      status: alert.status.toHiveModel(),
      resolvedAtLayer: alert.resolvedAtLayer,
      layers: alert.layers.map((l) => LayerStatusHiveModel.fromDomain(l)).toList(),
      latitude: alert.latitude,
      longitude: alert.longitude,
      accuracy: alert.accuracy,
      notifiedContactIds: alert.notifiedContactIds,
      batteryAtTrigger: alert.batteryAtTrigger,
    );
  }

  Alert toDomain() {
    return Alert(
      id: id,
      timestamp: timestamp,
      status: status.toDomain(),
      resolvedAtLayer: resolvedAtLayer,
      layers: layers.map((l) => l.toDomain()).toList(),
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      notifiedContactIds: notifiedContactIds,
      batteryAtTrigger: batteryAtTrigger,
    );
  }
}
