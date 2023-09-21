// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardInfoAdapter extends TypeAdapter<CardInfo> {
  @override
  final int typeId = 3;

  @override
  CardInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardInfo(
      type: fields[0] as String,
      info: fields[1] as String,
      backgroundInfo: fields[2] as String,
      synonym: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CardInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.info)
      ..writeByte(2)
      ..write(obj.backgroundInfo)
      ..writeByte(3)
      ..write(obj.synonym);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
