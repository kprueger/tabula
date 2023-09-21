import 'package:tabula/models/session/session.dart';

class PlaySession extends Session {
  // User states speichern

  /// pseudo random order of the index cards
  void randomSession(String collectionName) {
    loadCollection(collectionName);
    collection.cards.shuffle();
  }

  /// subset of random ordered index cards of the collection
  /// Collection must contain at least 4 indexcards to take effect
  void quickSession(String collectionName) {
    randomSession(collectionName);
    var collLen = collection.cards.length;
    if (collLen > 3) {
      var quickFactor = 0.4;
      int quickCollectionLen = (quickFactor * collLen).round();
      collection.cards = collection.cards.take(quickCollectionLen).toList();
    }
  }
}
