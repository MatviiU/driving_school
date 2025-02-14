import 'package:driving_school/Models/UserModel.dart';
import 'package:driving_school/Views/LoginView.dart';
import 'package:driving_school/Widgets/AppBarWidget.dart';
import 'package:driving_school/Widgets/ArrowBack.dart';
import 'package:driving_school/Widgets/TextWidget.dart';
import 'package:driving_school/sqlite_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_keys.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUserView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  RegExp emailRegex = RegExp("^[a-zA-Z0-9._%+-]+@[a-zA-Z]+\.[a-zA-Z]{2,}");
  bool isObscureText = true;

  //RegExp passwordRegex = RegExp("^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!%&*\.])");
  List<UserModel> userList = [];

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
        appBarLeading: ArrowBackIcon(
          routeName: 'LoginView',
        ),
        appBarTitle: Text("Реєстрація"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 30, 8, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Form(
          key: FormKeys.createUserViewKey,
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  onFieldSubmitted: (text) {
                    isUserInSQLiteBD(text);
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Електронна пошта",
                  ),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Обов'язкове поле";
                    }
                    if (!emailRegex.hasMatch(email)) {
                      return "Неправильно написана електронна пошта";
                    }
                    if (userList.isNotEmpty) {
                      return "Вже існує акаунт з данною поштою";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
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
                        isObscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (password) {
                    if (password == null || password!.isEmpty) {
                      return "Обов'язкове поле";
                    }
                    if (password.length < 8) {
                      return "Пароль має складатися з 8 символів";
                    }
                    /*if (!passwordRegex.hasMatch(password)) {
                      return "Пароль не містить: Велику літеру, малу літеру, !,*,%,&";
                    }*/
                    else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (FormKeys.createUserViewKey!.currentState!.validate()) {
                      sqlite_database.sqliteDB.InsertIntoUsers(
                        UserModel(
                          email: emailController.text,
                          password: passwordController.text,
                        ),
                      );
                      /*Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginView()),
                      );*/
                      Navigator.of(context).pushNamedAndRemoveUntil('LoginView', (Route<dynamic> route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF112D55),
                    fixedSize: Size(250, 60),
                  ),
                  child: TextWidget(
                    textWidget: Text("Зареєструватися"),
                    isColorBlack: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void isUserInSQLiteBD(String text) async {
    userList =
        await sqlite_database.sqliteDB.SelectUserByEmail(emailController.text);
  }
}
