// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tranquil_app/app/models/models.export.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';

import '../../../main.dart';

class HealthReportScreen extends StatefulWidget {
  const HealthReportScreen({Key? key, required this.clientID}) : super(key: key);
  final String clientID;
  @override
  _HealthReportScreenState createState() => _HealthReportScreenState();
}

class _HealthReportScreenState extends State<HealthReportScreen>
    with SingleTickerProviderStateMixin {
  bool dataLoaded = false;
  ValueNotifier<int> numberOfQuestionsAnswered = ValueNotifier(0);
  late AnimationController _animationController;

  late Animation<double> _questionAnimation;
  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 500),
    );
    //tween for opacity of question initialization
    _questionAnimation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController);
  }

  List<Question> questionsFromDatabase = [];
  List<QuestionInHealthSection> displayingQuestions = [];

  Future getDataFromFirebase() async {
    var questionDocs = await questionsRef!.get();
    for (var questionElement in questionDocs.docs) {
      var map = questionElement.data() as Map<String, dynamic>;
      print(map);
      //temporary list for adding options as QuestionaireOption Model into it from database
      List<QuestionaireOption> tempOptions = [];

      //temporary list for adding options from database as Strings
      List<dynamic> optionsFromDatabase = map['options'];
      //temporary list for holding list of activating options
      List<dynamic> tempActivatingOptions = map['activationStr'];

      //temporary list for adding extra Question options as QuestionaireOption Model into it from database
      List<QuestionaireOption> extraQuestionOptions = [];

      //bool for if there is an extra question or not
      bool expandable = map['newSet'];

      //if there is an extra question fetch all the extra options into the temporary list
      if (expandable) {
        List<dynamic> newOptions = map['newOptions'];
        for (var i = 0; i < newOptions.length; i++) {
          extraQuestionOptions.add(
            QuestionaireOption(
              option: newOptions[i].toString(),
            ),
          );
        }
      }

      //extract all the options of the question and add them individually into optionsList
      for (var i = 0; i < optionsFromDatabase.length; i++) {
        tempOptions.add(
          QuestionaireOption(
            expandable: tempActivatingOptions.contains(
              optionsFromDatabase[i].toString(),
            ),
            question: expandable
                ? Question(
                    question: map['newQuestion'],
                    options: extraQuestionOptions,
                  )
                : null,
            option: optionsFromDatabase[i].toString(),
          ),
        );
      }

      //extract questions from database
      questionsFromDatabase.add(
        Question(
          question: map['question'],
          options: tempOptions,
        ),
      );
    }
    //printing all the questionss
    // for (var i = 0; i < questionsFromDatabase.length; i++) {
    //   print('quetion ${i + 1}: ' + questionsFromDatabase[i].question);
    //   for (var j = 0; j < questionsFromDatabase[i].options.length; j++) {
    //     print('option ${j + 1}: ' + questionsFromDatabase[i].options[j].option);
    //     print('option ${j + 1} is it expandable: ' +
    //         questionsFromDatabase[i].options[j].expandable.toString());
    //     if (questionsFromDatabase[i].options[j].expandable) {
    //       print('option ${j + 1} expanded question: ' +
    //           questionsFromDatabase[i].options[j].question.question);
    //       print('option ${j + 1} expanded options: ' +
    //           questionsFromDatabase[i].options[j].question.options[0].option +
    //           ' ' +
    //           questionsFromDatabase[i]
    //               .options[j]
    //               .question
    //               .options[0]
    //               .expandable
    //               .toString());
    //     }
    //   }
    // }
    var answeredQuestionDocs =
        await healthQuestionnaireRef!.doc(widget.clientID).get();
    List<dynamic> _listOfAnsweredQuestionsFromDatabase = [];
    if (answeredQuestionDocs.exists) {
      var _map = answeredQuestionDocs.data() as Map<String, dynamic>;
      print(_map);
      _listOfAnsweredQuestionsFromDatabase =
          (_map['questionnaire'] as List).cast();
      print(_listOfAnsweredQuestionsFromDatabase);
      if (_listOfAnsweredQuestionsFromDatabase.isNotEmpty) {
        int i = 0;
        for (Question _question in questionsFromDatabase) {
          List<String> _options =
              _question.options.map((e) => e.option).toList();
          String _answer =
              _listOfAnsweredQuestionsFromDatabase[i]['answer${i + 1}'];
          int _indexOfSelectedAnswer = _question.options
              .indexWhere((element) => element.option == _answer);
          QuestionInHealthSection _temp = QuestionInHealthSection(
            _question.question,
            _options,
            _answer,
            _indexOfSelectedAnswer,
          );
          displayingQuestions.add(_temp);
          i++;
          if (_question.options[_indexOfSelectedAnswer].expandable) {
            Question _expandedQuestion =
                _question.options[_indexOfSelectedAnswer].question!;
            List<String> _expandedOptions =
                _expandedQuestion.options.map((e) => e.option).toList();
            String _expandedAnswer =
                _listOfAnsweredQuestionsFromDatabase[i]['answer${i + 1}'];
            int _expandedIndexOfSelectedAnswer = _question.options
                .indexWhere((element) => element.option == _answer);
            QuestionInHealthSection _expandedTemp = QuestionInHealthSection(
              _expandedQuestion.question,
              _expandedOptions,
              _expandedAnswer,
              _expandedIndexOfSelectedAnswer,
            );
            displayingQuestions.add(_expandedTemp);
            i++;
          }
        }
      }
    }
    print(displayingQuestions[0].question);
    setState(() {
      dataLoaded = true;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //------------------------
      // background image container container
      //------------------------
      body: WillPopScope(
        onWillPop: () async {
          goBack();
          return false;
        },
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_img1.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                //------------------------
                // Back Button
                //------------------------
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  width: displayWidth(context),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: goBack,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: numberOfQuestionsAnswered,
                        child: InkWell(
                          onTap: goAhead,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const RotatedBox(
                              child:
                                  Icon(Icons.arrow_back, color: Colors.white),
                              quarterTurns: 2,
                            ),
                          ),
                        ),
                        builder: (context, int value, child) =>
                            value < displayingQuestions.length - 1
                                ? child ?? Container()
                                : Container(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                //------------------------
                // container that contains the filling container
                //------------------------
                SizedBox(
                  height: 30,
                  child: Center(
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      width: displayWidth(context) * 0.8,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[600]!,
                        ),
                      ),
                      //------------------------
                      // container that keeps filling according to the questions answered with green color
                      //------------------------
                      child: ValueListenableBuilder(
                        valueListenable: numberOfQuestionsAnswered,
                        builder: (context, int value, child) => Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            width: ((displayWidth(context) * 0.8) /
                                        (displayingQuestions.isEmpty
                                            ? 1.0
                                            : displayingQuestions.length))
                                    .toDouble() *
                                (displayingQuestions.isEmpty ? 0 : value + 1),
                            height: 30,
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                //------------------------
                // Question Number HEADING
                //------------------------
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(16),
                  child: ValueListenableBuilder(
                    valueListenable: numberOfQuestionsAnswered,
                    builder: (context, int value, child) => RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(children: [
                        const TextSpan(
                          text: 'Question ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 26,
                          ),
                        ),
                        TextSpan(
                          text: displayingQuestions.isEmpty
                              ? '0'
                              : '${value + 1}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 26,
                          ),
                        ),
                        TextSpan(
                          text: '/${displayingQuestions.length}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.01,
                ),
                //------------------------
                // QUESTION CONTAINING CONTAINER
                //------------------------
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(18),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    //if questionLoadedFromDatabase variable is true, questions are shown
                    child: dataLoaded
                        ? displayingQuestions.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Questions Answered',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: true,
                                ),
                              )
                            : ValueListenableBuilder(
                                valueListenable: numberOfQuestionsAnswered,
                                builder: (context, int value, child) => Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //------------------------
                                    // QUESTION
                                    //------------------------
                                    //using animation builder for opacity
                                    AnimatedBuilder(
                                      animation: _questionAnimation,
                                      builder: (context, child) => Opacity(
                                        opacity: _questionAnimation.value,
                                        child: Text(
                                          displayingQuestions[value].question,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: displayHeight(context) * 0.04,
                                    ),
                                    //------------------------
                                    // OPTIONS
                                    //------------------------
                                    Expanded(
                                      child: AnimatedBuilder(
                                        animation: _questionAnimation,
                                        builder: (context, child) => Opacity(
                                          opacity: _questionAnimation.value,
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: displayingQuestions[value]
                                                .options
                                                .map(
                                                  (e) => _buildOption(
                                                      e,
                                                      e ==
                                                          displayingQuestions[
                                                                  value]
                                                              .selectedAnswer),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ), //when the questionloadedfromdatabase variable is false it shows
                    // a circular progress indicator in the center of the question container
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goBack() async {
    if (numberOfQuestionsAnswered.value > 0) {
      await _animationController.reverse();
      numberOfQuestionsAnswered.value--;
      _animationController.forward();
    } else {
      await _animationController.reverse();
      Navigator.of(context).pop();
    }
  }

  void goAhead() async {
    await _animationController.reverse();
    numberOfQuestionsAnswered.value++;
    _animationController.forward();
  }

  Widget _buildOption(String option, bool selected) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? kPrimaryColor : Colors.white,
            border: Border.all(
              color: selected ? Colors.white : Colors.grey,
              width: 1,
            ),
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.none,
            child: Text(
              option,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
        SizedBox(
          height: displayHeight(context) * 0.02,
        ),
      ],
    );
  }
}
