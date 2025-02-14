import 'dart:collection';

class AnswerModel{
  int? idAnswer;
  String? answer;
  int? answerType;
  int? idQuestion;

  AnswerModel({
    this.idAnswer,
    this.answer,
    this.answerType,
    this.idQuestion,
  });

  static HashMap<int, int> selectedAnswers = HashMap();

  factory AnswerModel.fromMap(Map<String, dynamic> answerJson) =>
      AnswerModel(
        idAnswer: answerJson['IDAnswer'],
        answer: answerJson['Answer'],
        answerType: answerJson['AnswerType'],
        idQuestion: answerJson['IDQuestion'],
      );

  Map<String, dynamic> toMap() => {
    'IDAnswer': idAnswer,
    'Answer': answer,
    'AnswerType': answerType,
    'IDQuestion': idQuestion,
  };
}