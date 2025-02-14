import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key, required this.textWidget, required this.isColorBlack});

  final Text textWidget;
  final bool isColorBlack;

  @override
  Widget build(BuildContext context) {
    return isColorBlack!
        ? DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Vollkorn',
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            child: textWidget,
          )
        : DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Vollkorn',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            child: textWidget,
          );
  }
}
