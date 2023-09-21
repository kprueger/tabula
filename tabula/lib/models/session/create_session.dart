import 'dart:convert';

import 'package:tabula/models/collection/card_info.dart';
import 'package:tabula/models/collection/collection.dart';
import 'package:tabula/models/collection/index_card.dart';
import 'package:tabula/models/session/session.dart';

class CreateSession extends Session {
  Future<String> requestCollection(String amount, List<String> categories) {
    // return Future.value('[{"front": "Küche", "back": "kitchen"}]');
    // '[{"front": "Küche", "back": "kitchen"},{"front": "Küchengeräte", "back": "kitchen appliances"},{"front": "Arbeit", "back": "work"},{"front": "Essen", "back": "food"},{"front": "Lebensmittel", "back": "groceries"},{"front": "Frühstück", "back": "breakfast"},{"front": "Gesund", "back": "healthy"},{"front": "Tisch", "back": "table"},{"front": "Backofen", "back": "oven"},{"front": "Mittagessen", "back": "lunch"}]');
    return api.fetchCollection(amount: amount, categories: categories);
  }

  Future<String> requestExtendCollection(
      String amount, List<String> categories, List<String> indexCardWords) {
    // return Future.value(
    // '[{"front": "Arbeit", "back": "work"},{"front": "Essen", "back": "food"}]');
    return api.fetchExtendCollection(
        amount: amount, categories: categories, indexCardWords: indexCardWords);
  }

  /// Store the new created collection to the database
  Future<String> setCollectionName(
      String collectionName, List<String> categories) {
    return collectionName.isEmpty
        ? api.fetchCollectionName(categories: categories)
        : Future.value(collectionName);
  }

  void storeCollection(String collectionName) {
    print("stored collection ${collectionName}");
    tempBox.put(collectionName, collection);
  }

  void updateCollection(String oldCollection, String newCollection) {
    deleteCollection(oldCollection);
    storeCollection(newCollection);
  }

  /// Delete the [collectionName]
  void deleteCollection(String collectionName) {
    print("deleting collection: $collectionName");
    tempBox.delete(collectionName);
  }

  void deleteCard(int cardIndex) {
    print("deleted indexCard");
    collection.cards.removeAt(cardIndex);
  }

  void addIndexCard(IndexCard newIndexCard) {
    print("add indexCard");
    collection.cards.add(newIndexCard);
  }

  Future<String> requestIndexCard(String indexCardFront) {
    return api.fetchWord(word: indexCardFront);
  }

  List<String> getIndexCardWords() {
    List<String> tempList = [];
    for (var element in collection.cards) {
      tempList.add(element.front);
      tempList.add(element.back);
    }
    return tempList;
  }
}
