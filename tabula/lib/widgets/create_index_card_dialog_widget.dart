import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateIndexCardDialogWidget {
  BuildContext context;
  final Function(String) notifyParent;
  final TextEditingController indexCardInput = TextEditingController();

  CreateIndexCardDialogWidget({required this.context, required this.notifyParent});

  Future<void> buildDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),

          content: Container(
            width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "CREATE\nVOCABULARY",
                style: textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: indexCardInput,
                textAlign: TextAlign.center,
                cursorColor: Colors.deepPurple,
                style: textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16.0),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-ZäöüßÄÖÜ ]')),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (indexCardInput.text.isNotEmpty) {
                    notifyParent(indexCardInput.text);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "ADD CARD",
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "CANCEL",
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
          ),
        );
      },
    );
  }
}
