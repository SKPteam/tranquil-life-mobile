import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/questionnaire_controller.dart';
import 'package:tranquil_life/helpers/bottom_sheet_helper.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/models/question_model.dart';
import 'package:tranquil_life/models/questionnaire_option.dart';
import 'package:tranquil_life/pages/speak_with_consultant.dart';

class QuestionnaireView extends StatefulWidget {
  @override
  _QuestionnaireViewState createState() => _QuestionnaireViewState();
}

class _QuestionnaireViewState extends State<QuestionnaireView>
    with TickerProviderStateMixin {
  final QuestionnaireController _questionnaireController = Get.put(QuestionnaireController());
  final PageController pageController = PageController();

  int currentIndex = 0;

  final GlobalKey<AnimatedListState> listKey = GlobalKey();


  @override
  void dispose() {
    animationController?.dispose();
    _animationController?.dispose();
    super.dispose();
  } // bool that is true when the question is fully loaded i.e animations
  // are complete to avoid distortions in animation
  bool questionLoaded = false;
  //valueNotifier variable that rebuilds the selected part of UI
  //whenever there is a change in value
  ValueNotifier<int> numberOfQuestionsAnswered = ValueNotifier<int>(0);
  AnimationController? _animationController;
  AnimationController? animationController;
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
  bool q2QuestionDisplayed =
      false; //boolean value to be set to true when modal sheet pops up
  bool onQuestion3 = false;
  late Map map;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
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
      responsiveBuilder: (context, size) {
        return GetBuilder<QuestionnaireController>(builder: (controller) {
          return Scaffold(
            body: WillPopScope(
              onWillPop: () async {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.white),
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
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.white),
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
                    // SizedBox(
                    //   height: 30,
                    //   child: Center(
                    //     child: Container(
                    //       clipBehavior: Clip.hardEdge,
                    //       width: size.width * 0.8,
                    //       height: 30,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(20),
                    //         color: Colors.white,
                    //         border: Border.all(
                    //           color: Colors.grey[600]!,
                    //         ),
                    //       ),
                    //       child: ValueListenableBuilder(
                    //         valueListenable: numberOfQuestionsAnswered,
                    //         builder: (context, value, child){
                    //           return Container();
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.8,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[600]!),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Stack(
                            children: [
                              // LayoutBuilder provide us the available space for the container
                              // constraints.maxWidth needed for our animation
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    color: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    minHeight: 50,
                                    value: _questionnaireController.isFetchingQuestions == true ? 0 :
                                    _questionnaireController.questionProgress / _questionnaireController.listOfQuestions!.length,
                                    valueColor: const AlwaysStoppedAnimation(active),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: size.height * 0.05,
                    ),

                    GetBuilder<QuestionnaireController>(builder: (controller)
                    {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text.rich(TextSpan(
                          text: "Question ${currentIndex + 1}",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.black45),
                          children: [
                            TextSpan(
                              text: "/${_questionnaireController.listOfQuestions?.length ?? ""}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.black45),
                            ),
                          ],
                        )),
                      );
                    }),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    _questionnaireController.isFetchingQuestions == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: PageView.builder(
                                controller: pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _questionnaireController
                                    .listOfQuestions!.length,
                                itemBuilder: (context, index) {
                                  final int count = _questionnaireController.listOfQuestions!.length > 10 ? 10 : _questionnaireController.listOfQuestions!.length;
                                  final Animation<double> animation =
                                      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController!,
                                              curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)));animationController!.forward();
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Container(width: double.maxFinite,
                                        decoration: BoxDecoration(color: Colors.white,
                                            borderRadius: BorderRadius.circular(30)),
                                        height: MediaQuery.of(context).size.height / 1.5,
                                        child: AnimatedBuilder(
                                          animation: animation,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: Transform(
                                                transform:
                                                    Matrix4.translationValues(0.0, 50 * (1.0 - animation.value), 0.0,),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(18),
                                                  child: Column(
                                                    children: [
                                                      const Spacer(),
                                                      Text(
                                                        _questionnaireController.listOfQuestions![index].q1!,
                                                        style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black, fontSize: 40),
                                                      ),
                                                      const Spacer(),
                                                      InkWell(
                                                          onTap: () {
                                                            if(_questionnaireController.listOfQuestions![index].q2Options != null){
                                                              _showOptionTwoDetails(context, index, onTap: (){
                                                                setState(() {
                                                                  currentIndex = index;
                                                                  if(currentIndex + 1 == _questionnaireController.listOfQuestions!.length){
                                                                    Get.offAll(()=>const SpeakWithConsultant());
                                                                  }else{
                                                                    pageController.nextPage(
                                                                        duration: const Duration(microseconds: 5), curve: Curves.fastOutSlowIn);
                                                                    _questionnaireController.questionProgress++;
                                                                  }
                                                                  Get.back();
                                                                });
                                                              });
                                                            }else {
                                                              pageController.nextPage(
                                                                  duration: const Duration(microseconds: 5), curve: Curves.fastOutSlowIn);
                                                              setState(() {
                                                                currentIndex = index;
                                                                _questionnaireController.questionProgress++;
                                                              });
                                                              currentIndex == _questionnaireController.listOfQuestions!.length ? Get.offAll(() => const SpeakWithConsultant()) : null;
                                                            }
                                                          },
                                                          child: getTextWidgets(_questionnaireController.listOfQuestions![index].q1Options!)),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                  );
                                }),
                          ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showOptionTwoDetails(BuildContext context, int index,{void Function()? onTap}){
    MyBottomSheet().showDismissibleBottomSheet(context: context, height: MediaQuery.of(context).size.height / 2.5, children: [
      Text(_questionnaireController.listOfQuestions![index].q2!, style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 25, color: Colors.black),),
      const SizedBox(height: 40,),
      ..._questionnaireController.listOfQuestions![index].q2Options!.map((element)=>InkWell(onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 70,width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: active,),
          child: Align(alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(element, style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white, fontSize: 28),),
              )),),
      ),
      ),
    ),
    ]
    );
  }

  Widget getTextWidgets(List<String> strings) {
    return Column(
        children: strings
            .map((item) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 70,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: active),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(
                              item,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.white, fontSize: 30),
                            ),
                          ))),
                ))
            .toList());
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

  static const kPrimaryGradient = LinearGradient(
    colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
