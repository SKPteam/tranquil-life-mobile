// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';


class HealthReportScreen extends StatefulWidget {

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




  @override
  Widget build(BuildContext context) {
    //TODO I declared a variable displayingQuestionslenght = 2
    int displayingQuestionsLenght = 2;
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
                        value < displayingQuestionsLenght - 1
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
                                (false
                                    ? 1.0
                                    : displayingQuestionsLenght))
                                .toDouble() *
                                (true ? 0 : value + 1),
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
                         TextSpan(
                          text: 'Question ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 26,
                          ),
                        ),
                        TextSpan(
                          text: "Display Questions",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 26,
                          ),
                        ),
                        TextSpan(
                          text: 'Displaying question Number',
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
                        ? false
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
                              child: Text( "Display questions here",
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
                          // Expanded(
                          //   child: AnimatedBuilder(
                          //     animation: _questionAnimation,
                          //     builder: (context, child) => Opacity(
                          //       opacity: _questionAnimation.value,
                          //       child: ListView(
                          //         shrinkWrap: true,
                          //         children: displayingQuestions[value]
                          //             .options
                          //             .map(
                          //               (e) => _buildOption(
                          //               e,
                          //               e ==
                          //                   displayingQuestions[
                          //                   value]
                          //                       .selectedAnswer),
                          //         )
                          //             .toList(),
                          //       ),
                          //     ),
                          //   ),
                          // )
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