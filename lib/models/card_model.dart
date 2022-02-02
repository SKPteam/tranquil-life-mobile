// ignore_for_file: file_names

import 'dart:math';

import 'package:tranquil_life/pages/wallet/widgets/card_color.dart';

class CardModel {
  final String cardId;
  final String cardNumber;
  final String cardOwner;
  final String cardType;
  final String cardExpiryDate;
  final String cardCVV;
  bool isDefault;

  CardColor? color;
  String? logoAsset;

  CardModel(this.cardId, this.cardNumber, this.cardOwner, this.cardType,
      this.cardExpiryDate, this.cardCVV,
      [this.isDefault = false]) {
    var ran = Random().nextInt(4);
    color = CardColor.values[ran];

    switch (cardType) {
      case 'VISA':
        logoAsset = 'assets/icons/icon-visa.svg';
        break;
      case 'VERVE':
        logoAsset = 'assets/icons/icon-verve.svg';
        break;
      case 'MASTERCARD':
        logoAsset = 'assets/icons/icon-mastercard.svg';
        break;
      default:
        logoAsset = 'assets/icons/icon-american-express.svg';
        break;
    }
    //TODO: do the work here for converting cardType string to it's svg asset url
  }
}