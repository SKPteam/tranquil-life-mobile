// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/dashboard_controller.dart';
import 'package:tranquil_life/controllers/wallet_controller.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/pages/wallet/widgets/stack_wallet.dart';
import 'package:tranquil_life/pages/wallet/widgets/top_up_history.dart';
import 'package:tranquil_life/routes/app_pages.dart';

class WalletView extends StatefulWidget {
  final void Function(int index) reloadWalletPage;

  const WalletView({Key? key, required this.reloadWalletPage})
      : super(key: key);

  @override
  _WalletViewState createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView>
    with SingleTickerProviderStateMixin {
  final WalletController _ = Get.put(WalletController());

  void implementAnimation() async {
    _.controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _.animationaw = Tween<double>(begin: 20, end: 0).animate(_.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object’s value.
          });
        }
      });
    _.animationah = Tween<double>(begin: -20, end: 0).animate(_.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object’s value.
          });
        }
      });
    _.animationbh = Tween<double>(begin: -70, end: 0).animate(_.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object’s value.
          });
        }
      });

    _.fadeanimationOp = Tween<double>(begin: 0.4, end: 0).animate(_.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object’s value.
          });
        }
      });

    _.numberAnim = Tween<double>(begin: 0, end: _.num).animate(
        CurvedAnimation(parent: _.controller, curve: Curves.decelerate));
    print(num);
    _.zerosOfBalance = _.getZeros(_.num.toInt());
    _.animationbw = Tween<double>(
        begin: _
            .textSize(
            '\$$_.zerosOfBalance.00',
            const TextStyle(
                fontSize: 42, color: Colors.black, fontWeight: FontWeight.bold
            ))
            .width -
            displayWidth(context) -
            4,
        end: 0)
        .animate(_.controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            // The state that has changed here is the animation object’s value.
          });
        }
      });
    //_.dataLoaded.value = true;

    await Future.delayed(const Duration(seconds: 1));
    _.controller.forward();
  }

  @override
  void initState() {
    super.initState();

    _.getCardDetails();

    // print(
    //     "NUM of consultations: ${DashboardController.to.myTotalConsultations!.value}");

    implementAnimation();
  }

  void reloadPageWalletPage() {
    _.cardStackLoaded.value = false;
    _.getCardDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        backgroundColor: kLightBackgroundColor,
        //dependency injection to check userType
        body: Get.find<DashboardController>().userType.value == "client"
            ? SafeArea(
          child: Container(
            height: displayHeight(context),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ValueListenableBuilder(
                  valueListenable: _.cardStackLoaded,
                  builder: (context, bool? stackLoaded, child) =>
                  stackLoaded!
                      ? WalletCardStack(
                    cardStack: _.cardStack,
                  )
                      : const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){Get.toNamed(Routes.ADD_NEW_CARD);},
                  child: Center(child: Text("Added New Card")),),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Available balance"),
                          SizedBox(
                              child: Text(
                                "50000",
                                //$${double.parse(Get.find<DashboardController>().balance!.value.toString())}
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: kPrimaryDarkColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.022,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Staff discount"),
                          SizedBox(
                              child: Text(
                                '${_.loaded.isFalse ? "" : _.discountExists.isTrue ? _.discount!.value : 0}%',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.022,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Top up"),
                          Container(
                            margin: EdgeInsets.only(
                                right: displayWidth(context) * 0.04),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10.0),
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
                              onTap: () {
                                //_.getCurrencies();

                                Get.bottomSheet(Container(
                                  decoration:
                                  const BoxDecoration(color: Colors.white),
                                  height: displayHeight(context) * 0.5,
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 16.0, 16.0, 0),
                                  child: ListView.builder(
                                      itemCount: top_up_figures.length,
                                      itemBuilder: (BuildContext context,
                                          int index) {
                                        return ListTile(
                                          title: InkWell(
                                            onTap: () {
                                              //print("CURRENCY SYMBOL ${_.format.currencyName}"); // $
                                              // print("${_.format.currencySymbol}"+"${top_up_figures[index]}");
                                              Get.back();
                                              _.figure.value = (_.rate! *
                                                  double.parse(
                                                      top_up_figures[
                                                      index]
                                                          .toString()))
                                                  .toStringAsFixed(3);
                                              // displayPaymentMethods(
                                              //     _.figure.value);
                                            },
                                            child: Text(
                                              "\$${double.parse(top_up_figures[index].toString())}",
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ));
                              },
                              child: SizedBox(
                                  width: displayWidth(context) * 0.10,
                                  height: displayWidth(context) * 0.10,
                                  child: Icon(
                                    Icons.arrow_upward,
                                    size: displayWidth(context) * 0.06,
                                    color: kPrimaryColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.08,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  //showing bottom modal sheet containing the history of transactions
                                  Get.bottomSheet(
                                    TopUpHistoryModalSheet(),
                                    backgroundColor: Colors.transparent,
                                    barrierColor: Colors.black26,
                                    enableDrag: true,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 20),
                                  primary: kPrimaryColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                                  children: [
                                    Text(
                                      'View transactions',
                                      style: TextStyle(
                                          fontSize:
                                          displayWidth(context) / 28),
                                    ),
                                    Icon(Icons.keyboard_arrow_up_outlined),
                                  ],
                                )),
                          )),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
            : SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: displayHeight(context),
                padding: const EdgeInsets.all(20),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: displayHeight(context) * 0.2,
                          ),
                          Container(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform.translate(
                                  offset:
                                  Offset(_.animationaw.value, _.animationah.value),
                                  child: const Text(
                                    "TOTAL EARNED",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: kPrimaryDarkColor),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                    child: FittedBox(
                                      child: Transform.translate(
                                        offset: Offset(
                                            _.animationbw.value, _.animationbh.value),
                                        child: AnimatedBuilder(
                                          animation: _.numberAnim,
                                          builder: (context, child) => Text(
                                            "\$" +
                                                (_.numberAnim.value == 0
                                                    ? _.zerosOfBalance + '.00'
                                                    : _.numberAnim.value
                                                    .toStringAsFixed(2)),
                                            style: const TextStyle(
                                                fontSize: 42, color: Colors.black, fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: kPrimaryColor,
                          ),
                          Stack(
                            children: [
                              Container(
                                height: displayHeight(context) * 0.08,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Number of consultations \nthis month",
                                        style: TextStyle(
                                            fontSize: 16, color: kPrimaryDarkColor),
                                      ),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]
                    )
                  //     :
                  // const Center(
                  //   child: CircularProgressIndicator(),
                ),
              ),
            )
        ),
      ),
    );
  }



  // void displayPaymentMethods(String top_up_figure) {
  //   Get.bottomSheet(Container(
  //     decoration: const BoxDecoration(color: Colors.white),
  //     padding: const EdgeInsets.all(16.0),
  //     child: Wrap(
  //       children: [
  //         const Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Select a top-up method"),
  //         ),
  //         ListTile(
  //           title: const Text(
  //             'Paystack',
  //             style: TextStyle(color: Colors.black),
  //           ),
  //           onTap: () async {
  //             Get.back();
  //             print((top_up_figure.substring(0, top_up_figure.length - 4)));
  //             var subStr = _.uuid.v4();
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
  //               ..reference = _.getReference()
  //               ..card = PaymentCard(
  //                 number: EncryptionHelper
  //                     .handleDecryption(_.cardModel!.cardNumber),
  //                 cvc: EncryptionHelper
  //                     .handleDecryption(_.cardModel!.cardCVV),
  //                 expiryMonth: int.parse(
  //                     EncryptionHelper
  //                         .handleDecryption(
  //                         _.cardModel!.cardExpiryDate)
  //                         .substring(0, 2)),
  //                 expiryYear: int.parse(
  //                     EncryptionHelper
  //                         .handleDecryption(
  //                         _.cardModel!.cardExpiryDate)
  //                         .substring(
  //                         3,
  //                         EncryptionHelper
  //                             .handleDecryption(
  //                             _.cardModel!.cardExpiryDate)
  //                             .length)),
  //               )
  //               ..email = auth!.currentUser!.email;
  //
  //             //checkout is the main function which will open a dialog box the UI for entering the card details
  //             //and OTP and other stuff during checkout method and will pay the amount giving a response
  //             CheckoutResponse response = await _.plugin.checkout(
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
  //                 'referenceNumber': _.getReference(),
  //                 'timestamp': DateTime.now().millisecondsSinceEpoch,
  //                 'uid': auth!.currentUser!.uid,
  //                 'type': 'topUp'
  //               }).then((value) {
  //                 displaySnackBar("Payment successful 😀!", context);
  //               }).catchError((e) {
  //                 print('Error: ${e.toString()}');
  //               });
  //             }
  //           },
  //         ),
  //         ListTile(
  //           title: const Text(
  //             'Paypal',
  //             style: TextStyle(color: Colors.black),
  //           ),
  //           onTap: () => {
  //             //TODO: put in Paypal payment method
  //           },
  //         ),
  //         ListTile(
  //           title: const Text(
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
  //             paymentItems: const [
  //               PaymentItem(
  //                 label: 'Total',
  //                 amount: '99.99',
  //                 status: PaymentItemStatus.final_price,
  //               )
  //             ],
  //             style: GooglePayButtonStyle.black,
  //             type: GooglePayButtonType.pay,
  //             margin: const EdgeInsets.only(top: 15.0),
  //             onPaymentResult: PaymentHelpers().payUsingGoogle,
  //             loadingIndicator: const Center(
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
  //             paymentItems: const [
  //               PaymentItem(
  //                 label: 'Total',
  //                 amount: '99.99',
  //                 status: PaymentItemStatus.final_price,
  //               )
  //             ],
  //             style: ApplePayButtonStyle.black,
  //             type: ApplePayButtonType.buy,
  //             margin: const EdgeInsets.only(top: 15.0),
  //             onPaymentResult: PaymentHelpers().payUsingApple,
  //             loadingIndicator: const Center(
  //               child: CircularProgressIndicator(),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   ));
  // }
}