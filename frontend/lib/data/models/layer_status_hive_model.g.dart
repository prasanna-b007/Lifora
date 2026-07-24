// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layer_status_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LayerStatusHiveModelAdapter extends TypeAdapter<LayerStatusHiveModel> {
  @override
  final int typeId = 2;

  @override
  LayerStatusHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LayerStatusHiveModel(
      layer: fields[0] as int,
      label: fields[1] as String,
      state: fields[2] as LayerStateHiveModel,
      detail: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LayerStatusHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.layer)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.detail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayerStatusHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LayerStateHiveModelAdapter extends TypeAdapter<LayerStateHiveModel> {
  @override
  final int typeId = 1;

  @override
  LayerStateHiveModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LayerStateHiveModel.pending;
      case 1:
        return LayerStateHiveModel.attempting;
      case 2:
        return LayerStateHiveModel.succeeded;
      case 3:
        return LayerStateHiveModel.failed;
      default:
        return LayerStateHiveModel.pending;
    }
  }

  @override
  void write(BinaryWriter writer, LayerStateHiveModel obj) {
    switch (obj) {
      case LayerStateHiveModel.pending:
        writer.writeByte(0);
        break;
      case LayerStateHiveModel.attempting:
        writer.writeByte(1);
        break;
      case LayerStateHiveModel.succeeded:
        writer.writeByte(2);
        break;
      case LayerStateHiveModel.failed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayerStateHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
