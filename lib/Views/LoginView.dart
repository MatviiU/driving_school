import 'package:driving_school/Views/ContactsView.dart';
import 'package:driving_school/Views/CreateUserView.dart';
import 'package:driving_school/Views/ForgotPasswordView.dart';
import 'package:driving_school/Views/MainView.dart';
import 'package:driving_school/Widgets/AppBarWidget.dart';
import 'package:driving_school/Widgets/TextWidget.dart';
import 'package:driving_school/form_keys.dart';
import 'package:driving_school/sqlite_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:driving_school/Models/UserModel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  List<UserModel> userList = [];
  bool isObscureText = true;
  bool isCorrectPassword = true;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    FormKeys.resetKeys();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112D55),
      appBar: AppBarWidget(
        appBarTitle: Column(
          children: [
            Text("ТЕСТИ"),
            Text("ПДР України"),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
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
              key: FormKeys.loginViewKey,
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
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: isObscureText,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        hintText: "Пароль",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                isObscureText = !isObscureText;
                              },
                            );
                          },
                          icon: Icon(
                            isObscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (password) {
                        if (password!.isEmpty) {
                          return "Введіть пароль";
                        } else {
                          for (int i = 0; i < userList.length; i++) {
                            if (userList[i].password !=
                                passwordController.text) {
                              isCorrectPassword = false;
                            } else {
                              isCorrectPassword = true;
                              break;
                            }
                          }
                        }
                        return isCorrectPassword ? null : "Неправильний пароль";
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPasswordView()));
                      },
                      child: TextWidget(
                        textWidget: Text("Забули пароль"),
                        isColorBlack: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        if (FormKeys.loginViewKey!.currentState!.validate()) {
                          FormKeys.loginViewKey!.currentState!.save();
                          UserModel.loggedEmail = emailController.text;
                            sqlite_database.sqliteDB.UpdateUsersRememberMe(UserModel.loggedEmail!, isChecked ? 1 : 0);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MainView()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF112D55),
                        fixedSize: Size(200, 60),
                      ),
                      child: TextWidget(
                        textWidget: Text("Вхід"),
                        isColorBlack: false,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF112D55),
                      fixedSize: Size(200, 60),
                    ),
                    child: TextWidget(
                      textWidget: Text("Контакти"),
                      isColorBlack: false,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContactsView()));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateUserView()));
                      },
                      child: TextWidget(
                        isColorBlack: false,
                        textWidget: Text(
                          "Реєстрація",
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF112D55),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                          textWidget: Text(
                            "Запам'ятай мене",
                            style: TextStyle(
                              fontSize: 23,
                              color: Color(0xFF112D55),
                            ),
                          ),
                          isColorBlack: true),
                      Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          activeColor: const Color(0xFF112D55),
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (newBool) {
                            setState(() {
                              isChecked = newBool!;
                            });
                          },
                        ),
                      ),
                    ],
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
