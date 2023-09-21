import 'package:hive/hive.dart';
import 'package:tabula/models/collection/card_info.dart';

part 'index_card.g.dart';

@HiveType(typeId: 2)
class IndexCard {
  @HiveField(0)
  String cardID;

  @HiveField(1)
  String front;

  @HiveField(2)
  String back;

  @HiveField(3)
  bool fav;

  @HiveField(4)
  CardInfo info;

  IndexCard(
      {required this.cardID,
      required this.front,
      required this.back,
      required this.info,
      this.fav = false});

  String get getCardID {
    return cardID;
  }

  String get getFront {
    return front;
  }

  String get getBack {
    return back;
  }

  bool get getFav {
    return fav;
  }

  CardInfo get getCardInfo {
    return info;
  }
}
