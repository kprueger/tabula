import 'package:flutter/material.dart';

class DialogWidget {
  String title;
  Icon icon;
  Widget content;
  BuildContext context;
  double fontSizeTitle;

  DialogWidget(
      {required this.title,
      required this.icon,
      required this.content,
      required this.context,
      required this.fontSizeTitle});

  Future<void> buildDialog() {
    return showDialog(
        context: context,
        builder: (context) {
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
                      icon,
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ))),
                          onPressed: () => {Navigator.pop(context)},
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
                  content,
                  const SizedBox(
                    height: 25.0,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
