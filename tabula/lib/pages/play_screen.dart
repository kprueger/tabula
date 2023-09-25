import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tabula/models/collection/index_card.dart';
import 'package:tabula/models/session/play_session.dart';
import 'package:tabula/pages/statistic_screen.dart';
import 'package:tabula/widgets/index_card_widget.dart';
import 'package:tabula/widgets/app_bar_widget.dart';
import 'package:tabula/widgets/dialog_widget.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PlayScreen extends StatefulWidget {
  PlayScreen({
    Key? key,
    required this.collectionName,
    required this.collectionImageURL,
    required this.session,
    required this.random,
    required this.quick,
    required this.takeFront,
    required this.wrongIndexCardsCollection,
  }) : super(key: key);
  String collectionName;
  String collectionImageURL;
  PlaySession session;
  bool random;
  bool quick;
  bool takeFront;
  List<IndexCard> wrongIndexCardsCollection;

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  CardSwiperController controller = CardSwiperController();
  late List<IndexCard> cards;

  List<IndexCard> wrongCards = [];
  int currentIndex = 1;
  int maxCards = 0;
  Color colorRight = Colors.grey;
  Color colorLeft = Colors.grey;
  Color colorUp = Colors.grey;
  int _visibleCards = 2;

  @override
  void initState() {
    // print(
    //     "QUICK PLAYSCREEN: ${widget.quick} + RANDOM PLAYSCREEN: ${widget.random}");
    if (widget.quick) {
      // print("PLAY QUICK");
      widget.session.quickSession(widget.collectionName);
    } else if (widget.random) {
      // print("PLAY RANDOM");
      widget.session.randomSession(widget.collectionName);
    } else if (widget.wrongIndexCardsCollection.isEmpty) {
      // print("PLAY NORMAL");
      widget.session.loadCollection(widget.collectionName);
    } else {
      // print("PLAY MISSED CARDS");
      widget.session.collection.collectionName = widget.collectionName;
      widget.session.collection.cards = widget.wrongIndexCardsCollection;
    }

    cards = widget.session.collection.cards;
    super.initState();

    if (widget.wrongIndexCardsCollection.length == 1) {
      _visibleCards = 1;
    }
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
                      onEnd: _onEnd,
                      onSwipeDirectionChange: _onSwipeDirectionChange,
                      isLoop: false,
                      numberOfCardsDisplayed: _visibleCards,
                      allowedSwipeDirection: AllowedSwipeDirection.only(
                          up: true, left: true, right: true, down: true),
                      backCardOffset: const Offset(25, 15),
                      padding: const EdgeInsets.fromLTRB(75, 90, 75, 150),
                      cardBuilder: (context,
                          index,
                          horizontalThresholdPercentage,
                          verticalThresholdPercentage) {
                        return IndexCardWidget(
                            indexCard: cards[index],
                            takeFront: widget.takeFront);
                      }),
                  Positioned(
                    left: 5,
                    top: MediaQuery.of(context).size.height / 1.77 - 200,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "btn:cardview:pre",
                          onPressed: () {
                            setState(() {
                              colorLeft = Colors.red;
                            });

                            controller.swipeLeft();
                          },
                          backgroundColor: colorLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.fastOutSlowIn,
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorLeft,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 30.0,
                            ),
                          ),
                        ),
                        const Text("unknown"),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: MediaQuery.of(context).size.height / 1.77 - 200,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "btn:cardview:next",
                          onPressed: () {
                            setState(() {
                              colorRight = Colors.green;
                            });

                            controller.swipeRight();
                          },
                          backgroundColor: colorRight,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.fastOutSlowIn,
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorRight,
                            ),
                            child: const Icon(
                              Icons.done,
                              size: 30.0,
                            ),
                          ),
                        ),
                        const Text("known"),
                      ],
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 30,
                    top: 10,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "btn:cardview:delcard",
                          onPressed: () {
                            setState(() {
                              colorUp = Colors.purple;
                            });

                            controller.swipeTop();
                            //_deleteCard(cardIndex: currentIndex);
                          },
                          backgroundColor: colorUp,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.fastOutSlowIn,
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorUp,
                            ),
                            child: const Icon(
                              Icons.logout,
                              size: 30.0,
                            ),
                          ),
                        ),
                        const Text("finish session"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

    if (currentIndex == null) {
      return true;
    }

    if (direction == CardSwiperDirection.top) {
      _buildExitDialog();
    } else if (direction == CardSwiperDirection.right) {
      _updateCurrentIndex(newIndex: (currentIndex! + 1));
    } else if (direction == CardSwiperDirection.left) {
      HapticFeedback.vibrate();
      buildVocabularyDialog();
      _updateCurrentIndex(newIndex: (currentIndex! + 1));
    } else if (direction == CardSwiperDirection.bottom) {
      Future.delayed(const Duration(milliseconds: 50), () {
        controller.undo();
      });
    }

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint('The card $currentIndex was undo from the ${direction.name}');
    _updateCurrentIndex(newIndex: (currentIndex = previousIndex!));
    //_updateCurrentIndex(newIndex: (currentIndex - 1));
    return true;
  }

  dynamic _onSwipeDirectionChange(
      CardSwiperDirection x, CardSwiperDirection y) {
    print("x: ${x} y: $y");

    if (x == CardSwiperDirection.right) {
      setState(() {
        colorRight = Colors.green;
        colorLeft = Colors.grey;
        colorUp = Colors.grey;
      });
    } else if (x == CardSwiperDirection.left) {
      setState(() {
        colorLeft = Colors.red;
        colorRight = Colors.grey;
        colorUp = Colors.grey;
      });
    }

    if (y == CardSwiperDirection.top) {
      setState(() {
        colorUp = Colors.purple;
        colorLeft = Colors.grey;
        colorRight = Colors.grey;
      });
    } else if (y == CardSwiperDirection.bottom) {
      setState(() {
        colorUp = Colors.grey;
      });
    } else {
      setState(() {
        colorRight = Colors.grey;
        colorLeft = Colors.grey;
        colorUp = Colors.grey;
      });
    }
  }

  Future<bool> _onEnd(
    CardSwiperDirection direction,
  ) async {
    print(
        'current: $currentIndex cards.length: ${cards.length} direction: ${direction}');

    if (currentIndex == cards.length && direction == CardSwiperDirection.top) {
      maxCards = currentIndex - 1;
    } else {
      maxCards = cards.length;
    }

    if (direction == CardSwiperDirection.left) {
      await buildVocabularyDialog();
    }

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => StatisticScreen(
                  wrongCards: wrongCards,
                  maxCards: maxCards,
                  amount: widget.session.collection.cards.length.toString(),
                  collectionName: widget.collectionName,
                  collectionImageURL: widget.collectionImageURL,
                  session: PlaySession(),
                  takeFront: widget.takeFront,
                  random: widget.random,
                  quick: widget.quick,
                )), (r) {
      return false;
    });
    return true;
  }

  void _updateCurrentIndex({required int newIndex}) {
    setState(() {
      currentIndex = newIndex;
    });
  }

  Widget _buildHead() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      const SizedBox(
        width: 20.0,
      ),
      Expanded(
          child: Text(
        widget.collectionName,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      )),
      Image.asset(
        "assets/resources/logo_card.png",
        fit: BoxFit.fill,
        scale: 4.0,
      ),
      Text("$currentIndex of ${widget.session.collection.cards.length} CARDS"),
      const SizedBox(
        width: 20.0,
      ),
    ]);
  }

  Future<void> buildVocabularyDialog() {
    wrongCards.add(cards[currentIndex - 1]);
    return DialogWidget(
      title: "Oh no, next time",
      icon: const Icon(
        Icons.translate,
        color: Colors.white,
        size: 50.0,
      ),
      content: _vocabularyDialog(),
      context: context,
      fontSizeTitle: 30.0,
    ).buildDialog();
  }

  Widget _vocabularyDialog() {
    return Column(
      children: [
        const Text(
          "translates from",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
          ),
        ),
        Text(
          widget.takeFront
              ? cards[currentIndex - 1].front
              : cards[currentIndex - 1].back,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 32),
        ),
        const Text(
          "to",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
          ),
        ),
        Text(
          widget.takeFront
              ? cards[currentIndex - 1].back
              : cards[currentIndex - 1].front,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 32),
        ),
        const SizedBox(
            height:
                20.0), // Adjust the spacing between the text and the close button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Colors.purple),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
          ),
          child: const Text(
            'Close',
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<void> _buildExitDialog() {
    return DialogWidget(
            title: "Cancel play session?",
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
              maxCards = currentIndex - 1,
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StatisticScreen(
                          wrongCards: wrongCards,
                          maxCards: maxCards,
                          amount:
                              widget.session.collection.cards.length.toString(),
                          collectionName: widget.collectionName,
                          collectionImageURL: widget.collectionImageURL,
                          takeFront: widget.takeFront,
                          random: widget.random,
                          quick: widget.quick,
                          session: PlaySession())), (r) {
                return false;
              })
            },
            child: const Text("Cancel play session"),
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
            onPressed: () => {controller.undo(), Navigator.pop(context)},
            child: const Text("Continue session"),
          ),
        ),
      ],
    );
  }
}
