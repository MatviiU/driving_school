class ThemeModel{
  int? idTheme;
  String? themeName;
  int? countNotRightAnswers;

  ThemeModel({
    this.idTheme,
    this.themeName,
    this.countNotRightAnswers,
  });

  factory ThemeModel.fromMap(Map<String, dynamic> themeJson) =>
      ThemeModel(
        idTheme: themeJson['IDTheme'],
        themeName: themeJson['ThemeName'],
        countNotRightAnswers: themeJson['CountNotRightAnswers'],
      );

  Map<String, dynamic> toMap() => {
    'IDTheme': idTheme,
    'ThemeName': themeName,
    'CountNotRightAnswers': countNotRightAnswers,
  };
}