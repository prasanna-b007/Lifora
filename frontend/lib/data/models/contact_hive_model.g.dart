// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactHiveModelAdapter extends TypeAdapter<ContactHiveModel> {
  @override
  final int typeId = 0;

  @override
  ContactHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      phoneNumber: fields[2] as String,
      email: fields[3] as String?,
      relationship: fields[4] as String,
      isPrimary: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ContactHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.relationship)
      ..writeByte(5)
      ..write(obj.isPrimary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
