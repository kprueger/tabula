/*import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import 'package:tabula/models/collection/index_card.dart';
import 'package:tabula/models/session/create_session.dart';
import 'package:tabula/pages/collection_screen.dart';
import 'package:tabula/pages/create/create_collection_list_view_screen.dart';
import 'package:tabula/widgets/index_card_widget.dart';
import 'package:tabula/widgets/app_bar_widget.dart';

// ignore: must_be_immutable
class CreateCollectionCardViewScreen extends StatefulWidget {
  CreateCollectionCardViewScreen(
      {Key? key,
      required this.amount,
      required this.categories,
      required this.collectionName,
      required this.collectionImageURL,
      required this.session})
      : super(key: key);
  String amount;
  List<String> categories;
  String collectionName;
  String collectionImageURL;
  CreateSession session;

  @override
  _CreateCollectionCardViewScreenState createState() =>
      _CreateCollectionCardViewScreenState();
}

class _CreateCollectionCardViewScreenState
    extends State<CreateCollectionCardViewScreen> {
  late TextEditingController nameController;
  CardSwiperController controller = CardSwiperController();
  late List<IndexCard> cards;
  int currentIndex = 1;
  String indexCardSide = "FRONT";

  @override
  void initState() {
    nameController = TextEditingController(text: widget.collectionName);
    cards = widget.session.collection.cards;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHead(),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CardSwiper(
                      controller: controller,
                      cardsCount: cards.length,
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                      numberOfCardsDisplayed: 2,
                      backCardOffset: const Offset(25, 15),
                      padding: const EdgeInsets.fromLTRB(75, 90, 75, 250),
                      cardBuilder: (context, index) {
                        return IndexCardWidget(indexCard: cards[index]);
                      }),
                  Positioned(
                    left: 5,
                    top: MediaQuery.of(context).size.height / 2 - 200,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "btn:cardview:pre",
                          onPressed: () {
                            //controller.undo();
                          },
                          backgroundColor: Colors.grey,
                          child: const Icon(
                            Icons.remove,
                            size: 40.0,
                          ),
                        ),
                        const Text("pre"),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: MediaQuery.of(context).size.height / 2 - 200,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "btn:cardview:next",
                          onPressed: () {
                            controller.swipeRight();
                          },
                          backgroundColor: Colors.grey,
                          child: const Icon(
                            Icons.add,
                            size: 40.0,
                          ),
                        ),
                        const Text("next"),
                      ],
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 30,
                    top: 20,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "btn:cardview:delcard",
                          onPressed: () {
                            controller.swipeTop();
                            //_deleteCard(cardIndex: currentIndex);
                          },
                          backgroundColor: Colors.grey,
                          child: const Icon(
                            Icons.close,
                            size: 40.0,
                          ),
                        ),
                        const Text("delete card"),
                        Text(indexCardSide),
                      ],
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 30,
                    bottom: 180,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "btn:cardview:listview",
                          onPressed: () {
                            controller.swipeBottom();
                            /*Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateCollectionListViewScreen(
                                          amount: widget.amount,
                                          categories: widget.categories,
                                          collectionName: nameController.text,
                                          collectionImageURL:
                                              widget.collectionImageURL,
                                          createCollection: false,
                                          session: widget.session,
                                        )), (r) {
                              return false;
                            });*/
                          },
                          backgroundColor: Colors.grey,
                          child: const Icon(
                            Icons.list,
                            size: 40.0,
                          ),
                        ),
                        const Text("list view"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildFloatingActionBtns(),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
        'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top');

    if(direction == CardSwiperDirection.top) {
      _deleteCard(cardIndex: currentIndex!);
    }

    else if (direction == CardSwiperDirection.bottom) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CreateCollectionListViewScreen(
                    amount: widget.amount,
                    categories: widget.categories,
                    collectionName: nameController.text,
                    collectionImageURL:
                    widget.collectionImageURL,
                    createCollection: false,
                    session: widget.session,
                  )), (r) {
        return false;
      });
    }

    else if (direction == CardSwiperDirection.right) {
      _updateCurrentIndex(newIndex: (currentIndex! + 1));
    }

    else if (direction == CardSwiperDirection.left) {
      _updateCurrentIndex(newIndex: (currentIndex! - 1));
      controller.undo();
    }

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint('The card $currentIndex was undo from the ${direction.name}');
    _updateCurrentIndex(newIndex: (currentIndex - 1));
    return true;
  }

  void _updateCurrentIndex({required int newIndex}) {
    setState(() {
      currentIndex = newIndex;
    });
  }

  void _deleteCard({required int cardIndex}) {
    setState(() {
      widget.session.deleteCard(currentIndex);
    });
  }

  Widget _buildHead() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: TextFormField(
          decoration: const InputDecoration(
              labelText: "Collection Name (AI generated)"),
          controller: nameController,
        ),
      ),
      Image.asset(
        "resources/logo_card.png",
        fit: BoxFit.fill,
        scale: 4.0,
      ),
      Text("$currentIndex of ${widget.session.collection.cards.length} CARDS"),
      const SizedBox(
        width: 20.0,
      ),
    ]);
  }

  Widget _buildStoreCollectionBtn() {
    return ElevatedButton(
      style: ButtonStyle(
          padding: const MaterialStatePropertyAll(EdgeInsets.all(20.0)),
          backgroundColor: const MaterialStatePropertyAll(Colors.lightGreen),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
      onPressed: () {
        widget.session.storeCollection(nameController.text);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const CollectionScreen()),
            (r) {
          return false;
        });
      },
      child: const Text(
        'SAVE COLLECTION',
        style: TextStyle(fontSize: 30.0),
      ),
    );
  }

  Widget _buildCancelCollectionBtn() {
    return ElevatedButton(
      style: ButtonStyle(
          padding: const MaterialStatePropertyAll(EdgeInsets.all(20.0)),
          backgroundColor: const MaterialStatePropertyAll(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
      onPressed: () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const CollectionScreen()),
            (r) {
          return false;
        });
      },
      child: const Text(
        'CANCEL COLLECTION',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget _buildFloatingActionBtns() {
    return Wrap(
      alignment: WrapAlignment.center,
      // direction: Axis.vertical,
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
            widget.session.storeCollection(nameController.text);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const CollectionScreen()), (r) {
              return false;
            });
          },
          child: const Text(
            'SAVE COLLECTION',
            style: TextStyle(fontSize: 30.0),
          ),
        ),
        const SizedBox(
          height: 12.0,
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
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const CollectionScreen()), (r) {
              return false;
            });
          },
          child: const Text(
            'CANCEL COLLECTION',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
      ],
    );
  }
}*/