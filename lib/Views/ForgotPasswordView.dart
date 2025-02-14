import 'package:driving_school/Views/LoginView.dart';
import 'package:driving_school/Widgets/AppBarWidget.dart';
import 'package:driving_school/Widgets/ArrowBack.dart';
import 'package:driving_school/Widgets/TextWidget.dart';
import 'package:driving_school/form_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/UserModel.dart';
import '../sqlite_database.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordView> {
  late TextEditingController emailController;
  late TextEditingController newPasswordController;
  late TextEditingController repeatNewPasswordController;
  List<UserModel> userList = [];
  bool isPasswordExist = true;
  bool passwordsIsSimilar = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    newPasswordController = TextEditingController();
    repeatNewPasswordController = TextEditingController();
    FormKeys.resetKeys();
  }

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    repeatNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112D55),
      appBar: AppBarWidget(
        appBarLeading: ArrowBackIcon(
          routeName: 'LoginView',
        ),
        appBarTitle: Column(
          children: [
            Text("Зміна"),
            Text("Паролю"),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(8, 30, 8, 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.transparent,
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: ListView(
          children: [
            Form(
              key: FormKeys.forgotPassword,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Електронна пошта",
                    ),
                    onFieldSubmitted: (text) {
                      isUserInSQLiteBD(text);
                    },
                    validator: (email) {
                      if (email!.length < 1) {
                        return "Введіть електронну пошту";
                      } else {
                        if (userList.length == 0) {
                          return "Не існує акаунту з данною поштою";
                        }
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        hintText: "Новий пароль",
                      ),
                      validator: (newPassword) {
                        if (newPassword!.isEmpty) {
                          return "Введіть пароль";
                        } else {
                          for (int i = 0; i < userList.length; i++) {
                            if (userList[i].password !=
                                newPasswordController.text) {
                              isPasswordExist = true;
                            } else {
                              isPasswordExist = false;
                              break;
                            }
                          }
                        }
                        return isPasswordExist ? null : "Такий пароль існує";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: repeatNewPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        hintText: "Повторіть новий пароль",
                      ),
                      validator: (repeatNewPassword) {
                        if (repeatNewPassword!.isEmpty) {
                          return "Введіть пароль";
                        } else {
                          if (repeatNewPassword == newPasswordController.text) {
                            passwordsIsSimilar = true;
                          } else {
                            passwordsIsSimilar = false;
                          }
                        }
                        return passwordsIsSimilar
                            ? null
                            : "Напишіть однакові паролі";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        if (FormKeys.forgotPassword!.currentState!.validate()) {
                          sqlite_database.sqliteDB.UpdateOldPassword(
                              newPasswordController.text, emailController.text);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF112D55),
                        fixedSize: Size(200, 60),
                      ),
                      child: TextWidget(
                        textWidget: Text("Змінити пароль"),
                        isColorBlack: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void isUserInSQLiteBD(String text) async {
    userList =
        await sqlite_database.sqliteDB.SelectUserByEmail(emailController.text);
  }
}
