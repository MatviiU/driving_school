class UserModel{
  int? idUser;
  String? email;
  String? password;
  int? rememberMe;

  UserModel({
    this.idUser,
    this.email,
    this.password,
    this.rememberMe,
  });

  static String? loggedEmail;

  factory UserModel.fromMap(Map<String, dynamic> userJson) =>
      UserModel(
        idUser: userJson['IDUser'],
        email: userJson['Email'],
        password: userJson['Password'],
        rememberMe: userJson['RememberMe'],
      );

  Map<String, dynamic> toMap() => {
    'IDUser': idUser,
    'Email': email,
    'Password': password,
    'RememberMe': rememberMe,
  };
}