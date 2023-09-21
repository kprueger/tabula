import 'package:flutter/material.dart';
import 'package:tabula/models/session/create_session.dart';
import 'package:tabula/models/session/play_session.dart';
import 'package:tabula/pages/create/create_collection_list_view_screen.dart';
import 'package:tabula/pages/play_screen.dart';
import 'package:tabula/widgets/dialog_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

// ignore: must_be_immutable
class CollectionListTile extends StatefulWidget {
  CollectionListTile(
      {super.key, required this.name, required this.notifyParent});
  String name;
  final Function(String) notifyParent;

  @override
  _CollectionListTileState createState() => _CollectionListTileState();
}

class _CollectionListTileState extends State<CollectionListTile> {
  //_CollectionListTileState();
  CreateSession session = CreateSession();
  bool _enabledSide = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        enabled: _enabledSide,
        // This sets text color and icon color to red when list tile is disabled and
        // green when list tile is selected, otherwise sets it to black.
        // This sets text color and icon color to red when list tile is disabled and
        // green when list tile is selected, otherwise sets it to black.
        textColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.deepPurple;
          }

          return Colors.purple;
        }),
        leading: const Icon(Icons.public),
        title: const Text(
          'Language',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        //subtitle: Text(_enabledSide ? 'DE -> EN' : 'EN -> DE',
        //style: const TextStyle(fontSize: 14),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _enabledSide ? 'DE -> EN' : 'EN -> DE',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Switch(
              onChanged: (bool? value) {
                // This is called when the user toggles the switch.
                setState(() {
                  _enabledSide = value!;
                });
                if (_enabledSide) {
                  print("FUNCTION WHEN TURNED ON");
                } else {
                  print("FUNCTION WHEN TURNED OFF");
                }
              },
              value: _enabledSide,
            ),
          ],
        ),
      ),
      Dismissible(
        direction: DismissDirection.horizontal,
        background: Container(
          padding: const EdgeInsets.only(left: 16.0),
          color: Colors.amberAccent,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ),
        secondaryBackground: Container(
          padding: const EdgeInsets.only(right: 16.0),
          color: Colors.red,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            widget.notifyParent(widget.name);
          }
        },
        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.endToStart) {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) {
                return _buildDismissableDialog();
              },
            );
            print('Deletion confirmed: $confirmed');
            return confirmed;
          } else {
            session.loadCollection(widget.name);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateCollectionListViewScreen(
                        amount: session.collection.cards.length.toString(),
                        categories: session.collection.categories,
                        collectionName: widget.name,
                        collectionImageURL: "",
                        createCollection: false,
                        session: session)), (r) {
              return false;
            });
            return false;
          }
        },
        key: Key(widget.name),
        child: ListTile(
          // leading: TextButton(
          //   style: const ButtonStyle(
          //       backgroundColor: MaterialStatePropertyAll(Colors.amberAccent)),
          //   child: const Icon(
          //     Icons.edit,
          //     color: Colors.white,
          //     size: 40.0,
          //   ),
          //   onPressed: () => {
          //     session.loadCollection(widget.name),
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => CreateCollectionListViewScreen(
          //                 amount: session.collection.cards.length.toString(),
          //                 categories: session.collection.categories,
          //                 collectionName: widget.name,
          //                 collectionImageURL: "",
          //                 createCollection: false,
          //                 session: session)), (r) {
          //       return false;
          //     })
          //   },
          // ),
          title: Text(widget.name,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          // trailing: Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     IconButton(
          //       tooltip: "Start a quick play session",
          //       icon: const Icon(Icons.alarm_add, color: Colors.grey),
          //       onPressed: () => {
          //         Navigator.pushAndRemoveUntil(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => PlayScreen(
          //                     collectionName: widget.name,
          //                     quick: true,
          //                     random: false,
          //                     collectionImageURL: '',
          //                     takeFront: _enabledSide,
          //                     wrongIndexCardsCollection: const [],
          //                     session: PlaySession())), (r) {
          //           return false;
          //         })
          //       },
          //     ),
          //     const SizedBox(
          //       width: 14.0,
          //     ),
          //     IconButton(
          //       tooltip: "Start a random order play session",
          //       icon: const Icon(Icons.shuffle, color: Colors.grey),
          //       onPressed: () => {
          //         Navigator.pushAndRemoveUntil(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => PlayScreen(
          //                     collectionName: widget.name,
          //                     quick: false,
          //                     random: true,
          //                     collectionImageURL: '',
          //                     takeFront: _enabledSide,
          //                     wrongIndexCardsCollection: const [],
          //                     session: PlaySession())), (r) {
          //           return false;
          //         })
          //       },
          //     ),
          //     const SizedBox(
          //       width: 14.0,
          //     ),
          //     /*TextButton(
          //       style: const ButtonStyle(
          //           backgroundColor: MaterialStatePropertyAll(Colors.red)),
          //       child: const Icon(
          //         Icons.close,
          //         color: Colors.white,
          //         size: 40.0,
          //       ),
          //       onPressed: () => {_buildDeleteDialog()},
          //     ),*/
          //   ],
          // ),
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => PlayScreen(
                        collectionName: widget.name,
                        quick: false,
                        random: true,
                        collectionImageURL: '',
                        takeFront: _enabledSide,
                        wrongIndexCardsCollection: const [],
                        session: PlaySession())), (r) {
              return false;
            });
          },
        ),
      ),
    ]);
  }

  Widget _buildDismissableDialog() {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      backgroundColor: Colors.blue,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 50.0,
                ),
                const Expanded(
                  child: Text(
                    "delete collection?",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ))),
                    onPressed: () => {Navigator.pop(context, false)},
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 50.0,
                    )),
              ],
            ),
            const SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                    onPressed: () => {Navigator.pop(context, false)},
                    child: const Text(
                      "keep collection",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                    onPressed: () => {Navigator.pop(context, true)},
                    child: const Text("delete collection",
                        style: TextStyle(fontSize: 20.0)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25.0,
            ),
          ],
        ),
      ),
    );
  }

  /// Build the custom exit Dialog Widget
  Future<void> _buildDeleteDialog() {
    return DialogWidget(
            title: "Delete Collection?",
            icon: const Icon(
              Icons.delete,
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
              // session.deleteCollection(widget.name),
              widget.notifyParent(widget.name),
              Navigator.pop(context)
            },
            child: const Text("delete collection"),
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
            child: const Text("keep collection"),
          ),
        ),
      ],
    );
  }
}
