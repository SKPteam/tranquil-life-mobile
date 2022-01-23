// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';


import '../../../../main.dart';

class ConsultationQuestionnaireView extends StatelessWidget {
  const ConsultationQuestionnaireView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConsultationQuestionnaireController());
    return Scaffold(
      //------------------------
      // background image container container
      //------------------------
      body: Container(
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      if (controller.questionLoaded.isTrue) {
                        onOptionTapped(
                            value: controller.numberOfQuestionsAnswered.value,
                            context: context,
                            backPressed: true,
                            controller: controller);
                      }
                    },
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
                      valueListenable: controller.numberOfQuestionsAnswered,
                      builder: (context, int value, child) => Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          width: ((displayWidth(context) * 0.8) /
                              ((controller.questionsForQuestionaire
                                  ?.isEmpty ??
                                  true)
                                  ? 1.0
                                  : controller.questionsForQuestionaire!
                                  .length))
                              .toDouble() *
                              value,
                          height: 30,
                          decoration: const BoxDecoration(
                            color:  kPrimaryColor,
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
                  valueListenable: controller.numberOfQuestionsAnswered,
                  builder: (context, int value, child) => Obx(
                        () => RichText(
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
                          text: '${value + 1}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 26,
                          ),
                        ),
                        TextSpan(
                          text: controller.questionsForQuestionaire != null
                              ? '/${controller.questionsForQuestionaire!.length}'
                              : '/0',
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
                  child: Obx(
                        () => controller.questionsLoadedFromDatabase.value
                        ? ValueListenableBuilder(
                      valueListenable:
                      controller.numberOfQuestionsAnswered,
                      builder: (context, int value, child) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //------------------------
                          // QUESTION
                          //------------------------
                          //using animation builder for opacity
                          AnimatedBuilder(
                            animation: controller.questionAnimation,
                            builder: (context, child) => Opacity(
                              opacity: controller.questionAnimation.value,
                              child: Text(
                                controller
                                    .questionsForQuestionaire![value]
                                    .question,
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
                            child: AnimatedList(
                              key: controller.listKey,
                              initialItemCount:
                              controller.options!.length,
                              itemBuilder: (context, index, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: _buildOption(
                                      option:
                                      controller.options![index].option,
                                      context: context,
                                      ontap: () {
                                        print(value);
                                        if (controller
                                            .questionLoaded.isTrue) {
                                          onOptionTapped(
                                              value: value,
                                              index: index,
                                              context: context,
                                              controller: controller);
                                        }
                                      },
                                    ),
                                  ),
                            ),
                          )
                        ],
                      ),
                    )
                        : const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ), //when the questionloadedfromdatabase variable is false it shows
                  // a circular progress indicator in the center of the question container
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///builds options widgets
  Widget _buildOption(
      {required String option,
        void Function()? ontap,
        required BuildContext context}) {
    return Column(
      children: [
        InkWell(
          onTap: ontap,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.green,
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
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

  ///deleting options when one is selected for animation purposes
  ///[index] property is the index of the option that has to be deleted
  void _deleteOptionWithAnimation(
      {required int index,
        required BuildContext context,
        required ConsultationQuestionnaireController controller}) {
    var option = controller.options!.removeAt(index);

    //using global key of animatedList to remove a item with animation
    controller.listKey.currentState!.removeItem(
      index,
          (BuildContext context, Animation<double> animation) {
        return FadeTransition(
          opacity:
          CurvedAnimation(parent: animation, curve: const Interval(0.5, 1.0)),
          child: SizeTransition(
            sizeFactor:
            CurvedAnimation(parent: animation, curve: const Interval(0.0, 1.0)),
            axisAlignment: 0.0,
            child: _buildOption(option: option.option, context: context),
          ),
        );
      },
      duration: const Duration(milliseconds: 300),
    );
  }

  /// on Option tapped function does animation stuff to provide a seemless experience
  /// and the [value] property is the current question number while [index] property
  /// is the tapped option index of the question
  void onOptionTapped(
      {required int value,
        int? index,
        bool backPressed = false,
        bool extraQuestionOptionTapped = false,
        required ConsultationQuestionnaireController controller,
        required BuildContext context}) async {
    //check if the option is expandable if it is open a modal sheet
    if (backPressed ||
        extraQuestionOptionTapped ||
        !controller.options![index!].expandable) {
      controller.questionLoaded.value = false;
      //using this boolean to only use __animationCOntroller when next or previous question
      //is available and the screen is not changes or controller is not disposed
      bool availableQuestion = true;
      //deleting options with animation one by one
      for (int i = controller.options!.length; i > 0; i--) {
        _deleteOptionWithAnimation(
            index: i - 1, context: context, controller: controller);
      }
      //re-initializing options list and number of options in the question
      controller.options = <QuestionaireOption>[].obs;
      controller.numberOfOptions = 0;
      print(value);
      // reversing the fade animation on question
      await controller.animationController.reverse();
      //storing the selected index of the option selected
      if (index != null &&
          value < controller.questionsForQuestionaire!.length &&
          !backPressed) {
        controller.questionsForQuestionaire![value].setSelectedOption = index;
        //checking if the value is last question index i.e if 10 questions then the value is 9
        //then navigate to next page else increase the question number
        print(
            '$value length ${controller.questionsForQuestionaire!.length - 1}');
        if (value == controller.questionsForQuestionaire!.length - 1) {
          int questionNumber = 1;
          List<Map<String, String>> answersMap = [];
          //if all the 10 questions are answers going to next screen
          var answersList = List.generate(
            controller.questionsForQuestionaire!.length,
                (questionIndex) {
              Question question =
              controller.questionsForQuestionaire![questionIndex];
              bool expandable =
                  question.options[question.getSelectedAnswerIndex].expandable;
              print('Question ${questionIndex + 1}: ' + question.toString());
              print(
                  'Option ${question.getSelectedAnswerIndex + 1} is expanded: ' +
                      expandable.toString());
              if (expandable) {
                print(
                    'Extra Question Option ${question.options[question.getSelectedAnswerIndex].question!.getSelectedAnswerIndex + 1}: ' +
                        question.options[question.getSelectedAnswerIndex]
                            .question!.getSelectedAnswer);
              }
              return QuestionaireAnswerSelectedModel(
                answer: controller
                    .questionsForQuestionaire![questionIndex].getSelectedAnswer,
                question: controller
                    .questionsForQuestionaire![questionIndex].question,
                answerIndex: question.getSelectedAnswerIndex,
                answerForExtraQuestion: expandable
                    ? question.options[question.getSelectedAnswerIndex]
                    .question!.getSelectedAnswer
                    : null,
                extraQuestion: expandable
                    ? question.options[question.getSelectedAnswerIndex]
                    .question!.question
                    : null,
                answerForExtraQuestionIndex: expandable
                    ? question.options[question.getSelectedAnswerIndex]
                    .question!.getSelectedAnswerIndex
                    : null,
              );
            },
          );

          for (var e in answersList) {
            print('entering answers');
            answersMap.add({
              'question$questionNumber': e.question,
              'answer$questionNumber': e.answer,
            });
            questionNumber++;
            if (e.extraQuestion != null) {
              answersMap.add({
                'question$questionNumber': e.extraQuestion!,
                'answer$questionNumber': e.answerForExtraQuestion!,
              });
              questionNumber++;
            }
          }

          await FirebaseFirestore.instance
              .collection('healthQuestionnaire')
              .doc(auth!.currentUser!.uid)
              .set({'questionnaire': answersMap});
          availableQuestion = false;
          Get.delete<ConsultationQuestionnaireController>();
          Get.off(() => ConsultantListView(answerOfQuestionaire: answersMap));
          return;
        } else {
          //increasing the index of the question to be displayed
          controller.numberOfQuestionsAnswered.value++;
        }
      } else if (value < controller.questionsForQuestionaire!.length &&
          value > 0 &&
          backPressed) {
        controller.numberOfQuestionsAnswered.value--;
      } else if (value == 0 && backPressed) {
        availableQuestion = false;
        Get.back();
        return;
      }
      // else if (value >= questionsForQuestionaire!.length - 2) {

      // }
      if (availableQuestion) {
        //re-starting the animation for the next question using fade animation and timer
        //as before in initState
        await Future.delayed(const Duration(milliseconds: 300));
        controller.animationController.forward();
        Future.delayed(const Duration(milliseconds: 100)).then(
              (value) {
            controller.optionsFadeAnimationTimer = Timer.periodic(
              const Duration(milliseconds: 150),
                  (timer) {
                print(controller.numberOfOptions);
                //print(options);
                if (controller.numberOfOptions <
                    controller
                        .questionsForQuestionaire![
                    controller.numberOfQuestionsAnswered.value]
                        .options
                        .length) {
                  controller.options!.add(controller
                      .questionsForQuestionaire![
                  controller.numberOfQuestionsAnswered.value]
                      .options[controller.numberOfOptions]);
                  controller.listKey.currentState!.insertItem(
                      controller.numberOfOptions,
                      duration: const Duration(milliseconds: 500));
                  controller.numberOfOptions++;
                } else {
                  controller.optionsFadeAnimationTimer?.cancel();
                  controller.questionLoaded.value = true;
                }
              },
            );
          },
        );
      }
    } else {
      //setting extraQuestionDisplayed variable to true stating that the
      // extra question modal sheet is opened
      controller.extraQuestionDisplayed.value = true;
      //setting default values for extra Question variables
      controller.numberOfOptionsInExtraQuestion = 0;
      //setting the index of the option on which the current extra question is opened
      controller.indexAtWhichExtraQuestionExists = index;
      //setting the options of extraQuestion
      controller.extraQuestionOptions = RxList(controller
          .questionsForQuestionaire![value]
          .options[controller.indexAtWhichExtraQuestionExists]
          .question!
          .options);
      //resetting and then forwarding the fading animation of extra question
      controller.extraQuestionAnimationController.reset();
      controller.extraQuestionAnimationController.forward();
      //showing bottom sheet for extra question
      await showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: displayHeight(context) * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(28),
            child: AnimatedBuilder(
              animation: controller.extraQuestionAnimation,
              builder: (context, child) => Opacity(
                opacity: controller.extraQuestionAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //------------------------
                    // QUESTION
                    //------------------------
                    //using animation builder for opacity
                    AnimatedBuilder(
                      animation: controller.questionAnimation,
                      builder: (context, child) => Opacity(
                        opacity: controller.questionAnimation.value,
                        child: Text(
                          controller
                              .questionsForQuestionaire![value]
                              .options[controller
                              .indexAtWhichExtraQuestionExists]
                              .question!
                              .question,
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
                      child: AnimatedList(
                        initialItemCount:
                        controller.extraQuestionOptions!.length,
                        itemBuilder: (context, index, animation) =>
                            FadeTransition(
                              opacity: animation,
                              child: _buildOption(
                                option: controller
                                    .extraQuestionOptions![index].option,
                                context: context,
                                ontap: () async {
                                  print(value);
                                  if (controller.questionLoaded.value) {
                                    //reversing the dafing animation of extra question
                                    await controller
                                        .extraQuestionAnimationController
                                        .reverse();
                                    //setting the extra question displayed variable to false
                                    //to state that extra question is done and closed
                                    controller.extraQuestionDisplayed.value =
                                    false;
                                    //exiting the modalSheet
                                    Navigator.of(context).pop();
                                    //recording the answer of the extra question
                                    controller
                                        .questionsForQuestionaire![value]
                                        .options[controller
                                        .indexAtWhichExtraQuestionExists]
                                        .question!
                                        .setSelectedOption = index;
                                    //this method is called to recreate the animation of going to next question
                                    onOptionTapped(
                                      value: value,
                                      index: controller
                                          .indexAtWhichExtraQuestionExists,
                                      controller: controller,
                                      context: context,
                                      extraQuestionOptionTapped: true,
                                    );
                                  }
                                },
                              ),
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ));
      //if the modal sheet is dismissed through barrier dismissle that is not by tapping on options
      // state that the modal sheet is closed and done
      controller.extraQuestionDisplayed.value = false;
    }
  }
}
