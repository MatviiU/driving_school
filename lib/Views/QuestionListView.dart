import 'package:carousel_slider/carousel_slider.dart';
import 'package:driving_school/Widgets/AnswersView.dart';
import 'package:driving_school/Widgets/AppBarWidget.dart';
import 'package:driving_school/Widgets/ArrowBack.dart';
import 'package:driving_school/Widgets/LoadingWidget.dart';
import 'package:driving_school/Widgets/TextWidget.dart';
import 'package:driving_school/sqlite_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class QuestionListView extends StatefulWidget {
  final int idTheme;
  final int countNotRightAnswers;

  QuestionListView({super.key, required this.idTheme, required this.countNotRightAnswers});

  @override
  State<QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  final controller = CarouselSliderController();
  bool isVisibleLeft = false;
  bool isVisibleRight = true;
  int index = 0;
  int questionCount = 0;
  int currentQuestion = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarLeading: const ArrowBackIcon(routeName: 'MainView'),
        appBarTitle: const Text("Тести"),
        appBarAction: [
          Padding(
            padding: const EdgeInsets.only(right: 50,),
            child: FutureBuilder(
              future: GetQuestionsCount(widget.idTheme),
              builder:(context, snapshot) {
                return TextWidget(
                  textWidget: Text(
                    "$currentQuestion/${snapshot.data}",
                  ),
                  isColorBlack: false,
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF112D55),
        child: FutureBuilder(
          future:
              sqlite_database.sqliteDB.SelectQuestionByIdTheme(widget.idTheme),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              final questions = snapshot.data!;
              //GetQuestionsCount(widget.idTheme);
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CarouselSlider.builder(
                      carouselController: controller,
                      itemCount: questionCount,
                      options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.8 - 35,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return ListView(
                          children: [
                            TextWidget(
                              textWidget: Text(
                                "${questions[index].question}",
                                textAlign: TextAlign.center,
                              ),
                              isColorBlack: false,
                            ),
                            questions[index].image != null
                                ? Image.memory(questions[index].image!)
                                : SizedBox(),
                            AnswerView(
                              idQuestion: questions[index].idQuestion!,
                              idTheme: widget.idTheme,
                              countNotRightAnswers: widget.countNotRightAnswers,
                            ),
                          ],
                        );
                      }),
                  const Spacer(),
                  questionCount > 1 ?
                  CreateBottomArrows(isVisibleLeft, isVisibleRight) : SizedBox(),
                ],
              );
            } else {
              return
                const LoadingWidget();
            }
          },
        ),
      ),
    );
  }

  Widget CreateBottomArrows(bool isVisibleLeft, bool isVisibleRight) {
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: isVisibleLeft,
            child: IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.arrow_back,
                size: 32,
              ),
              onPressed: PreviousPage,
            ),
          ),
          Visibility(
            visible: isVisibleRight,
            child: IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.arrow_forward,
                size: 32,
              ),
              onPressed: NextPage,
            ),
          ),
        ],
      ),
    );
  }

  void NextPage() {
    setState(() {
      index++;
      currentQuestion++;
      isVisibleRight = index != questionCount - 1;
      isVisibleLeft = index != 0;
    });
    controller.nextPage(
      duration: Duration(milliseconds: 200),
    );
  }

  void PreviousPage() {
    setState(() {
      index--;
      currentQuestion--;
      isVisibleLeft = index != 0;
      isVisibleRight = index != questionCount - 1;
    });
    controller.previousPage(
      duration: Duration(milliseconds: 200),
    );
  }

  Future<int> GetQuestionsCount(int idTheme) async{
    return questionCount = (await sqlite_database.sqliteDB.SelectQuestionsCount(idTheme))!;
  }
}
