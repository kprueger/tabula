import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  static const Text appTitle = Text(
    "Tabula",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
  );

  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: appTitle,
      /*actions: <Widget>[
        //_buildGeElevatedBtn(),
        Row(
          children: <Widget>[
            Transform.rotate(
                angle: -0.698132, // radiant is 40 degrees
                child: IconButton(
                    iconSize: 50.0,
                    tooltip: "Earned GEMS to use for help",
                    onPressed: () {},
                    icon: const Icon(Icons.diamond))),
            const Text(
              "99",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
          ],
        ),
        IconButton(
            iconSize: 40.0,
            tooltip: "User Stats",
            onPressed: () {},
            icon: const Icon(Icons.account_circle_rounded))
      ],*/
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildGemBtn() {
    return FloatingActionButton.extended(
      tooltip: "Earned GEMS to use for help",
      label: const Text(
        "99",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
      ),
      backgroundColor: Colors.deepPurple,
      icon: Transform.rotate(
        angle: -0.698132, // radiant is 40 degrees
        child: IconButton(
            iconSize: 50.0, onPressed: () {}, icon: const Icon(Icons.diamond)),
      ),
      onPressed: () {},
    );
  }

  Widget _buildCustomGemBtn() {
    return Material(
      color: Colors.deepPurple,
      child: InkWell(
        borderRadius: BorderRadius.circular(5.0),
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.rotate(
                angle: -0.698132, // radiant is 40 degrees
                child: const Icon(Icons.diamond, size: 50.0)),
            const Text(
              "99",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  } // SEE: https://www.flutterbeads.com/button-with-icon-and-text-flutter/

  Widget _buildGeElevatedBtn() {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)))),
      icon: Transform.rotate(
          angle: -0.698132, // radiant is 40 degrees
          child: const Icon(Icons.diamond, size: 50.0)),
      label: const Text(
        "99",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
      ),
    );
  }

  // flutter outsource appbar:
  // https://stackoverflow.com/questions/53411890/how-can-i-have-my-appbar-in-a-separate-file-in-flutter-while-still-having-the-wi
}
