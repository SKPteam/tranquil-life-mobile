// ignore_for_file: prefer__literals_to_create_immutables, prefer__ructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, sized_box_for_whitespace, unnecessary_import

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/main.dart';
import 'package:tranquil_life/pages/wallet/add_new_card.dart';
import 'package:tranquil_life/pages/wallet/widgets/payment_options.dart';
import 'package:tranquil_life/pages/wallet/widgets/stack_wallet.dart';
import 'package:tranquil_life/pages/wallet/widgets/top_up_history.dart';
import 'package:tranquil_life/pages/webview/webview.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WalletView extends StatefulWidget {
  final void Function(int index) reloadWalletPage;

  Size size = MediaQuery.of(Get.context!).size;


  WalletView({Key? key, required this.reloadWalletPage}) : super(key: key);

  @override
  _WalletViewState createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView>
    with SingleTickerProviderStateMixin {
  void implementAnimation() async {
    Size size = MediaQuery.of(Get.context!).size;

    walletController.controller =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    walletController.animationaw = Tween<double>(begin: 20, end: 0).animate(walletController.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object???s value.
          });
        }
      });
    walletController.animationah = Tween<double>(begin: -20, end: 0).animate(walletController.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object???s value.
          });
        }
      });
    walletController.animationbh = Tween<double>(begin: -70, end: 0).animate(walletController.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object???s value.
          });
        }
      });

    walletController.fadeanimationOp = Tween<double>(begin: 0.4, end: 0).animate(walletController.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object???s value.
          });
        }
      });

    walletController.numberAnim = Tween<double>(begin: 0, end: walletController.num).animate(
        CurvedAnimation(parent: walletController.controller, curve: Curves.decelerate));
    print(num);
    walletController.zerosOfBalance = walletController.getZeros(walletController.num.toInt());
    walletController.animationbw = Tween<double>(
            begin: walletController.textSize(
                        '\$$walletController.zerosOfBalance.00',
                        TextStyle(
                            fontSize: 42,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))
                    .width -
                size.width -
                4,
            end: 0)
        .animate(walletController.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object???s value.
          });
        }
      });
    //walletController.dataLoaded.value = true;

    await Future.delayed(Duration(seconds: 1));
    walletController.controller.forward();
  }

  final String currency = FlutterwaveCurrency.NGN;
  final String txref = "My_unique_transaction_reference_123";


  @override
  void initState() {
    super.initState();
    // print(
    //     "NUM of consultations: ${DashboardController.to.myTotalConsultations!.value}");

    implementAnimation();

    walletController.getCardDetails();
  }

  void reloadPageWalletPage() {
    walletController.cardStackLoaded.value = false;
    walletController.getCardDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      responsiveBuilder: (context, size)
      => sharedPreferences!.getString("userType")
          .toString() == client
          ?
      Container(
        height: size.height,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder(
              valueListenable: walletController.cardStackLoaded,
              builder: (context, bool? stackLoaded, child) =>
              stackLoaded!
                  ? WalletCardStack(
                cardStack: walletController.cardStack.value,
              )
                  : Center(
                child: CircularProgressIndicator(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                bool? result = await Get.to(
                      () => AddNewCard(
                    reloadWalletPage: widget.reloadWalletPage,
                  ),
                  //to make screen full dialog
                  fullscreenDialog: true,
                  //to provide animation
                  transition: Transition.zoom,
                  //duration for transition animation
                  //duration: Duration(milliseconds: 2000),
                  //Curve Animation
                  curve: Curves.bounceInOut,
                );

                if (result != null && result) {
                  print('Executing Function $result');
                  reloadPageWalletPage();
                }

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add,
                  ),
                  SizedBox(width: 8),
                  Text("Add new card",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Available balance",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    SizedBox(
                        child: Text(
                          "50000",
                          //$${double.parse(Get.find<DashboardController>().balance!.value.toString())}
                          style: TextStyle(
                            fontSize: 28,
                            color: kPrimaryDarkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.022,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Staff discount",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    SizedBox(
                        child: Text(
                          '${walletController.loaded.isFalse ? "" : walletController.discountExists.isTrue ? walletController.discount!.value : 0}%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.022,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Top up",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius:
                        BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(3, 6),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () async{

                          await Get.bottomSheet(
                              PaymentOptions()
                          );
                        },
                        child: SizedBox(
                          width: 46,
                          height: 46,
                          child: Icon(
                            Icons.arrow_upward,
                            color: kPrimaryColor,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                GestureDetector(
                  child: Container(
                    width: size.width * 0.6,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 2, color: kPrimaryColor),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'View transactions',
                          style: TextStyle(
                              fontSize: 18),
                        ),
                        Icon(
                            Icons.keyboard_arrow_down_outlined),
                      ],
                    ),
                  ),
                  onTap: (){
                    Get.bottomSheet(
                      TopUpHistoryModalSheet(),
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black26,
                      enableDrag: true,
                    );
                  },
                ),
              ],
            )
          ],
        ),
      )
          :
      SingleChildScrollView(
        child: Container(
          height: size.height,
          padding: EdgeInsets.all(20),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.2,
                    ),
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(walletController.animationaw.value,
                                walletController.animationah.value),
                            child: Text(
                              "TOTAL EARNED",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: kPrimaryDarkColor),
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                              child: FittedBox(
                                child: Transform.translate(
                                  offset: Offset(walletController.animationbw.value,
                                      walletController.animationbh.value),
                                  child: AnimatedBuilder(
                                    animation: walletController.numberAnim,
                                    builder: (context, child) => Text(
                                      "\$" +
                                          (walletController.numberAnim.value == 0
                                              ? walletController.zerosOfBalance + '.00'
                                              : walletController.numberAnim.value
                                              .toStringAsFixed(2)),
                                      style: TextStyle(
                                          fontSize: 42,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Divider(
                      color: kPrimaryColor,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: size.height * 0.08,
                          child: Center(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Number of consultations \nthis month",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: kPrimaryDarkColor),
                                ),
                                Text(
                                  '15',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: kPrimaryColor,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: size.height * 0.08,
                          child: Center(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Total number of consultations",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: kPrimaryDarkColor),
                                ),
                                Text(
                                  '32',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: kPrimaryColor,
                    ),
                    SizedBox(
                      height: size.height * 0.10,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: size.height * 0.08,
                          child: Center(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Account Number",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: kPrimaryDarkColor),
                                ),
                                Text(
                                  '2223350693',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          height: size.height * 0.08,
                          child: Center(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Bank Name",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: kPrimaryDarkColor),
                                ),
                                Text(
                                  'Access Bank',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.07,
                    ),
                    Container(
                      height: size.height * 0.047,
                      width: size.width * 0.8,
                      child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                          onPressed: (){},
                          child: Text("TRANSACTION HISTORY", style: TextStyle(
                              fontSize: 16,
                              color: kPrimaryDarkColor),)),
                    ),

                  ])
            //     :
            //  Center(
            //   child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }



// void displayPaymentMethods(String top_up_figure) {
//   Get.bottomSheet(Container(
//     decoration:  BoxDecoration(color: Colors.white),
//     padding:  EdgeInsets.all(16.0),
//     child: Wrap(
//       children: [
//          Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text("Select a top-up method"),
//         ),
//         ListTile(
//           title:  Text(
//             'Paystack',
//             style: TextStyle(color: Colors.black),
//           ),
//           onTap: () async {
//             Get.back();
//             print((top_up_figure.substring(0, top_up_figure.length - 4)));
//             var subStr = walletController.uuid.v4();
//             var id = subStr.substring(0, subStr.length - 10);
//
//             //Creating a charge model with a amount, I noticed that, the last 2 digits represent digits after decimal
//             //this charge item will need a payment Card object which is optional
//             Charge charge = Charge()
//               ..amount = int.parse(
//                   top_up_figure.substring(0, top_up_figure.length - 4)) *
//                   100
//             //provide Currency code as per iso 4217 currency codes
//               ..currency = 'NGN'
//             //reference is just a reference string, for description
//               ..reference = walletController.getReference()
//               ..card = PaymentCard(
//                 number: EncryptionHelper
//                     .handleDecryption(walletController.cardModel!.cardNumber),
//                 cvc: EncryptionHelper
//                     .handleDecryption(walletController.cardModel!.cardCVV),
//                 expiryMonth: int.parse(
//                     EncryptionHelper
//                         .handleDecryption(
//                         walletController.cardModel!.cardExpiryDate)
//                         .substring(0, 2)),
//                 expiryYear: int.parse(
//                     EncryptionHelper
//                         .handleDecryption(
//                         walletController.cardModel!.cardExpiryDate)
//                         .substring(
//                         3,
//                         EncryptionHelper
//                             .handleDecryption(
//                             walletController.cardModel!.cardExpiryDate)
//                             .length)),
//               )
//               ..email = auth!.currentUser!.email;
//
//             //checkout is the main function which will open a dialog box the UI for entering the card details
//             //and OTP and other stuff during checkout method and will pay the amount giving a response
//             CheckoutResponse response = await walletController.plugin.checkout(
//               Get.context!,
//               method: CheckoutMethod
//                   .card, // Defaults to CheckoutMethod.selectable
//               charge: charge,
//             );
//
//             if (response.status == true) {
//               transactionsRef!.child(businessProfit).child(id).set({
//                 'id': id,
//                 'amount': double.parse(top_up_figure),
//                 'referenceNumber': walletController.getReference(),
//                 'timestamp': DateTime.now().millisecondsSinceEpoch,
//                 'uid': auth!.currentUser!.uid,
//                 'type': 'topUp'
//               }).then((value) {
//                 displaySnackBar("Payment successful ????!", context);
//               }).catchError((e) {
//                 print('Error: ${e.toString()}');
//               });
//             }
//           },
//         ),
//         ListTile(
//           title:  Text(
//             'Paypal',
//             style: TextStyle(color: Colors.black),
//           ),
//           onTap: () => {
//             //TODO: put in Paypal payment method
//           },
//         ),
//         ListTile(
//           title:  Text(
//             'Bitcoin',
//             style: TextStyle(color: Colors.black),
//           ),
//           onTap: () => {
//             //TODO: put in coinbase payment method
//           },
//         ),
//         ListTile(
//           dense: true,
//           visualDensity: VisualDensity.compact,
//           contentPadding: EdgeInsets.zero,
//           title: GooglePayButton(
//             paymentConfigurationAsset:
//             '/payment_jsons/default_google_pay.json',
//             paymentItems:  [
//               PaymentItem(
//                 label: 'Total',
//                 amount: '99.99',
//                 status: PaymentItemStatus.final_price,
//               )
//             ],
//             style: GooglePayButtonStyle.black,
//             type: GooglePayButtonType.pay,
//             margin:  EdgeInsets.only(top: 15.0),
//             onPaymentResult: PaymentHelpers().payUsingGoogle,
//             loadingIndicator:  Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         ),
//         ListTile(
//           dense: true,
//           visualDensity: VisualDensity.compact,
//           contentPadding: EdgeInsets.zero,
//           title: ApplePayButton(
//             paymentConfigurationAsset:
//             '/payment_jsons/default_apple_pay.json',
//             paymentItems:  [
//               PaymentItem(
//                 label: 'Total',
//                 amount: '99.99',
//                 status: PaymentItemStatus.final_price,
//               )
//             ],
//             style: ApplePayButtonStyle.black,
//             type: ApplePayButtonType.buy,
//             margin:  EdgeInsets.only(top: 15.0),
//             onPaymentResult: PaymentHelpers().payUsingApple,
//             loadingIndicator:  Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         )
//       ],
//     ),
//   ));
// }

  bool checkPaymentIsSuccessful(final ChargeResponse response, String amount, ) {
    return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data!.currency == this.currency &&
        response.data!.amount == amount &&
        response.data!.txRef == this.txref;
  }
}