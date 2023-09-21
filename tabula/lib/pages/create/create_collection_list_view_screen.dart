import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabula/models/collection/card_info.dart';
import 'package:tabula/models/collection/collection.dart';

import 'package:tabula/models/session/create_session.dart';
import 'package:tabula/models/session/session.dart';
import 'package:tabula/pages/collection_screen.dart';
import 'package:tabula/pages/create/create_collection_card_view_screen.dart';
import 'package:tabula/pages/play_screen.dart';
import 'package:tabula/widgets/app_bar_widget.dart';
import 'package:tabula/widgets/card_list_tile.dart';
import 'package:tabula/models/collection/index_card.dart';
import 'package:tabula/widgets/create_ai_index_card_dialog_widget.dart';
import 'package:tabula/widgets/create_index_card_dialog_widget.dart';
import 'package:tabula/widgets/dialog_widget.dart';

// ignore: must_be_immutable
class CreateCollectionListViewScreen extends StatefulWidget {
  CreateCollectionListViewScreen({
    super.key,
    required this.amount,
    required this.categories,
    required this.collectionName,
    required this.collectionImageURL,
    required this.createCollection,
    required this.session,
  });
  String amount;
  List<String> categories;
  String collectionName;
  String collectionImageURL;
  bool createCollection;
  CreateSession session;

  @override
  State<CreateCollectionListViewScreen> createState() =>
      _CreateCollectionListViewScreenState();
}

