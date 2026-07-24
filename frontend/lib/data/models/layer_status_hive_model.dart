import 'package:hive/hive.dart';
import 'package:lifora/domain/entities/layer_status.dart';

part 'layer_status_hive_model.g.dart';

@HiveType(typeId: 1)
enum LayerStateHiveModel {
  @HiveField(0)
  pending,

  @HiveField(1)
  attempting,

  @HiveField(2)
  succeeded,

  @HiveField(3)
  failed,
}

extension LayerStateHiveModelMapper on LayerStateHiveModel {
  LayerState toDomain() {
    switch (this) {
      case LayerStateHiveModel.pending:
        return LayerState.pending;
      case LayerStateHiveModel.attempting:
        return LayerState.attempting;
      case LayerStateHiveModel.succeeded:
        return LayerState.succeeded;
      case LayerStateHiveModel.failed:
        return LayerState.failed;
    }
  }
}

extension LayerStateMapper on LayerState {
  LayerStateHiveModel toHiveModel() {
    switch (this) {
      case LayerState.pending:
        return LayerStateHiveModel.pending;
      case LayerState.attempting:
        return LayerStateHiveModel.attempting;
      case LayerState.succeeded:
        return LayerStateHiveModel.succeeded;
      case LayerState.failed:
        return LayerStateHiveModel.failed;
    }
  }
}

@HiveType(typeId: 2)
class LayerStatusHiveModel extends HiveObject {
  @HiveField(0)
  final int layer;

  @HiveField(1)
  final String label;

  @HiveField(2)
  final LayerStateHiveModel state;

  @HiveField(3)
  final String? detail;

  LayerStatusHiveModel({
    required this.layer,
    required this.label,
    required this.state,
    this.detail,
  });

  factory LayerStatusHiveModel.fromDomain(LayerStatus status) {
    return LayerStatusHiveModel(
      layer: status.layer,
      label: status.label,
      state: status.state.toHiveModel(),
      detail: status.detail,
    );
  }

  LayerStatus toDomain() {
    return LayerStatus(
      layer: layer,
      label: label,
      state: state.toDomain(),
      detail: detail,
    );
  }
}
