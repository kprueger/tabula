import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAIIndexCardDialogWidget {
  BuildContext context;
  final Function(String) notifyParent;
  final TextEditingController amountController = TextEditingController();

  CreateAIIndexCardDialogWidget({required this.context, required this.notifyParent});

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
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "AI GENERATED\nCARDS",
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Column(
                    children: [
                      Text(
                        "How many new cards should be added to the collection?",
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        textAlign: TextAlign.center,
                        validator: numValidator,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 50.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (amountController.text.isNotEmpty) {
                        notifyParent(amountController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "GENERATE CARDS",
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 17.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 50.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
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
                ),
                SizedBox(height: 20.0),
              ],
            ),
            ),
          );
        });
  }

  String? numValidator(value) {
    if (value.isEmpty) {
      return "Can't be empty. How many index cards do you want?";
    }
    num number = int.tryParse(value.toString()) ?? -1;
    if (number <= 0) {
      return "Number has to be greater than 0";
    }
    return null;
  }
}
