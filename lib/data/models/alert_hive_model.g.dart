// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlertHiveModelAdapter extends TypeAdapter<AlertHiveModel> {
  @override
  final int typeId = 4;

  @override
  AlertHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlertHiveModel(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      status: fields[2] as AlertStatusHiveModel,
      resolvedAtLayer: fields[3] as int,
      layers: (fields[4] as List).cast<LayerStatusHiveModel>(),
      latitude: fields[5] as double,
      longitude: fields[6] as double,
      accuracy: fields[7] as double,
      notifiedContactIds: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AlertHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.resolvedAtLayer)
      ..writeByte(4)
      ..write(obj.layers)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.accuracy)
      ..writeByte(8)
      ..write(obj.notifiedContactIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlertStatusHiveModelAdapter extends TypeAdapter<AlertStatusHiveModel> {
  @override
  final int typeId = 3;

  @override
  AlertStatusHiveModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AlertStatusHiveModel.triggered;
      case 1:
        return AlertStatusHiveModel.inProgress;
      case 2:
        return AlertStatusHiveModel.delivered;
      case 3:
        return AlertStatusHiveModel.cancelled;
      default:
        return AlertStatusHiveModel.triggered;
    }
  }

  @override
  void write(BinaryWriter writer, AlertStatusHiveModel obj) {
    switch (obj) {
      case AlertStatusHiveModel.triggered:
        writer.writeByte(0);
        break;
      case AlertStatusHiveModel.inProgress:
        writer.writeByte(1);
        break;
      case AlertStatusHiveModel.delivered:
        writer.writeByte(2);
        break;
      case AlertStatusHiveModel.cancelled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertStatusHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
