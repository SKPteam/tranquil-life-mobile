import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/controllers/questionnaire_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/models/questionnaire_option.dart';

class QuestionnaireView extends StatefulWidget {
  @override
  _QuestionnaireViewState createState() => _QuestionnaireViewState();
}

class _QuestionnaireViewState extends State<QuestionnaireView>
    with TickerProviderStateMixin{
  QuestionnaireController _questionnaireController = Get.put(QuestionnaireController());

  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  // bool that is true when the question is fully loaded i.e animations
  // are complete to avoid distortions in animation
  bool questionLoaded = false;
  //valueNotifier variable that rebuilds the selected part of UI
  //whenever there is a change in value
  ValueNotifier<int> numberOfQuestionsAnswered = ValueNotifier<int>(0);
  AnimationController? _animationController;
  AnimationController? _extraQuestionAnimationController;

  Animation<double>? _questionAnimation;
  Animation<double>? _extraQuestionAnimation;

  Timer? _optionsFadeAnimationTimer;
  RxList q1Options = [].obs;
  RxList q2Options = [].obs;
  int indexAtWhichExtraQuestionExists = -1;
  int numberOfOptionsInQ2 = 0;

  int numberOfOptions = 0;
  bool questionsLoadedFromDatabase = false; // variable for loading logics
  bool q2QuestionDisplayed = false; //boolean value to be set to true when modal sheet pops up
  bool onQuestion3 = false;
  late Map map;

  @override
  void initState() {
    //animation controller initialization
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 500),
    );
    _extraQuestionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 500),
    );
    //tween for opacity of question initialization
    _questionAnimation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController!);
    _extraQuestionAnimation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_extraQuestionAnimationController!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO I declared a variable displayingQuestionslenght = 2
    int displayingQuestionsLength = 2;
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size){
        return Scaffold(
          body: WillPopScope(
            onWillPop: () async{
              goBack();
              return false;
            },
            child: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_img1.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child:  Column(
                children: [
                  //------------------------
                  // Back Button
                  //------------------------
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: size.width,
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
                          value < displayingQuestionsLength - 1
                              ? child ?? Container()
                              : Container(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.02,
                  ),

                  //------------------------
                  // container that contains the filling container
                  //------------------------
                  SizedBox(
                    height: 30,
                    child: Center(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: size.width * 0.8,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[600]!,
                          ),
                        ),

                        child: ValueListenableBuilder(
                          valueListenable: numberOfQuestionsAnswered,
                          builder: (context, value, child){
                            return Container();
                          },

                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.02,
                  ),

                ],
              ),
            ),

          ),
        );
      },
    );
  }

  void goBack() async {
    if (numberOfQuestionsAnswered.value > 0) {
      await _animationController!.reverse();
      numberOfQuestionsAnswered.value--;
      _animationController!.forward();
    } else {
      await _animationController!.reverse();
      Navigator.of(context).pop();
    }
  }

  void goAhead() async {
    await _animationController!.reverse();
    numberOfQuestionsAnswered.value++;
    _animationController!.forward();
  }

}

