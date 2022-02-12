// ignore_for_file: file_names, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/models/card_model.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/main.dart';

import 'package:tranquil_life/pages/wallet/widgets/card_widget.dart';


class WalletCardStack extends StatefulWidget {
  Size size = MediaQuery.of(Get.context!).size;

  final List<CardModel> cardStack;

   WalletCardStack({Key? key, required this.cardStack}) : super(key: key);


  @override
  _WalletCardStackState createState() => _WalletCardStackState();
}

class _WalletCardStackState extends State<WalletCardStack> {
  Size size = MediaQuery.of(Get.context!).size;


  final WalletController _ = Get.put(WalletController());
  double positionOfFirstCard = 0;
  double localPositionOfFirstCard = 0;
  double positionOfsecondCard = 40;
  double positionOfthirdCard = 75;
  double positionOffourthCard = 110;
  double fractionForWidthOfSecondToFirstCard = 18 / 40;
  double fractionForWidthOfThirdToSecondCard = 12 / 35;
  double fractionForWidthOfFourthToThirdCard = 10 / 35;
  double opacityOfFirstCard = 1;
  double opacityOfLastCard = 0;
  bool dismissed = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _.cardStack.isNotEmpty
              ? Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              if (_.cardStack.length > 3)
                AnimatedPositioned(
                  duration: dismissed
                      ? const Duration(milliseconds: 0)
                      : const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  bottom: positionOffourthCard,
                  child: AnimatedOpacity(
                    duration: dismissed
                        ? const Duration(milliseconds: 0)
                        : const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    opacity: opacityOfLastCard,
                    child: AnimatedContainer(
                      duration: dismissed
                          ? const Duration(milliseconds: 0)
                          : const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      height: 180,
                      width: (size.width * 0.8) *
                          ((60 -
                              (fractionForWidthOfFourthToThirdCard *
                                  (positionOffourthCard - 110))) /
                              100),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: CardWidget(
                              cardModel: _.cardStack[3]
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ),
                ),
              if (_.cardStack.length > 2)
                AnimatedPositioned(
                  duration: dismissed
                      ? const Duration(milliseconds: 0)
                      : const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  bottom: positionOfthirdCard,
                  child: AnimatedContainer(
                    duration: dismissed
                        ? const Duration(milliseconds: 0)
                        : const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    height: 180,
                    width: (size.width * 0.8) *
                        ((70 -
                            (fractionForWidthOfThirdToSecondCard *
                                (positionOfthirdCard - 75))) /
                            100),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: CardWidget(
                            cardModel: _.cardStack[2]
                        ),
                      ),
                    ),
                  ),
                  // ),
                ),
              if (_.cardStack.length > 1)
                AnimatedPositioned(
                  duration: dismissed
                      ? const Duration(milliseconds: 0)
                      : const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  bottom: positionOfsecondCard,

                  child: AnimatedContainer(
                    duration: dismissed
                        ? const Duration(milliseconds: 0)
                        : const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    height: 180,
                    width: (size.width * 0.8) *
                        ((82 -
                            (fractionForWidthOfSecondToFirstCard *
                                (positionOfsecondCard - 40))) /
                            100),
                    child: Center(
                      child: CardWidget(
                          cardModel: _.cardStack[1]
                      ),
                    ),
                  ),
                  // ),
                ),
              AnimatedPositioned(
                duration: dismissed
                    ? const Duration(milliseconds: 0)
                    : const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                bottom: positionOfFirstCard,

                ///card index 0
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    print('index 0 tapped');
                    cardOptionsDialog(_.cardStack[0]);
                  },
                  onHorizontalDragStart: (details) {
                    setState(() {
                      dismissed = true;
                    });
                    localPositionOfFirstCard = details.localPosition.dy;
                  },
                  onHorizontalDragUpdate: (details) {
                    if (positionOfFirstCard >= -70 &&
                        localPositionOfFirstCard <
                            details.localPosition.dy) {
                      setState(() {
                        var localposition = localPositionOfFirstCard -
                            details.localPosition.dy;
                        positionOfFirstCard =
                        localposition < -70 ? -70 : localposition;
                        opacityOfFirstCard =
                            (70 + positionOfFirstCard) / 70;
                        if (positionOfsecondCard >= 0) {
                          positionOfsecondCard =
                          (40 + positionOfFirstCard) < 0
                              ? 0
                              : 40 + positionOfFirstCard;
                        }
                        if (positionOfthirdCard >= 40) {
                          positionOfthirdCard =
                          (75 + positionOfFirstCard) < 40
                              ? 40
                              : 75 + positionOfFirstCard;
                        }
                        if (positionOffourthCard >= 70) {
                          positionOffourthCard =
                          (110 + positionOfFirstCard) < 75
                              ? 75
                              : 110 + positionOfFirstCard;
                          opacityOfLastCard = (-positionOfFirstCard) / 70;
                        }
                      });
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    if (positionOfFirstCard <= -70 &&
                        _.cardStack.length > 1) {
                      print('END');

                      setState(() {
                        dismissed = true;
                        _.cardStack.removeAt(0);
                        positionOfFirstCard = 0;
                        positionOfsecondCard = 40;
                        opacityOfFirstCard = 1;
                        opacityOfLastCard = 0;
                        positionOfthirdCard = 75;
                        positionOffourthCard = 110;
                      });
                      print(_.cardStack);
                    } else {
                      setState(() {
                        dismissed = false;
                        positionOfFirstCard = 0;
                        opacityOfFirstCard = 1;
                        opacityOfLastCard = 0;
                        positionOfsecondCard = 40;
                        positionOfthirdCard = 75;
                        positionOffourthCard = 110;
                      });
                    }
                  },
                  child: AnimatedOpacity(
                    duration: dismissed
                        ? const Duration(milliseconds: 0)
                        : const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    opacity: opacityOfFirstCard,
                    child: AnimatedContainer(
                      duration: dismissed
                          ? const Duration(milliseconds: 0)
                          : const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      height: 180,
                      width: (size.width * 0.8),
                      child: Center(
                          child: CardWidget(
                              cardModel: _.cardStack[0]
                          )),
                    ),
                  ),
                ),
              ),
            ],
          )
              : const Center(
            child: Text('No Cards Found',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        ],
      ),
    );
  }

  Future <void> cardOptionsDialog(CardModel _model) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    onTap: () async {

                    },
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    horizontalTitleGap: 0,
                    title: Text(
                      !_model.isDefault ? 'Set as default' : 'Remove as default',
                      style: TextStyle(fontSize: size.width * 0.04),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      print('Clicked on Delete');
                      setState(() {
                        dismissed = true;
                        _.cardStack.removeAt(0);
                        _.allCardStackBeforeSwipingOff.remove(_model);
                        if (_.cardStack.isEmpty &&
                            _.allCardStackBeforeSwipingOff.isNotEmpty) {
                          _.cardStack.add(_.allCardStackBeforeSwipingOff.last);
                        }
                        positionOfFirstCard = 0;
                        positionOfsecondCard = 40;
                        opacityOfFirstCard = 1;
                        opacityOfLastCard = 0;
                        positionOfthirdCard = 75;
                        positionOffourthCard = 110;
                      });

                      Navigator.of(context).pop();
                    },
                    horizontalTitleGap: 0,
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text('Delete',
                        style: TextStyle(fontSize: size.width * 0.04)),
                  ),
                ],
              ),
            ),
          );
        });
  }
}