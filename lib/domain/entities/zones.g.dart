// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zones.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZonesAdapter extends TypeAdapter<Zones> {
  @override
  final int typeId = 1;

  @override
  Zones read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zones(
      name: fields[0] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      radius: fields[1] as int,
      color: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Zones obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.radius)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZonesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
