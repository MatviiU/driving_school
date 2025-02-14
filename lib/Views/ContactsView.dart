import 'package:driving_school/Widgets/TextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFF2B5882),
        child: Column(
          children: [
            Image.asset("assets/logoDrivingSchool.png"),
            SizedBox(
              height: 70,
            ),
            TextWidget(
              textWidget: Text(
                "Контакти автошколи",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 35,
                ),
              ),
              isColorBlack: true,
            ),
            SizedBox(
              height: 30,
            ),
            TextWidget(
              textWidget: Text("+380 981 344 305 Ігор"),
              isColorBlack: true,
            ),
            TextWidget(
              textWidget: Text("+380 976 656 855 Микола"),
              isColorBlack: true,
            ),
            TextWidget(
              textWidget: Text("+380 974 046 234 Уляна"),
              isColorBlack: true,
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                TextWidget(
                  textWidget: Text("Пропонуємо підготовку водіїв"),
                  isColorBlack: true,
                ),
                TextWidget(
                  textWidget:
                      Text("Категорії: \"А\", \"В\", \"С1\", \"С\", \"Д1\","),
                  isColorBlack: true,
                ),
                TextWidget(
                  textWidget: Text("\"Д\", \"С1Е\", \"СЕ\""),
                  isColorBlack: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
