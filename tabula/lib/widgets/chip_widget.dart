import 'package:flutter/material.dart';

class ChipWidget extends StatefulWidget {
  const ChipWidget(
      {super.key,
      required this.label,
      required this.color,
      required this.notifyParent});
  final String label;
  final Color color;
  final Function notifyParent;

  @override
  State<StatefulWidget> createState() => _ChipWidgetState();
}

class _ChipWidgetState extends State<ChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.all(2.0),
      label: Text(
        widget.label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: widget.color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(8.0),
      onDeleted: () {
        widget.notifyParent(widget.label);
      },
      deleteIconColor: Colors.white,
    );
  }
}