class _CreateCollectionListViewScreenState
    extends State<CreateCollectionListViewScreen>
    with TickerProviderStateMixin {
  _CreateCollectionListViewScreenState();

  late TextEditingController nameController;
  // TODO refacor load indicator, use futureBuild, blocked by (2)
  // https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
  // https://stackoverflow.com/questions/57166726/how-to-show-a-progress-dialog-before-data-loading-in-flutter
  bool isFetching = false;
  bool isFetchError = false;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.collectionName);
    widget.session.collection.collectionName = widget.collectionName;
    if (widget.createCollection) {
      // return List<IndexCard> (2)
      // Make all other functions async and process the cards in the createSession method
      isFetching = true;
      widget.session
          .requestCollection(widget.amount, widget.categories)
          .then((String result) {
        setState(() {
          List<IndexCard> tempIndexCardList = [];
          String response = result;
          // String responseCut = response.substring(0, 15);
          try {
            var responseJSON = json.decode(response);
            List responseList = responseJSON.toList();
            responseList.forEach((element) {
              // JSON Object to tuple to eliminate labeling mistake
              // update request text
              // kein label
              // front und back label
              //  german und english label (sprachen label)
              // else error dialog
              IndexCard tempIndexCard = IndexCard(
                  cardID: "c0",
                  front: element["front"], // TODO mit index arbeiten
                  back: element["back"],
                  info: CardInfo());
              tempIndexCardList.add(tempIndexCard);
            });
          } catch (e) {
            isFetchError = true;
          } finally {
            isFetching = false;
          }
          widget.session.collection.cards = tempIndexCardList;
          print("++++++++++++++++++");
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Column(
        children: <Widget>[
          _buildHead(),
          _buildCreateIndexCard(),
          // FutureBuilder(future: _buildContentBody(), builder: builder)
          isFetching
              ? _buildLoadingIndicator()
              : (widget.session.collection.cards.isEmpty
                  ? (isFetchError
                      ? _buildFetchingError()
                      : _buildEmptyListAction())
                  : _buildContentBody()),
          _buildFloatingActionBtns(),
        ],
      ),
    );
  }

  Widget _buildHead() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: TextFormField(
          decoration: const InputDecoration(labelText: "Collection Name"),
          controller: nameController,
        ),
      ),
      Image.asset(
        "assets/resources/logo_card.png",
        fit: BoxFit.fill,
        scale: 4.0,
      ),
      Text("${widget.session.collection.cards.length} CARDS"),
      const SizedBox(
        width: 20.0,
      ),
    ]);
  }

  Widget _buildCreateIndexCard() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10.0,
      children: [
        FilledButton.icon(
            onPressed: () {
              CreateIndexCardDialogWidget(
                      context: context, notifyParent: addIndexCard)
                  .buildDialog();
              isFetchError = false;
            },
            icon: const Icon(Icons.add),
            label: const Text("add vocabularies")),
        const SizedBox(
          width: 10.0,
        ),
        FilledButton.icon(
            onPressed: () {
              CreateAIIndexCardDialogWidget(
                      context: context, notifyParent: extendCollection)
                  .buildDialog();
            },
            icon: const Icon(Icons.add),
            label: const Text("add AI generated vocabularies")),
        const SizedBox(
          height: 40.0,
        ),
      ],
    );
  }

  Widget _buildContentBody() {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          IndexCard tempIndexCard = widget.session.collection.cards[index];
          return CardListTile(
              index: index,
              front: tempIndexCard.front,
              back: tempIndexCard.back,
              notifyParent: deleteIndexCard);
        },
        itemCount: widget.session.collection.cards.length,
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }

  /// build circular progress widget for fetching AI data
  ///
  /// for customization see:
  /// https://api.flutter.dev/flutter/material/CircularProgressIndicator-class.html#material.CircularProgressIndicator.2
  Widget _buildLoadingIndicator() {
    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              semanticsLabel:
                  'Circular progress indicator for fetching data from AI',
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "Fetching index cards from AI",
                style: TextStyle(fontSize: 22.0),
              ))
        ]));
  }

  Widget _buildFetchErrorBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateCollectionListViewScreen(
                            createCollection: true,
                            amount: widget.amount,
                            categories: widget.categories,
                            collectionName: widget.collectionName,
                            collectionImageURL: "",
                            session: widget.session,
                          )), (r) {
                return false;
              });
            },
            icon: const Icon(Icons.loop),
            label: const Text("try again")),
        const SizedBox(
          width: 10.0,
        ),
        FilledButton.icon(
            onPressed: () {
              _buildExitDialog();
            },
            icon: const Icon(Icons.list),
            label: const Text("back to all collections")),
        const SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _buildFetchingError() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Error occurred",
            style: TextStyle(fontSize: 32.0, color: Colors.red),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Text("while fetching collection",
              style: TextStyle(fontSize: 30.0)),
          const SizedBox(
            height: 15.0,
          ),
          _buildFetchErrorBtn()
        ],
      ),
    );
  }

  Widget _buildEmptyListAction() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Collection is empty",
            style: TextStyle(fontSize: 30.0),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Text("ADD at least one index card",
              style: TextStyle(fontSize: 25.0)),
          const SizedBox(
            height: 15.0,
          ),
          _buildCreateIndexCard()
        ],
      ),
    );
  }

  Widget _buildFloatingActionBtns() {
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.all(20.0)),
              backgroundColor:
                  const MaterialStatePropertyAll(Colors.lightGreen),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          onPressed: () {
            if (widget.session.collection.cards.isNotEmpty && !isFetching) {
              widget.session
                  .setCollectionName(nameController.text, widget.categories)
                  .then((String name) {
                setState(() {
                  if (!widget.createCollection) {
                    widget.session.deleteCollection(widget.collectionName);
                  }
                  List<dynamic> collectionNames =
                      widget.session.getCollectionNames();
                  int index = 0;
                  String tempName = name;
                  while (collectionNames.contains(tempName)) {
                    index++;
                    tempName = name;
                    tempName = tempName + " ($index)";
                  }
                  if (index > 0) {
                    name = name + " ($index)";
                  }
                  widget.session.storeCollection(name);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CollectionScreen()), (r) {
                    return false;
                  });
                });
              });
            }
          },
          child: const Text(
            'SAVE COLLECTION',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        const SizedBox(
          height: 80.0,
        ),
        ElevatedButton(
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.all(20.0)),
              backgroundColor: const MaterialStatePropertyAll(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          onPressed: () {
            _buildExitDialog();
          },
          child: const Text(
            'CANCEL COLLECTION',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        const SizedBox(
          height: 80.0,
        ),
      ],
    );
  }

  /// Build the custom exit Dialog Widget
  Future<void> _buildExitDialog() {
    return DialogWidget(
            title: "Cancel Session?",
            icon: const Icon(
              Icons.question_mark,
              color: Colors.white,
              size: 50.0,
            ),
            content: _buildDialogContent(),
            context: context,
            fontSizeTitle: 30.0)
        .buildDialog();
  }

  Widget _buildDialogContent() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
            onPressed: () => {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => CollectionScreen()),
                  (r) {
                return false;
              })
            },
            child: const Text("cancel\ncollection\ncreation"),
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(Colors.green),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
            onPressed: () => {Navigator.pop(context)},
            child: const Text("continue\ncollection\ncreation"),
          ),
        ),
      ],
    );
  }

  deleteIndexCard(cardIndex) {
    setState(() {
      isFetchError = false;
      widget.session.deleteCard(cardIndex);
      widget.session.collection = widget.session.getCollection();
    });
  }

  addIndexCard(newIndexCard) {
    widget.session.requestIndexCard(newIndexCard).then((String backIndexCard) {
      setState(() {
        isFetchError = false;
        IndexCard tempIndexCard = IndexCard(
            cardID: "",
            front: newIndexCard,
            back: backIndexCard,
            info: CardInfo());
        widget.session.addIndexCard(tempIndexCard);
        widget.session.collection = widget.session.getCollection();
      });
    });
  }

  extendCollection(extAmount) {
    setState(() {
      isFetching = true;
    });
    print("AMOUNT EXTENDCOLLECTION: $extAmount");
    List<String> currentIndexCardWords = widget.session.getIndexCardWords();
    widget.session
        .requestExtendCollection(
            extAmount, widget.categories, currentIndexCardWords)
        .then((String result) {
      setState(() {
        List<IndexCard> tempIndexCardList = [];
        String response = result;
        try {
          var responseJSON = json.decode(response);
          List responseList = responseJSON.toList();
          responseList.forEach((element) {
            IndexCard tempIndexCard = IndexCard(
                cardID: "c0",
                front: element["front"],
                back: element["back"],
                info: CardInfo());
            tempIndexCardList.add(tempIndexCard);
          });
        } catch (e) {
          _buildFetchingErrorDialog();
        } finally {
          isFetching = false;
        }
        widget.session.collection.cards.addAll(tempIndexCardList);
        print("EXTEND - ++++++++++++++++++");
      });
    });
  }

  /// Build the custom exit Dialog Widget
  Future<void> _buildFetchingErrorDialog() {
    return DialogWidget(
            title: "Fetching Error!",
            icon: const Icon(
              Icons.error,
              color: Colors.white,
              size: 50.0,
            ),
            content: const Text(
              textAlign: TextAlign.center,
              "A Error accurred while fetching new data.\nPlease try again!",
              style: TextStyle(fontSize: 22.0),
            ),
            context: context,
            fontSizeTitle: 30.0)
        .buildDialog();
  }
}
