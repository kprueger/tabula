import 'package:flutter/material.dart';

import 'package:tabula/models/session/create_session.dart';
import 'package:tabula/pages/create/create_collection_screen.dart';
import 'package:tabula/widgets/app_bar_widget.dart';
import 'package:tabula/widgets/collection_list_tile.dart';
import 'package:tabula/widgets/nav_bar_widget.dart';

class CollectionScreen extends StatefulWidget {
  CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late CreateSession session;
  late List<dynamic> collectionNames;

  @override
  void initState() {
    session = CreateSession();
    collectionNames = session.getCollectionNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: collectionNames.isEmpty
          ? _buildPlaceholder(context)
          : _buildCollectionsList(),
      bottomNavigationBar: const NavBarWidget(),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
        child: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateCollectionScreen()),
                  (r) {
                return false;
              });
            },
            child: Image.asset(
              "assets/resources/tabula_landing_page_placeholder.png",
              fit: BoxFit.fill,
            )));
  }

  Widget _buildCollectionsList() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        dynamic tempCollectionName = collectionNames[index];
        return CollectionListTile(
            name: tempCollectionName, notifyParent: refresh);
      },
      itemCount: collectionNames.length,
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  void refresh(delcollectionName) {
    print("CALLED refresh()");
    setState(() {
      session.deleteCollection(delcollectionName);
      collectionNames = session.getCollectionNames();
    });
  }
}
