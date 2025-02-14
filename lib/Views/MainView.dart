import 'package:driving_school/Views/LoginView.dart';
import 'package:driving_school/Views/QuestionListView.dart';
import 'package:driving_school/Widgets/AppBarWidget.dart';
import 'package:driving_school/Widgets/TextWidget.dart';
import 'package:driving_school/sqlite_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:driving_school/Views/PersonalView.dart';
import 'package:driving_school/Models/ThemeModel.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainView();
}

class _MainView extends State<MainView> {
  List<ThemeModel> themeList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112D55),
      appBar: AppBarWidget(
        appBarLeading: IconButton(
          icon: const Icon(
            Icons.logout,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () async {
            int? rememberMeStatus =
                await sqlite_database.sqliteDB.SelectRememberMeStatus();
            rememberMeStatus = 0;
            String? email = await sqlite_database.sqliteDB.SelectEmailByRememberMe();
            if(email == null){
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
                    (Route<dynamic> route) => false,
              );
            } else{
              sqlite_database.sqliteDB.UpdateUsersRememberMe(
                  email, rememberMeStatus);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
                    (Route<dynamic> route) => false,
              );
            }
          },
        ),
        appBarTitle: const Text("Тести"),
        appBarAction: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PersonalView()));
            },
            icon: const Icon(
              Icons.person,
              size: 35,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ThemeModel>>(
        future: sqlite_database.sqliteDB.SelectThemes(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ThemeModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextWidget(
                        isColorBlack: true,
                        textWidget: Text(
                          "${snapshot.data![index].themeName}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QuestionListView(
                              idTheme: snapshot.data![index].idTheme!,
                              countNotRightAnswers:
                                  snapshot.data![index].countNotRightAnswers!,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
