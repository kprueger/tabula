import 'package:tabula/models/collection/collection.dart';
import 'package:tabula/models/db/db.dart';
import 'package:tabula/models/network/api.dart';
import 'package:hive/hive.dart';
import 'package:tabula/main.dart';

abstract class Session {
  Api api = Api();

  DB db = DB();

  Collection collection =
      Collection(collectionName: "", cards: [], categories: []);

  /// The Collection database interface
  Box tempBox = Hive.box<Collection>(collectionBoxName);

  /// Load the [collectionName] for editing
  void loadCollection(String collectionName) {
    print("load collection: $collectionName");
    collection = tempBox.get(collectionName);
  }

  Collection getCollection() {
    return collection;
  }

  List<dynamic> getCollectionNames() {
    print("The collection keys are: " + tempBox.keys.toString());

    // tempBox.keys;
    return tempBox.keys.toList();
  }
}
