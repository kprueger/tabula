import 'package:flutter/material.dart';
import 'package:tabula/models/collection/index_card.dart';
import 'package:tabula/models/session/create_session.dart';
import 'package:tabula/models/session/play_session.dart';
import 'package:tabula/pages/collection_screen.dart';
import 'package:tabula/pages/play_screen.dart';
import 'package:tabula/widgets/app_bar_widget.dart';

// ignore: must_be_immutable
class StatisticScreen extends StatefulWidget {
  StatisticScreen(
      {Key? key,
      required this.wrongCards,
      required this.maxCards,
      required this.amount,
      required this.collectionName,
      required this.collectionImageURL,
      required this.takeFront,
      required this.random,
      required this.quick,
      required this.session})
      : super(key: key);

  List<IndexCard> wrongCards;
  int maxCards;
  String amount;
  String collectionName;
  String collectionImageURL;
  bool random;
  bool quick;
  bool takeFront;
  PlaySession session;

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late double successRate;
  @override
  void initState() {
    successRate = (widget.maxCards != 0)
        ? ((1 - (widget.wrongCards.length / widget.maxCards)) * 100)
        : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_buildHead(), _buildBodyContent()],
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Row(
      children: [
        const SizedBox(
          width: 18.0,
        ),
        const Expanded(
          child: Text(
            "Statistics",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
        ),
        Image.asset(
          "assets/resources/logo_card.png",
          fit: BoxFit.fill,
          scale: 4.0,
        )
      ],
    );
  }

  Widget _buildBodyContentRow({required String label, required String value}) {
    return Row(
      children: [
        const SizedBox(
          width: 18.0,
        ),
        Expanded(
          child: Text(
            "$label:",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          width: 15.0,
        )
      ],
    );
  }

  Widget _buildBodyContent() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 25.0,
        ),
        Text(
          widget.collectionName,
          textAlign: TextAlign.center,
          //style: Theme.of(context).textTheme.headlineLarge
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 42),
        ),
        /*_buildBodyContentRow(
            label: "Played collection", value: widget.collectionName),*/
        const SizedBox(
          height: 40.0,
        ),
        _buildBodyContentRow(
            label: "Swiped cards", value: widget.maxCards.toString()),
        const SizedBox(
          height: 10.0,
        ),
        _buildBodyContentRow(
            label: "Correctly swiped",
            value: (widget.maxCards - widget.wrongCards.length).toString()),
        const SizedBox(
          height: 10.0,
        ),
        _buildBodyContentRow(
            label: "Success rate",
            value: "${successRate.toStringAsFixed(2).toString()} %"),
        const SizedBox(height: 40),
        SizedBox(
          width: 280.0,
          child: ElevatedButton(
            style: ButtonStyle(
                padding: const MaterialStatePropertyAll(EdgeInsets.all(20.0)),
                backgroundColor: const MaterialStatePropertyAll(Colors.purple),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ))),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => CollectionScreen()),
                  (r) {
                return false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.list),
                Text(
                  "back to collection view",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 280.0,
          child: ElevatedButton(
            style: ButtonStyle(
                padding: const MaterialStatePropertyAll(EdgeInsets.all(20.0)),
                backgroundColor: const MaterialStatePropertyAll(Colors.purple),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ))),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlayScreen(
                            collectionName: widget.collectionName,
                            collectionImageURL: widget.collectionImageURL,
                            session: PlaySession(),
                            random: widget.random,
                            quick: widget.quick,
                            takeFront: widget.takeFront,
                            wrongIndexCardsCollection: const [],
                          )), (r) {
                return false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.loop),
                Text(
                  "play collection again",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 280.0,
          child: ElevatedButton(
            style: ButtonStyle(
                padding: const MaterialStatePropertyAll(EdgeInsets.all(20.0)),
                backgroundColor: const MaterialStatePropertyAll(Colors.purple),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ))),
            onPressed: () {
              widget.wrongCards.isEmpty
                  ? null
                  : Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayScreen(
                                collectionName: widget.collectionName,
                                collectionImageURL: widget.collectionImageURL,
                                session: PlaySession(),
                                random: false,
                                quick: false,
                                takeFront: widget.takeFront,
                                wrongIndexCardsCollection: widget.wrongCards,
                              )), (r) {
                      return false;
                    });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.close),
                Text(
                  "retry unknown vokabularies",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
