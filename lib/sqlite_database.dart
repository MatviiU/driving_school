import 'dart:io';

import 'package:driving_school/Models/AnswerModel.dart';
import 'package:driving_school/Models/QuestionModel.dart';
import 'package:driving_school/Models/ThemeModel.dart';
import 'package:driving_school/Models/UserModel.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class sqlite_database {
  var dbPath;

  sqlite_database._();

  static final sqlite_database sqliteDB = sqlite_database._();
  late Database _database;

  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    dbPath = join(directory.path, "DrivingSchoolDB.db");

    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load("assets/DrivingSchoolDB.db");
      WriteToFile(data, dbPath);
    }

    var departuresDatabase = await openDatabase(dbPath);
    return departuresDatabase;
  }

  void WriteToFile(ByteData data, String dbPath) {
    final buffer = data.buffer;
    return new File(dbPath).writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<List<UserModel>> SelectUserByEmail(String email) async {
    final db = await database;
    String sqlQuery =
        'SELECT * FROM Users '
          'WHERE Email = \'$email\'';
    var result = await db.rawQuery(sqlQuery);

    List<UserModel> userList = result.map((x) => UserModel.fromMap(x)).toList();
    return userList;
  }

  Future<List<ThemeModel>> SelectThemes() async{
    final db = await database;
    String sqlQuery =
        'SELECT * FROM Themes';
    var result = await db.rawQuery(sqlQuery);

    List<ThemeModel> themeList = result.map((x) => ThemeModel.fromMap(x)).toList();
    return themeList;
  }

  Future<List<QuestionModel>> SelectQuestionByIdTheme(int idTheme) async{
    final db = await database;
    String sqlQuery =
        'SELECT * '
          'FROM Questions '
              'WHERE IDTheme = \'$idTheme\'';
    var result = await db.rawQuery(sqlQuery);

    List<QuestionModel> questionList = result.map((x) => QuestionModel.fromMap(x)).toList();
    return questionList;
  }

  Future<List<AnswerModel>> SelectAnswersByIdQuestion(int idQuestion) async{
    final db = await database;
    String sqlQuery =
        'SELECT * '
          'FROM Answers '
            'WHERE IDQuestion = \'$idQuestion\'';
    var result = await db.rawQuery(sqlQuery);
    List<AnswerModel> answerList = result.map((x) => AnswerModel.fromMap(x)).toList();
    return answerList;
  }

  Future<Set<int>> SelectTypeOneAnswerIds() async {
    final db = await database;
    String sqlQuery =
        'SELECT IDAnswer '
          'FROM Answers '
            'WHERE AnswerType = 1';
    var result = await db.rawQuery(sqlQuery);
    return result.map((row) => row['IDAnswer'] as int).toSet();
  }

  Future<int?> SelectRememberMeStatus() async {
    final db = await database;
    String sqlQuery =
        'SELECT RememberMe '
          'FROM Users '
            'WHERE RememberMe = 1 LIMIT 1';
    var result = await db.rawQuery(sqlQuery);

    if (result.isNotEmpty) {
      return result.first['RememberMe'] as int;
    }
    return 0;
  }

  Future<String?> SelectEmailByRememberMe() async{
    final db = await database;
    String sqlQuery =
        'SELECT Email '
          'FROM Users '
            'WHERE RememberMe = 1  LIMIT 1';
    var result = await db.rawQuery(sqlQuery);
    if(result.isNotEmpty){
      return result.first['Email'] as String;
    }
    return null;
  }

  Future<int?> SelectQuestionsCount(int idTheme) async{
    final db = await database;
    String sqlQuery =
        'SELECT COUNT(*) as count '
          'FROM Questions '
            'WHERE IDTheme = \'$idTheme\'';

    var result = await db.rawQuery(sqlQuery);
    if(result.isNotEmpty){
      return result.first['count'] as int;
    }
    return null;
  }

  Future<bool> InsertIntoUsers(UserModel users) async {
    final db = await database;
    int result = 0;
    try {
      result = await db.rawInsert(
          'INSERT INTO Users(Email, Password) '
              'VALUES(\'${users.email}\', \'${users.password}\')');
    } catch (e) {
      print('InsertIntoUsers ${e.toString()}');
    }
    return result != 0;
  }

  Future<bool> InsertIntoUserTheme(int idUser) async{
    final db = await database;
    int result = 0;
    try {
      result = await db.rawInsert(
          'INSERT INTO UserTheme(IDUser, IDTheme) '
              'SELECT $idUser, IDTheme '
                'FROM Themes');
    } catch (e) {
      print('InsertIntoUserTheme ${e.toString()}');
    }
    return result != 0;
  }

  Future<int> UpdateIsThemeComplete(int selectedTheme) async{
    final db = await database;
    int result = 0;
    try{
      result = await db.rawUpdate(
          'UPDATE Themes '
              'SET CountNotRightAnswers = CountNotRightAnswers - 1 '
                'WHERE IDTheme = \'$selectedTheme\'');
    }
    catch(e){
      print('UpdateIsThemeComplete ${e.toString()}');
    }
    return result;
  }

  Future<int> UpdateOldPassword(String newPassword, String email) async{
    final db = await database;
    int result = 0;
    try{
      result = await db.rawUpdate(
          'UPDATE Users '
              'SET Password = \'$newPassword\' '
                'WHERE Email = \'$email\'');
    }
    catch(e){
      print('UpdateIsThemeComplete ${e.toString()}');
    }
    return result;
  }

  Future<int> UpdateUsersRememberMe(String email, int rememberMe) async{
    final db = await database;
    int result = 0;
    try{
      result = await db.rawUpdate(
          'UPDATE  Users '
            'SET RememberMe = $rememberMe '
              'WHERE Email = \'$email\'');
    }
    catch(e){
      print('UpdateUsersRememberMe ${e.toString()}');
    }
    return result;
  }
}
