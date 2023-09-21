import 'package:flutter/material.dart';

import 'package:tabula/models/session/create_session.dart';
import 'package:tabula/pages/collection_screen.dart';
import 'package:tabula/widgets/dialog_widget.dart';

// ignore: must_be_immutable
class CardListTile extends StatefulWidget {
  CardListTile(
      {super.key,
      required this.index,
      required this.front,
      required this.back,
      required this.notifyParent});
  int index;
  String front;
  String back;
  final Function(int) notifyParent;

  @override
  _CardListTileState createState() => _CardListTileState();
}

class _CardListTileState extends State<CardListTile> {
  _CardListTileState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
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
          widget.notifyParent(widget.index);
        }
      },
      confirmDismiss: (DismissDirection direction) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return _buildDismissableDialog();
          },
        );
        print('Deletion confirmed (index card): $confirmed');
        return confirmed;
      },
      key: Key(widget.front),
      child: ListTile(
        enabled: true,
        title: Text(widget.front,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        subtitle: Text(widget.back),
        onTap: () {},
      ),
    );

    // ListTile(
    //   enabled: true,
    //   /*leading: IconButton(
    //     tooltip: "Sort the index cards by dragging them on place",
    //     icon: const Icon(Icons.format_line_spacing, color: Colors.grey),
    //     onPressed: () => {},
    //   ),*/
    //   title: Text(widget.front,
    //       style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    //   subtitle: Text(widget.back),
    //   trailing: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       /*IconButton(
    //         tooltip: "Swap the sides of the index card",
    //         icon: const Icon(Icons.swap_horiz, color: Colors.grey),
    //         onPressed: () => {},
    //       ),*/
    //       const SizedBox(
    //         width: 14.0,
    //       ),
    //       TextButton(
    //         style: const ButtonStyle(
    //             backgroundColor: MaterialStatePropertyAll(Colors.red)),
    //         child: const Icon(
    //           Icons.close,
    //           color: Colors.white,
    //           size: 40.0,
    //         ),
    //         onPressed: () => {
    //           _buildDeleteDialog(),
    //         },
    //       ),
    //     ],
    //   ),
    //   onTap: () {},
    // );
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
                    "Delete IndexCard?",
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
                      "keep card",
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
                    child: const Text("delete card",
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
            title: "Delete IndexCard?",
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
              // session.deleteCard(index),
              widget.notifyParent(widget.index),
              Navigator.pop(context)
            },
            child: const Text("delete card"),
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
            child: const Text("keep card"),
          ),
        ),
      ],
    );
  }
}
