// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_font.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/questionnaire_controller.dart';
import 'package:tranquil_life/helpers/bottom_sheet_helper.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/models/questionnaire_option.dart';
import 'package:tranquil_life/pages/speak_with_consultant.dart';

import '../../routes/app_pages.dart';

class QuestionnaireView extends StatefulWidget {
  @override
  _QuestionnaireViewState createState() => _QuestionnaireViewState();
}

class _QuestionnaireViewState extends State<QuestionnaireView>
    with TickerProviderStateMixin {
  final QuestionnaireController _questionnaireController = Get.put(QuestionnaireController());
  final PageController pageController = PageController();

  int currentIndex = 0;

  //final GlobalKey<AnimatedListState> listKey = GlobalKey();


  @override
  void dispose() {
    animationController!.dispose();
    optionsFadeAnimationTimer?.cancel();
    extraQuestionAnimationController!.dispose();

    super.dispose();
  } // bool that is true when the question is fully loaded i.e animations

  //valueNotifier variable that rebuilds the selected part of UI
  //whenever there is a change in value
  ValueNotifier<int> numberOfQuestionsAnswered = ValueNotifier<int>(0);
  AnimationController? animationController;
  AnimationController? extraQuestionAnimationController;

  Animation<double>? questionAnimation;
  Animation<double>? extraQuestionAnimation;

  Timer? optionsFadeAnimationTimer;

  @override
  void initState() {
    //_questionnaireController.getQuestions();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    //animation controller initialization
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 500),
    );
    extraQuestionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 500),
    );
    //tween for opacity of question initialization
    questionAnimation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.ease))
        .animate(animationController!);
    extraQuestionAnimation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.ease))
        .animate(extraQuestionAnimationController!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO I declared a variable displayingQuestionslenght = 2 by Jason
    //int displayingQuestionsLength = 2;
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size) {
        return Scaffold(
          body: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_img1.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: FutureBuilder<List<Question>>(
                future: questionnaireController.listQuestions(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasData == false) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.yellow)),
                          // Loader Animation Widget
                          Padding(padding: const EdgeInsets.only(top: 20.0)),
                        ],
                      ),
                    );
                  }

                  if(snapshot.hasData){

                    questionnaireController.questionLoaded.value = true;

                    return Column(
                      children: [
                        //------------------------
                        // Back Button
                        //------------------------
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          width: size.width,
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                if (questionnaireController.questionLoaded.value) {
                                  if(numberOfQuestionsAnswered.value == 0 || numberOfQuestionsAnswered.value == 1){
                                    Get.offAllNamed(Routes.DASHBOARD);
                                  }else if(numberOfQuestionsAnswered.value != snapshot.data.length-1){
                                    numberOfQuestionsAnswered.value--;
                                    pageController.previousPage(
                                        duration: const Duration(microseconds: 5), curve: Curves.fastOutSlowIn);
                                  }else{
                                    numberOfQuestionsAnswered.value--;
                                    pageController.previousPage(
                                        duration: const Duration(microseconds: 5), curve: Curves.fastOutSlowIn);
                                  }
                                }
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(Icons.arrow_back, color: Colors.white),
                              ),
                            ),
                          ),
                        ),


                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        //------------------------
                        // container that contains the filling container
                        //------------------------
                        Container(
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
                              //------------------------
                              // container that keeps filling according to the questions answered with green color
                              //------------------------
                              child: ValueListenableBuilder(
                                valueListenable: numberOfQuestionsAnswered,
                                builder: (context, value, child) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    width: (size.width*0.8/
                                        (snapshot.data.length == 0 ? 0.1 : snapshot.data.length))
                                        .toDouble() * (value as int),
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: size.height * 0.02,
                        ),

                        //------------------------
                        // Question Number HEADING
                        //------------------------
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(16),
                          child: ValueListenableBuilder(
                            valueListenable: numberOfQuestionsAnswered,
                            builder: (context, value, child) => RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'Question ',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                      fontFamily: josefinSansRegular
                                  ),
                                ),
                                TextSpan(
                                  text: '${(value as int)}',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                      fontFamily: josefinSansRegular

                                  ),
                                ),
                                TextSpan(
                                  text: '/${snapshot.data.length}',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: josefinSansRegular,
                                    fontSize: 18,
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),

                        Expanded(
                            child: Container(
                              margin: EdgeInsets.all(18),
                              padding: EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),

                              child: questionnaireController.questionLoaded.value
                                  ?
                              PageView.builder(
                                controller: pageController,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index){
                                  final int count = snapshot.data!.length > 10 ? 10 : snapshot.data!.length;
                                  final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)));animationController!.forward();

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: size.height*0.02),
                                        Text(
                                          snapshot.data![index].q1!,
                                          style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black, fontSize: 24),
                                        ),
                                        Spacer(),
                                        Column(
                                          children: snapshot.data![index].q1Options.map<Widget>((option){
                                            return InkWell(
                                              onTap: (){
                                                if(option == snapshot.data![index].q1Trigger){
                                                  //open modal dialog for q2
                                                }else if(numberOfQuestionsAnswered.value != snapshot.data.length-1){
                                                  pageController.nextPage(
                                                      duration: const Duration(microseconds: 5), curve: Curves.fastOutSlowIn);
                                                  numberOfQuestionsAnswered.value++;
                                                }else{
                                                  print("last question");
                                                  numberOfQuestionsAnswered.value++;

                                                  Future.delayed(Duration(milliseconds: 500), (){
                                                    Get.toNamed(Routes.CONSULTANT_LIST);
                                                  });
                                                }

                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Container(
                                                    height: 70,
                                                    width: double.maxFinite,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: active),
                                                    child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 18.0),
                                                          child: Text(
                                                            option,
                                                            style: TextStyle(color: light, fontSize: 18),
                                                          ),
                                                        ))),
                                              ),
                                            );
                                          }).toList(),
                                        ),

                                        Spacer(),

                                      ],
                                    ),
                                  );
                                },
                              )
                                  :
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                        )
                      ],
                    );
                  }

                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Text('No Questions');
                  }

                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }


                  if (snapshot.data! == null || snapshot.data!.isEmpty) {
                    return Column(
                      children: <Widget>[
                        Center(child: Text("Unable to find any questions"))
                      ],
                    );
                  }

                  return Text('No Data');
                },
              )
          ),
        );
      },
    );
  }

  // void _showOptionTwoDetails(BuildContext context, int index,{void Function()? onTap}){
  //   MyBottomSheet()
  //       .showDismissibleBottomSheet(
  //       context: context,
  //       height: MediaQuery.of(context).size.height / 2.5,
  //       children: [
  //         Text(_questionnaireController.listOfQuestions![index].q2!,
  //             style: Theme.of(context).textTheme.headline5?.copyWith(
  //                 fontSize: 25, color: Colors.black)),
  //         SizedBox(height: 40),
  //         ..._questionnaireController.listOfQuestions![index].q2Options!.map((element)
  //         =>InkWell(
  //           onTap: onTap,
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Container(
  //               height: 70,width: MediaQuery.of(context).size.width,
  //               decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: active,),
  //               child: Align(alignment: Alignment.centerLeft,
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(left: 18.0),
  //                     child: Text(element, style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white, fontSize: 28),),
  //                   )),),
  //           ),
  //         ),
  //   ),
  //   ]
  //   );
  // }
  //
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
  //
  // void goBack() async {
  //   if (numberOfQuestionsAnswered.value > 0) {
  //     await _animationController!.reverse();
  //     numberOfQuestionsAnswered.value--;
  //     _animationController!.forward();
  //   } else {
  //     await _animationController!.reverse();
  //     Navigator.of(context).pop();
  //   }
  // }
  //
  // void goAhead() async {
  //   await _animationController!.reverse();
  //   numberOfQuestionsAnswered.value++;
  //   _animationController!.forward();
  // }
  //
  // static const kPrimaryGradient = LinearGradient(
  //   colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
  //   begin: Alignment.centerLeft,
  //   end: Alignment.centerRight,
  // );
}
