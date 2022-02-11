// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:tranquil_life/models/card_model.dart';
import 'package:tranquil_life/helpers/constants.dart';
import 'package:tranquil_life/models/card_model.dart';
import 'package:tranquil_life/pages/wallet/widgets/card_color.dart';

class CardWidget extends StatefulWidget {
  final CardModel cardModel;

  const CardWidget({Key? key, required this.cardModel}) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {

  List<Color> getCardColor() {
    List<Color> tempColor;
    switch (widget.cardModel.color) {
      case CardColor.yellow:
        tempColor = [
          const Color(0xFFFFEE58),
          const Color(0xFFFDD835),
          const Color(0XFFF9A825)
        ];
        break;
      case CardColor.blue:
        tempColor = [const Color(0xFF42A5F5), const Color(0xFF1E88E5), const Color(0xFF1565C0)];
        break;
      case CardColor.green:
        tempColor = [const Color(0xFF66BB6A), const Color(0xFF43A047), const Color(0xFF2E7D32)];
        break;
      case CardColor.red:
        tempColor = [const Color(0xFFEF5350), const Color(0xFFE53935), const Color(0xFFC62828)];
        break;
      default:
        tempColor = [Colors.black26, Colors.black45, Colors.black87];
        break;
    }
    return tempColor;
  }

  //final AddNewCardController _ = Get.put(AddNewCardController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox.expand(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(3, 6),
                ),
              ],
              gradient: LinearGradient(
                  colors: getCardColor(),
                  end: Alignment.topLeft,
                  begin: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text( "",
                    // EncryptionHelper.handleDecryption(widget.cardModel.cardNumber)
                    //     .replaceAll(" ", "  ")
                    //     .replaceRange(6, 10, '****')
                    //     .replaceRange(12, 16, '****'),
                    // style: const TextStyle(
                    //     fontSize: 20, color: Colors.white, letterSpacing: 2),
                    // textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text( "",
                          // EncryptionHelper
                          //   .handleDecryption(widget.cardModel.cardOwner),
                          // style: const
                          // TextStyle(fontSize: 18, color: Colors.white),
                          // textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      widget.cardModel.logoAsset!,
                      color: Colors.white,
                      height: 25,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        if (widget.cardModel.isDefault)
        //Here the checkBox is positioned4594
          const Positioned(
            bottom: -10,
            right: -8,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: kPrimaryColor,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Icon(
                      Icons.check,
                      color: kPrimaryColor,
                      size: 20,
                    )
                ),
              ),
            ),
          )
      ],
    );
  }
}