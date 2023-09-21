import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabula/models/session/create_session.dart';

import 'package:tabula/pages/collection_screen.dart';
import 'package:tabula/pages/create/create_collection_list_view_screen.dart';
import 'package:tabula/widgets/app_bar_widget.dart';
import 'package:tabula/widgets/chips_builder_widget.dart';
import 'package:tabula/widgets/dialog_widget.dart';

class CreateCollectionScreen extends StatefulWidget {
  const CreateCollectionScreen({super.key});

  @override
  State<CreateCollectionScreen> createState() => _CreateCollectionScreenState();
}

class _CreateCollectionScreenState extends State<CreateCollectionScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final List<String> _collectionTopics = [];

  bool isFormValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildHead(),
              _buildCreateCollectionForm(),
              isFormValidate ? _buildCustomErrorMsg() : const Text(""),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionBtns(),
    );
  }

  Widget _buildHead() {
    return Row(
      children: [
        IconButton(
          iconSize: 50.0,
          padding: EdgeInsets.zero,
          onPressed: () {
            _buildExitDialog();
          },
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.grey,
          ),
        ),
        const Expanded(
          child: Text(
            "Create\nCollection",
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

  Widget _buildCreateCollectionForm() {
    return Expanded(
        child: Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 10.0,
            ),
            const Text(
              "name",
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "collection name"),
                controller: nameController,
              ),
            ),
            const SizedBox(
              width: 150.0,
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 10.0,
            ),
            const Text(
              "amount",
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
                child: TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'num',
              ),
              validator: numValidator,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            )),
            const SizedBox(
              width: 150.0,
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 10.0,
            ),
            const Text(
              "category",
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
                child: TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'category name',
              ),
            )),
            const SizedBox(
              width: 25.0,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  padding: const MaterialStatePropertyAll(EdgeInsets.all(10.0)),
                  backgroundColor:
                      const MaterialStatePropertyAll(Colors.purple),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ))),
              onPressed: () {
                setState(() {
                  if (categoryController.text.isNotEmpty) {
                    _collectionTopics.add(categoryController.text);
                    categoryController.clear();
                  }
                });
              },
              child: Row(
                children: const [
                  Icon(Icons.add),
                  Text(
                    "ADD",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        ChipsBuilderWidget(
            collectionTopics: _collectionTopics, notifyParent: deleteChip),
        const SizedBox(
          height: 18.0,
        ),
      ],
    ));
  }

  Widget _buildCustomErrorMsg() {
    return Expanded(
        child: Column(
      children: const [
        Text(
          textAlign: TextAlign.center,
          "Please add at least one category\nand an amount of cards",
          style: TextStyle(fontSize: 22.0, color: Colors.red),
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    ));
  }

  String? numValidator(value) {
    if (value.isEmpty) {
      return "Can't be empty. How many index cards you want?";
    }
    num number = int.tryParse(value.toString()) ?? -1;
    if (number <= 0) {
      return "Number has to be greater 0";
    }
    return null;
  }

  deleteChip(String label) {
    setState(() {
      _collectionTopics.removeWhere((element) {
        return element == label;
      });
    });
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
            if (_collectionTopics.isNotEmpty &&
                amountController.text.isNotEmpty) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateCollectionListViewScreen(
                            amount: amountController.text,
                            categories: _collectionTopics,
                            collectionName: nameController.text,
                            collectionImageURL: "",
                            createCollection: true,
                            session: CreateSession(),
                          )), (r) {
                return false;
              });
            } else {
              setState(() {
                isFormValidate = true;
              });
            }
          },
          child: const Text(
            'CREATE COLLECTION',
            style: TextStyle(fontSize: 30.0),
          ),
        ),
        const SizedBox(
          height: 85.0,
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
          height: 18.0,
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
}
