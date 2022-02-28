// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/add_new_card_controller.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/pages/wallet/widgets/cardNumber_inputFormatter.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';

import 'widgets/expiry_data_input_formatter.dart';

class AddNewCard extends StatefulWidget {
  final void Function(int index) reloadWalletPage;

  AddNewCard({Key? key, required this.reloadWalletPage}) : super(key: key);

  @override
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {

  final AddNewCardController _ = Get.put(AddNewCardController());


  String cardNumText = "";

  TextFormField cardNumberFormField(Size size) {
    return TextFormField(
      style: TextStyle(
          color: addNewCardController.cardNumController!.text == "Card Number"
              ? Colors.grey
              : Colors.black
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Card Number can\'t be empty';
        } else if (addNewCardController.cardValidator.validNumber(value.replaceAll(' ', ''))) {
          if (addNewCardController.cardValidator
              .getTypeForIIN(value.replaceAll(' ', ''))
              .toLowerCase() ==
              addNewCardController.selectedCardType.toLowerCase()) {
            return null;
          } else {
            return 'Card Type doesn\'t match the card Details';
          }
        } else {
          return 'Enter Valid Number';
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(19),
        CardNumberInputFormatter()
      ],
      autofocus: false,
      focusNode: addNewCardController.cardNumFocusNode,
      onChanged: (cardNumText) {
        setState(() {
          addNewCardController.cardNumFocusNode!.requestFocus();
        });
      },
      controller: addNewCardController.cardNumController!,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "Card Number",
        hintStyle: TextStyle(
          fontSize: size.width / 25,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField cardOwnerFormField(Size size) {
    return TextFormField(
      style: const TextStyle(
          color: Colors.black
      ),
      autofocus: false,
      focusNode: addNewCardController.cardOwnerFocusNode!,
      onChanged: (cardOwnerText) {
        setState(() {
          addNewCardController.cardOwnerFocusNode!.requestFocus();
        });
      },
      controller: addNewCardController.cardOwnerController!,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "Card Owner",
        hintStyle:
        TextStyle(fontSize: size.width / 25, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField cardCvvFormField(Size size) {
    return TextFormField(
      style: const TextStyle(
          color: Colors.black
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Cvv must not be empty';
        } else if (addNewCardController.cardValidator.validCVC(value)) {
          return null;
        } else {
          return 'Enter Valid Cvv';
        }
      },
      controller: addNewCardController.cardCvvController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "CVV",
        hintStyle:
        TextStyle(fontSize: size.width / 25, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField cardExpDateFormField(Size size) {
    return TextFormField(
      style: const TextStyle(
          color: Colors.black
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        ExpiryDateInputFormatter()
      ],
      autofocus: false,
      focusNode: addNewCardController.cardExpFocusNode!,
      onChanged: (expDate) {
        setState(() {
          addNewCardController.cardExpFocusNode!.requestFocus();
        });
      },
      controller: addNewCardController.cardExpDateController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "mm/yy",
        hintStyle:
        TextStyle(fontSize: size.width / 25, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size){
        return  Obx(() =>
            Scaffold(
              backgroundColor: kLightBackgroundColor,
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                title: Text("Add New Card"),
                actions: [
                  IconButton(
                      onPressed: (){
                        print("cliecke");
                        addNewCardController.addCard().then((value){
                          if(value['message'] == 'Success'){
                            Navigator.pop(context, true);
                          }
                        }).catchError((error)=>displaySnackBar("$error", context));
                      },
                      icon: Icon(Icons.check, color: light)),
                  SizedBox(width: size.width * 0.01)
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  height: size.height,
                  padding: EdgeInsets.all(35),
                  child: Form(
                    key: addNewCardController.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(8.0)),
                            padding: EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(addNewCardController.cardNumController!.text.toString(),
                                  style: TextStyle(fontSize: 22, color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('VALID \nTHRU',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18)),
                                    SizedBox(width: size.width * 0.01),
                                    Text(
                                        addNewCardController.cardExpDateController! == null
                                            ? ''
                                            : addNewCardController.cardExpDateController!.text.toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        addNewCardController.cardOwnerController! == null
                                            ? ''
                                            : addNewCardController.cardOwnerController!.text.toString(),
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Spacer(),
                                    SvgPicture.asset(
                                      addNewCardController.cardType.value == null ? '' : addNewCardController.cardType.value.toString(),
                                      color: Colors.white,
                                      height: 40.0,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        hint: const Text(
                                          'Select card type',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        //value: addNewCardController.selectedCardType,
                                        onChanged: (newValue) {
                                          addNewCardController.selectedCardType = newValue.toString();
                                        },
                                        items: addNewCardController.cardTypes.map((e) {
                                          return DropdownMenuItem(
                                              value: e['name'],
                                              onTap: () {
                                                if (e['id'] == '0') {
                                                  addNewCardController.cardType.value = e['image'];
                                                } else if (e['id'] == '1') {
                                                  addNewCardController.cardType.value = e['image'];
                                                } else if (e['id'] == '2') {
                                                  addNewCardController.cardType.value = e['image'];
                                                } else if (e['id'] == '3') {
                                                  addNewCardController.cardType.value = e['image'];
                                                }
                                                addNewCardController.cardTypeName.value = e['name'];
                                                print(addNewCardController.cardTypeName.value);
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    e['image'],
                                                    width: size.width * 0.08,
                                                    color: kPrimaryDarkColor,
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.06,
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 10),
                                                    child: Text(e['name']),
                                                  )
                                                ],
                                              ));
                                        }).toList(),
                                      )
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: cardNumberFormField(size)
                        ),
                        SizedBox(height: size.height * 0.02),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: cardOwnerFormField(size)
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Container(
                                  height: size.height * 0.1,
                                  width: size.width * 0.22,
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(child: cardExpDateFormField(size)),
                                    ],
                                  )),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: SizedBox(
                                height: size.height * 0.1,
                                width: size.width * 0.30,
                                child: Column(
                                  children: [
                                    Expanded(child: cardCvvFormField(size)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
        );
      },
    );
  }
}


