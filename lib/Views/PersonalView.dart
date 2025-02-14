import 'package:driving_school/Models/ThemeModel.dart';
import 'package:driving_school/Views/MainView.dart';
import 'package:driving_school/Widgets/AppBarWidget.dart';
import 'package:driving_school/Widgets/ArrowBack.dart';
import 'package:driving_school/Widgets/TextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../sqlite_database.dart';

class PersonalView extends StatefulWidget {
  const PersonalView({super.key});

  @override
  State<PersonalView> createState() => _PersonalViewState();
}

class _PersonalViewState extends State<PersonalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112D55),
      appBar: AppBarWidget(
        appBarLeading: ArrowBackIcon(
          routeName: 'MainView',
        ),
        appBarTitle: Column(
          children: [
            Text(
              "Персональний",
            ),
            Text(
              "Кабінет",
            ),
          ],
        ),
        appBarAction: null,
      ),
      body: FutureBuilder<List<ThemeModel>>(
        future: sqlite_database.sqliteDB.SelectThemes(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.only(
                    bottom: 20,
                  ),
                  leading: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextWidget(
                      isColorBlack: false,
                      textWidget: Text(
                        "${snapshot.data![index].themeName}",
                      ),
                    ),
                  ),
                  trailing: Image.asset(
                    snapshot.data![index].countNotRightAnswers == 0
                        ? 'assets/greenCar.png'
                        : 'assets/transparentCar.png',
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
