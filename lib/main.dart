import 'package:driving_school/Views/LoginView.dart';
import 'package:driving_school/Views/MainView.dart';
import 'package:driving_school/sqlite_database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sqlite_database.sqliteDB;
  int? rememberMeStatus = await sqlite_database.sqliteDB.SelectRememberMeStatus();
  String initialScreen = (rememberMeStatus == 1) ? 'MainView' : 'LoginView';

  runApp(MyApp(initialRoute: initialScreen));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp
      (
      initialRoute: initialRoute,
      routes: {
        'LoginView': (context) => LoginView(),
        'MainView': (context) => MainView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
