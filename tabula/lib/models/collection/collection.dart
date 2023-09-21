import 'package:hive/hive.dart';
import 'package:tabula/models/collection/index_card.dart';

part 'collection.g.dart';

@HiveType(typeId: 0)
class Collection {
  @HiveField(0)
  String collectionName;

  @HiveField(1)
  String imageURL;

  @HiveField(2)
  List<IndexCard> cards;

  @HiveField(3)
  List<String> categories;

  Collection(
      {required this.collectionName,
      required this.cards,
      this.imageURL = "",
      required this.categories});

  String identity() {
    return collectionName;
  }

  bool equalityCheck(Collection c1, Collection c2) {
    return c1.identity() == c2.identity();
  }
}
