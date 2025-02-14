import 'dart:typed_data';

class QuestionModel{
  int? idQuestion;
  String? question;
  Uint8List? image;
  int? idTheme;

  QuestionModel({
    this.idQuestion,
    this.question,
    this.image,
    this.idTheme,
  });

  static int? firstQuestion;

  factory QuestionModel.fromMap(Map<String, dynamic> questionJson) =>
      QuestionModel(
        idQuestion: questionJson['IDQuestion'],
        question: questionJson['Question'],
        image: questionJson['Image'],
        idTheme: questionJson['IDTheme'],
      );

  Map<String, dynamic> toMap() => {
    'IDQuestion': idQuestion,
    'Question': question,
    'Image': image,
    'IDTheme': idTheme,
  };
}