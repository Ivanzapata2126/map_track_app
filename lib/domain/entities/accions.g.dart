// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccionsAdapter extends TypeAdapter<Accions> {
  @override
  final int typeId = 0;

  @override
  Accions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Accions(
      title: fields[0] as String,
      timestamp: fields[2] as DateTime,
      latitude: fields[5] as double,
      longitude: fields[6] as double,
      description: fields[1] as String?,
      imagePath: fields[3] as String?,
      markerIcon: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Accions obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.markerIcon)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
