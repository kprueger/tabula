// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IndexCardAdapter extends TypeAdapter<IndexCard> {
  @override
  final int typeId = 2;

  @override
  IndexCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IndexCard(
      cardID: fields[0] as String,
      front: fields[1] as String,
      back: fields[2] as String,
      info: fields[4] as CardInfo,
      fav: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, IndexCard obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.cardID)
      ..writeByte(1)
      ..write(obj.front)
      ..writeByte(2)
      ..write(obj.back)
      ..writeByte(3)
      ..write(obj.fav)
      ..writeByte(4)
      ..write(obj.info);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndexCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
