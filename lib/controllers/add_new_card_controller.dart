import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';

class AddNewCardController extends GetxController{
  static AddNewCardController instance = Get.find();

  TextEditingController? cardNumController;
  TextEditingController? cardOwnerController;
  TextEditingController? cardCvvController;
  TextEditingController? cardExpDateController;

  final PaymentCard cardValidator = PaymentCard.empty();
  FocusNode? cardNumFocusNode,
      cardOwnerFocusNode,
      cardExpFocusNode,
      cardCvvFocusNode;
  RxList<Map> cardTypes = <Map>[].obs;

  RxString cardId = "".obs;
  RxString cardNumText = "".obs;
  RxString cardOwnerText = "".obs;
  RxString cvvText = "".obs;
  RxString expDate = "".obs;
  RxString cardTypeName = "".obs;

  final formKey = GlobalKey<FormState>();
  String selectedCardType = "";
  RxString cardType = "".obs;

  cardNum() {
    if (cardNumController!.text == "") {
      cardNumController = TextEditingController(text: "Card Number");
    }
  }

  @override
  void onInit() {
    cardNumController = TextEditingController();
    cardOwnerController = TextEditingController();
    cardCvvController = TextEditingController();
    cardExpDateController = TextEditingController();

    cardNumFocusNode = FocusNode();
    cardOwnerFocusNode = FocusNode();
    cardCvvFocusNode = FocusNode();
    cardExpFocusNode = FocusNode();

    cardNum();

    cardTypes.value = [
      {
        'id': '0',
        'image': 'assets/icons/icon-visa.svg',
        'name': CardType.visa.toUpperCase()
      },
      {
        'id': '1',
        'image': 'assets/icons/icon-verve.svg',
        'name': CardType.verve.toUpperCase()
      },
      {
        'id': '2',
        'image': 'assets/icons/icon-mastercard.svg',
        'name': CardType.masterCard.toUpperCase()
      },
      {
        'id': '3',
        'image': 'assets/icons/icon-american-express.svg',
        'name': CardType.americanExpress.toUpperCase()
      },
    ];

    super.onInit();
  }

  @override
  void onClose() {
    cardNumFocusNode!.dispose();
    cardOwnerFocusNode!.dispose();
    cardCvvFocusNode!.dispose();

    super.onClose();
  }
}