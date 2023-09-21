import 'package:flutter/material.dart';
import 'package:tabula/widgets/chip_widget.dart';

class ChipsBuilderWidget extends StatefulWidget {
  const ChipsBuilderWidget(
      {super.key, required this.collectionTopics, required this.notifyParent});
  final List<String> collectionTopics;
  final Function notifyParent;

  @override
  State<StatefulWidget> createState() => _ChipsBuilderWidgetState();
}

class _ChipsBuilderWidgetState extends State<ChipsBuilderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 5.0,
          children: List<Widget>.generate(
            widget.collectionTopics.length,
            (int index) {
              return ChipWidget(
                  label: widget.collectionTopics.elementAt(index),
                  color: Colors.purple,
                  notifyParent: widget.notifyParent);
            },
          ).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
