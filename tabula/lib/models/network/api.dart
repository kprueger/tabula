import 'package:dart_openai/dart_openai.dart';
import 'package:tabula/models/network/request.dart';

class Api {
  Request request = Request();

  Future<String> fetchWord({required String word}) {
    String wordRequest = request.buildWordRequest(word: word);
    return _fetchData(request: wordRequest);
  }

  Future<String> fetchCollection(
      {required String amount, required List<String> categories}) {
    print("amount of index cards to request: " + amount);
    String collectionRequest =
        request.buildCollectionRequest(amount: amount, categories: categories);
    return _fetchData(request: collectionRequest);
  }

  Future<String> fetchExtendCollection(
      {required String amount,
      required List<String> categories,
      required List<String> indexCardWords}) {
    String extendCollectionRequest = request.buildExtendedCollectionRequest(
        amount: amount, categories: categories, indexCardWords: indexCardWords);
    return _fetchData(request: extendCollectionRequest);
  }

  Future<String> fetchInfo({required String front, required String back}) {
    String infoRequest = request.buildInfoRequest();
    return _fetchData(request: infoRequest);
  }

  Future<String> fetchHelp({required String back}) {
    String helpRequest = request.buildHelpRequest();
    return _fetchData(request: helpRequest);
  }

  Future<String> fetchCollectionName({required List<String> categories}) {
    String nameRequest =
        request.buildCollectionNameRequest(categories: categories);
    return _fetchData(request: nameRequest);
  }

  Future<String> _fetchData({required String request, bool chatModel = true}) {
    print("API.fetchData() CALLED");
    print("called chatGPT");
    print("Request length: " + request.length.toString());

    return chatModel
        ? _turboModel(request: request)
        : _davinciModel(request: request);
  }

  Future<String> _turboModel({required String request}) async {
    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: 'gpt-3.5-turbo',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: request,
            role: OpenAIChatMessageRole.user,
          ),
        ],
        temperature: 1.0,
      );

      _printAPIResponse(response: chatCompletion.choices.first.message.content);

      return chatCompletion.choices.first.message.content;
    } catch (e) {
      return "";
    }
  }

  Future<String> _davinciModel({required String request}) async {
    try {
      OpenAICompletionModel completion =
          await OpenAI.instance.completion.create(
        model: "text-davinci-003",
        prompt: request,
        maxTokens: 2048,
        temperature: 0.5,
        n: 1,
        // stop: "",
        echo: true,
      );
      int requestLength = request.length;
      var response = completion.choices.first.text.substring(requestLength);

      _printAPIResponse(response: response);

      return response;
    } catch (e) {
      return "";
    }
  }

  void _printAPIResponse({required String response}) {
    print("++++++++++++++++++++++++++++");
    print(response);
    print("++++++++++++++++++++++++++++");
    print(response.substring(response.length - 2));
    print("++++++++++++++++++++++++++++");
  }
}
