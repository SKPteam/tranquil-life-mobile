// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:tranquil_life/constants/app_strings.dart';
// import 'package:tranquil_life/constants/style.dart';
// import 'package:tranquil_life/controllers/wallet_controller.dart';
// import 'package:tranquil_life/helpers/sizes_helpers.dart';
// import 'package:tranquil_life/pages/wallet/widgets/cardNumber_inputFormatter.dart';
// import 'package:tranquil_life/widgets/custom_snackbar.dart';
//
//
//
//
// class AddNewCard extends StatefulWidget {
//
//   final void Function(int index) reloadWalletPage;
//
//   const AddNewCard({Key? key, required this.reloadWalletPage}) : super(key: key);
//
//   @override
//   _AddNewCardState createState() => _AddNewCardState();
// }
//
// class _AddNewCardState extends State<AddNewCard> {
//
//   final AddNewCardController _ = Get.find<AddNewCardController>();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() =>
//         Scaffold(
//           backgroundColor: kLightBackgroundColor,
//           appBar: AppBar(
//             backgroundColor: kPrimaryColor,
//             title: Text("Add New Card"),
//             actions: [
//               InkWell(child: Text("Add New Card"),)
//             ],
//           ),
//           body: SingleChildScrollView(
//             child: Container(
//               height: displayHeight(context),
//               padding: EdgeInsets.all(35),
//               child: Form(
//                 key: _.formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 180,
//                       width: double.infinity,
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: kPrimaryColor,
//                             borderRadius: BorderRadius.circular(8.0)),
//                         padding: EdgeInsets.all(12),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 10),
//                             Text(_.cardNumController!.text == "Card Number"
//                                 ? ""
//                                 : _.cardNumController!.text.toString()
//                               ,
//                               style: TextStyle(fontSize: 22, color: Colors.white),
//                               textAlign: TextAlign.start,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text('VALID \nTHRU',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: displayWidth(context) * 0.02)),
//                                 SizedBox(width: displayWidth(context) * 0.01),
//                                 Text(
//                                     _.cardExpDateController! == null
//                                         ? ''
//                                         : _.cardExpDateController!.text.toString(),
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.white))
//                               ],
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   child: Text(
//                                     _.cardOwnerController! == null
//                                         ? ''
//                                         : _.cardOwnerController!.text.toString(),
//                                     style: TextStyle(
//                                         fontSize: 18, color: Colors.white),
//                                     textAlign: TextAlign.start,
//                                   ),
//                                 ),
//                                  Spacer(),
//                                 SvgPicture.asset(
//                                   _.cardType.value == null ? '' : _.cardType.value.toString(),
//                                   color: Colors.white,
//                                   height: 40.0,
//                                   fit: BoxFit.cover,
//                                 ),
//                                  SizedBox(
//                                   width: 10,
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                             child: DropdownButtonHideUnderline(
//                               child: ButtonTheme(
//                                   alignedDropdown: true,
//                                   child: DropdownButton(
//                                     hint: const Text(
//                                       'Select card type',
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     //value: _.selectedCardType,
//                                     onChanged: (newValue) {
//                                       setState(() {
//                                         _.selectedCardType = newValue.toString();
//                                       });
//                                     },
//                                     items: _.cardTypes.map((e) {
//                                       return DropdownMenuItem(
//                                           value: e['name'],
//                                           onTap: () {
//                                             if (e['id'] == '0') {
//                                               _.cardType.value = e['image'];
//                                             } else if (e['id'] == '1') {
//                                               _.cardType.value = e['image'];
//                                             } else if (e['id'] == '2') {
//                                               _.cardType.value = e['image'];
//                                             } else if (e['id'] == '3') {
//                                               _.cardType.value = e['image'];
//                                             }
//                                             _.cardTypeName.value = e['name'];
//                                             print(_.cardTypeName.value);
//                                           },
//                                           child: Row(
//                                             children: [
//                                               SvgPicture.asset(
//                                                 e['image'],
//                                                 width: displayWidth(context) * 0.08,
//                                                 color: kPrimaryDarkColor,
//                                               ),
//                                               SizedBox(
//                                                 width: displayWidth(context) * 0.06,
//                                               ),
//                                               Container(
//                                                 margin: const EdgeInsets.only(left: 10),
//                                                 child: Text(e['name']),
//                                               )
//                                             ],
//                                           ));
//                                     }).toList(),
//                                   )
//                               ),
//                             ))
//                       ],
//                     ),
//                     SizedBox(height: displayHeight(context) * 0.02),
//                     ClipRRect(
//                         borderRadius: BorderRadius.circular(4.0),
//                         child: cardNumberFormField()
//                     ),
//                     SizedBox(height: displayHeight(context) * 0.02),
//                     ClipRRect(
//                         borderRadius: BorderRadius.circular(4.0),
//                         child: cardOwnerFormField()
//                     ),
//                     SizedBox(height: displayHeight(context) * 0.02),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(4.0),
//                           child: Container(
//                               height: displayHeight(context) * 0.1,
//                               width: displayWidth(context) * 0.22,
//                               alignment: Alignment.center,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Expanded(child: cardExpDateFormField()),
//                                 ],
//                               )),
//                         ),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(4.0),
//                           child: SizedBox(
//                             height: displayHeight(context) * 0.1,
//                             width: displayWidth(context) * 0.30,
//                             child: Column(
//                               children: [
//                                 Expanded(child: cardCvvFormField()),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         )
//     );
//   }
//
//
//
//   String cardNumText = "";
//
//
//   TextFormField cardNumberFormField() {
//     return TextFormField(
//       style: TextStyle(
//           color: _.cardNumController!.text == "Card Number"
//               ? Colors.grey
//               : Colors.black
//       ),
//       validator: (value) {
//         if (value!.isEmpty) {
//           return 'Card Number can\'t be empty';
//         } else if (_.cardValidator.validNumber(value.replaceAll(' ', ''))) {
//           if (_.cardValidator
//               .getTypeForIIN(value.replaceAll(' ', ''))
//               .toLowerCase() ==
//               _.selectedCardType.toLowerCase()) {
//             return null;
//           } else {
//             return 'Card Type doesn\'t match the card Details';
//           }
//         } else {
//           return 'Enter Valid Number';
//         }
//       },
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//         LengthLimitingTextInputFormatter(19),
//         CardNumberInputFormatter()
//       ],
//       autofocus: false,
//       focusNode: _.cardNumFocusNode,
//       onChanged: (cardNumText) {
//         setState(() {
//           _.cardNumFocusNode!.requestFocus();
//         });
//       },
//       controller: _.cardNumController!,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         fillColor: Colors.white,
//         border: InputBorder.none,
//         filled: true,
//         hintText: "Card Number",
//         hintStyle: TextStyle(
//           fontSize: displayWidth(context) / 25,
//           color: Colors.grey,
//         ),
//         contentPadding: EdgeInsets.symmetric(
//             vertical: 20.0, horizontal: displayWidth(context) * 0.04),
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
//       ),
//     );
//   }
//
//   TextFormField cardOwnerFormField() {
//     return TextFormField(
//       style: const TextStyle(
//           color: Colors.black
//       ),
//       autofocus: false,
//       focusNode: _.cardOwnerFocusNode!,
//       onChanged: (cardOwnerText) {
//         setState(() {
//           _.cardOwnerFocusNode!.requestFocus();
//         });
//       },
//       controller: _.cardOwnerController!,
//       decoration: InputDecoration(
//         fillColor: Colors.white,
//         border: InputBorder.none,
//         filled: true,
//         hintText: "Card Owner",
//         hintStyle:
//         TextStyle(fontSize: displayWidth(context) / 25, color: Colors.grey),
//         contentPadding: EdgeInsets.symmetric(
//             vertical: 20.0, horizontal: displayWidth(context) * 0.04),
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
//       ),
//     );
//   }
//
//   TextFormField cardCvvFormField() {
//     return TextFormField(
//       style: const TextStyle(
//           color: Colors.black
//       ),
//       validator: (value) {
//         if (value!.isEmpty) {
//           return 'Cvv must not be empty';
//         } else if (_.cardValidator.validCVC(value)) {
//           return null;
//         } else {
//           return 'Enter Valid Cvv';
//         }
//       },
//       controller: _.cardCvvController,
//       decoration: InputDecoration(
//         fillColor: Colors.white,
//         border: InputBorder.none,
//         filled: true,
//         hintText: "CVV",
//         hintStyle:
//         TextStyle(fontSize: displayWidth(context) / 25, color: Colors.grey),
//         contentPadding: EdgeInsets.symmetric(
//             vertical: 20.0, horizontal: displayWidth(context) * 0.04),
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
//       ),
//     );
//   }
//
//   TextFormField cardExpDateFormField() {
//     return TextFormField(
//       style: const TextStyle(
//           color: Colors.black
//       ),
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//         new LengthLimitingTextInputFormatter(4),
//
//       ],
//       autofocus: false,
//       focusNode: _.cardExpFocusNode!,
//       onChanged: (expDate) {
//         setState(() {
//           _.cardExpFocusNode!.requestFocus();
//         });
//       },
//       controller: _.cardExpDateController,
//       decoration: InputDecoration(
//         fillColor: Colors.white,
//         border: InputBorder.none,
//         filled: true,
//         hintText: "mm/yy",
//         hintStyle:
//         TextStyle(fontSize: displayWidth(context) / 25, color: Colors.grey),
//         contentPadding: EdgeInsets.symmetric(
//             vertical: 20.0, horizontal: displayWidth(context) * 0.04),
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
//       ),
//     );
//   }
//
//
//
//
// }