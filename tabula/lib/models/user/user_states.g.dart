// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_states.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatesAdapter extends TypeAdapter<UserStates> {
  @override
  final int typeId = 4;

  @override
  UserStates read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStates(
      gems: fields[0] as int,
      earned: fields[1] as int,
      spend: fields[2] as int,
      played: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserStates obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.gems)
      ..writeByte(1)
      ..write(obj.earned)
      ..writeByte(2)
      ..write(obj.spend)
      ..writeByte(3)
      ..write(obj.played);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
