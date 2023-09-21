class Request {
  // Refactor: Each request get their own class

  // Holding the possible requests for the AI

  /// WORD REQUEST
  static const String wordRequestPart1 = "Translate the given word: ";

  static const String wordRequestPart2 =
      "If the given word is german translate it to english else to german";

  static const String wordRequestPart3 =
      "Important, respond only the translation, no more words! No punctuation character either";

  /// (EXTEND) COLLECTION REQUEST

  static const String tupelRequest =
      "list the words and it's translation as one labeled tupel list. No sub objects, all tupels in one list";

  static const String JSONFormatRequest =
      "Return the values always in the given format: {[{'front': 'placeholder', 'back': ''placeholder2'}, {'front': 'placeholder3', 'back': ''placeholder4'}}]}";

  static const String labelRequest =
      "Important, Label the words as 'front' and 'back'";

  static const String validJSONrequest = "The output has to be valid JSON";

  static const String keepFormat = "Keep always the same list format";

  static const String JSONOnlyRequest =
      "Important, respond only the JSON content. No more words!";

  static const String listLabelRequest = "The JSON list does not have a label!";

  static const String categoriesRequest =
      "Each word must match at least one of the categories semantic family: ";

  static const String jsonOnlyRequest = "Only return the JSON list, not more";

  /// EXTEND COLLECTION REQUEST (EXTRA REQUEST)

  static const String extendRequest =
      "Important, each new word does not match the following wordlist: ";

  // Variants/Options
  // List me 50 random english words and it's german translation as a tupel list. The output has to be a valid JSON.
  // [apple, bug, Tomaten, socks, one, Hals]

  static const String infoRequest = "";

  static const String helpRequest = "";

  String buildWordRequest({required String word}) {
    return "$wordRequestPart1$word. $wordRequestPart2. $wordRequestPart3";
  }

  String buildCollectionRequest(
      {required String amount,
      required List<String> categories,
      String languageOne = "german",
      String languageTwo = "english"}) {
    return "Give $amount $languageOne words and it's $languageTwo translation based on the list of categories: $categories, and $tupelRequest. $labelRequest. $validJSONrequest. $keepFormat. $JSONOnlyRequest $listLabelRequest $JSONFormatRequest";
  }

  String buildExtendedCollectionRequest(
      {required String amount,
      required List<String> categories,
      required List<String> indexCardWords,
      String languageOne = "german",
      String languageTwo = "english"}) {
    return "Give $amount $languageOne words and it's $languageTwo translation based on the list of categories: $categories, and $tupelRequest. $labelRequest. $extendRequest $indexCardWords. $validJSONrequest. $keepFormat. $JSONOnlyRequest $listLabelRequest $JSONFormatRequest";
  }

  String buildImageRequest(
      {required List<String> wordList,
      String languageOne = "german",
      String languageTwo = "english"}) {
    return "Translate the words of the given list to $languageOne or vice versa $languageTwo and $tupelRequest. $labelRequest. $validJSONrequest. Word list: $wordList";
  }

  String buildInfoRequest() {
    // TODO
    return infoRequest;
  }

  String buildHelpRequest() {
    // TODO
    return helpRequest;
  }

  String buildCollectionNameRequest({required List<String> categories}) {
    return "Give a unique collection name (One to three words) based on the collection categories: " +
        categories.toString();
  }
}
