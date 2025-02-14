import 'package:driving_school/Widgets/TextWidget.dart';
import 'package:driving_school/sqlite_database.dart';
import 'package:flutter/material.dart';

import '../Models/AnswerModel.dart';

class AnswerView extends StatefulWidget {
  final int idQuestion;
  final int idTheme;
  final int countNotRightAnswers;


  const AnswerView(
      {super.key, required this.idQuestion, required this.idTheme, required this.countNotRightAnswers});

  @override
  State<AnswerView> createState() => _AnswerViewState();
}

class _AnswerViewState extends State<AnswerView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          sqlite_database.sqliteDB.SelectAnswersByIdQuestion(widget.idQuestion),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final answers = snapshot.data!;
          return Column(
            children: answers.map((e) => WidgetButton(e, answers)).toList(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget WidgetButton(AnswerModel answer, List<AnswerModel> answers) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ControlButtonColor(
              answer.idQuestion!, answer.idAnswer!, answer.answerType!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.black,
        ),
        onPressed: () {
          setState(() {
            if (AnswerModel.selectedAnswers[answer.idQuestion] == null) {
              AnswerModel.selectedAnswers[answer.idQuestion!] =
                  answer.idAnswer!;

              if (answer.answerType == 0) {
                final correctAnswer = answers.firstWhere((e) => e.answerType == 1);
                AnswerModel.selectedAnswers[correctAnswer.idQuestion!] = correctAnswer.idAnswer!;
                AnswerModel.selectedAnswers[answer.idQuestion!] = answer.idAnswer!;
              }

              if (answer.answerType == 1) {
                if(widget.countNotRightAnswers != 0) {
                  sqlite_database.sqliteDB.UpdateIsThemeComplete(
                      widget.idTheme);
                }
              }
            }
          });
        },
        child: TextWidget(
          textWidget: Text(
            "${answer.answer}",
            textAlign: TextAlign.center,
          ),
          isColorBlack: true,
        ),
      ),
    );
  }

  Color ControlButtonColor(int idQuestion, int idAnswer, int answerType) {
    if(AnswerModel.selectedAnswers[idQuestion] == null){
      return Colors.white;
    }

    if(AnswerModel.selectedAnswers[idQuestion] == idAnswer){
      return answerType == 1 ? Colors.green : Colors.red;
    }

    if (answerType == 1) {
      return Colors.green;
    }

    return Colors.white;
  }

}
