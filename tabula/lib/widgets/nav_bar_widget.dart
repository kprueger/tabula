import 'package:flutter/material.dart';
import 'package:tabula/pages/create/create_collection_screen.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60.0,
      color: Colors.purple,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _buildCustomBtn(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBtn(BuildContext context) {
    return Center(
        child: IconButton(
      padding: EdgeInsets.zero,
      icon: Image.asset(
        "assets/resources/tabula_logo_btn.png",
        fit: BoxFit.fill,
      ),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateCollectionScreen()), (r) {
          return false;
        });
      },
    ));
  }
}
