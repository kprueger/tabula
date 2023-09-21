import 'package:hive/hive.dart';

part 'user_states.g.dart';

@HiveType(typeId: 4)
class UserStates {
  @HiveField(0)
  int gems;

  @HiveField(1)
  int earned;

  @HiveField(2)
  int spend;

  @HiveField(3)
  int played;

  UserStates(
      {required this.gems,
      required this.earned,
      required this.spend,
      required this.played});
}
