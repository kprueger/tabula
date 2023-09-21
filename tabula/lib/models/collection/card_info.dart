import 'package:hive/hive.dart';

part 'card_info.g.dart';

@HiveType(typeId: 3)
class CardInfo {
  @HiveField(0)
  String type;

  @HiveField(1)
  String info;

  @HiveField(2)
  String backgroundInfo;

  @HiveField(3)
  String synonym;

  CardInfo(
      {this.type = "",
      this.info = "",
      this.backgroundInfo = "",
      this.synonym = ""});
}
