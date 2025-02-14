import 'package:flutter/cupertino.dart';

class FormKeys{
  static GlobalKey<FormState>? loginViewKey;
  static GlobalKey<FormState>? createUserViewKey;
  static GlobalKey<FormState>? forgotPassword;

  static void resetKeys(){
    loginViewKey = GlobalKey<FormState>(debugLabel: "loginViewKey");
    createUserViewKey = GlobalKey<FormState>(debugLabel: "createUserViewKey");
    forgotPassword = GlobalKey<FormState>(debugLabel: "forgotPasswordViewKey");
  }
}