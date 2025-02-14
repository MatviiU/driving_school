import 'dart:collection';

import 'package:driving_school/Models/AnswerModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArrowBackIcon extends StatelessWidget {
  const ArrowBackIcon({
    super.key,
    this.icon,
    required this.routeName,
  });

  final String? routeName;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        size: 40,
        color: Colors.white,
      ),
      onPressed: () {
        AnswerModel.selectedAnswers.clear();
        Navigator.of(context).pushNamedAndRemoveUntil(
            routeName!, (Route<dynamic> route) => false);
      },
    );
  }
}
