// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlen.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZaposlenAdapter extends TypeAdapter<Zaposlen> {
  @override
  final int typeId = 0;

  @override
  Zaposlen read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zaposlen(
      name: fields[0] as String,
      surname: fields[1] as String,
      position: fields[2] as String,
      birthDate: fields[3] as DateTime,
      arrivalTime: fields[4] as TimeOfDay,
      departureTime: fields[5] as TimeOfDay,
    );
  }

  @override
  void write(BinaryWriter writer, Zaposlen obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.surname)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.birthDate)
      ..writeByte(4)
      ..write(obj.arrivalTime)
      ..writeByte(5)
      ..write(obj.departureTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZaposlenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
