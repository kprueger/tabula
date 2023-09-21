import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tabula/models/collection/card_info.dart';

import 'package:tabula/models/collection/collection.dart';
import 'package:tabula/models/collection/index_card.dart';
import 'package:tabula/models/network/env.dart';
import 'package:tabula/models/user/user.dart';
import 'package:tabula/models/user/user_states.dart';
import 'package:tabula/pages/collection_screen.dart';
import 'package:tabula/pages/play_screen.dart';

const collectionBoxName = "collectionBox";

const userBoxName = "userBox";

void main() async {
  // Initializes the package with the API key
  OpenAI.apiKey = Env.apiKey;
  // Init Hive DB path
  await Hive.initFlutter();

  // Register the Classes for the Collection to Hive
  Hive.registerAdapter(CollectionAdapter());
  Hive.registerAdapter(IndexCardAdapter());
  Hive.registerAdapter(CardInfoAdapter());

  // Register the User Class to Hive
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserStatesAdapter());

  // Setup the Collection DB
  await Hive.openBox<Collection>(collectionBoxName);

  // Setup the User DB
  await Hive.openBox<User>(userBoxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabula',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: CollectionScreen(),
    );
  }
  // AppBar eventuell hier hin auslagern:
  // https://stackoverflow.com/questions/53411890/how-can-i-have-my-appbar-in-a-separate-file-in-flutter-while-still-having-the-wi
}
