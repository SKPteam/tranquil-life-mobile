// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:tranquil_app/app/getx_controllers/dashboard_controller.dart';
import 'package:tranquil_app/app/getx_controllers/wallet_controller.dart';
import 'package:tranquil_app/app/helperControllers/encryption_helper.dart';
import 'package:tranquil_app/app/helperControllers/paymentHelpers.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/utils/snackbar.dart';
import '../../../main.dart';
import 'add_new_card.dart';
import 'components/stackWalletWidget.dart';
import 'components/top_up_history_widget.dart';

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
        body: Get.find<DashboardController>().userType!.value == "client"
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
                            print('Executing Function $result ');
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
                                const Text("Available balance"),
                                SizedBox(
                                    child: Text(
                                  "\$${double.parse(Get.find<DashboardController>().balance!.value.toString())}",
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
                                              displayPaymentMethods(
                                                  _.figure.value);
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
                                    const TopUpHistoryModalSheet(),
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
                                child: Text(
                                  'View transactions',
                                  style: TextStyle(
                                      fontSize:
                                      displayWidth(context) / 28),
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
                                const Text(
                                  "Number of consultations \nthis month",
                                  style: TextStyle(
                                      fontSize: 16, color: kPrimaryDarkColor),
                                ),
                                Text(
                                  '0',
                                  style: const TextStyle(
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

  var topUpTemplate = '''
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta name="x-apple-disable-message-reformatting">
    <title></title>
    <style>
    table, td, div, h1, p {
      font-family: Arial, sans-serif;
    }
    @media screen and (max-width: 530px) {
      .unsub {
        display: block;
        padding: 8px;
        margin-top: 14px;
        border-radius: 6px;
        background-color: #555555;
        text-decoration: none !important;
        font-weight: bold;
      }
      .col-lge {
        max-width: 100% !important;
      }
    }
    @media screen and (min-width: 531px) {
      .col-sml {
        max-width: 27% !important;
      }
      .col-lge {
        max-width: 73% !important;
      }
    }
  </style>
</head>
<body style="margin:0;padding:0;word-spacing:normal;background-color:#939297;">
<div role="article" aria-roledescription="email" lang="en" style="text-size-adjust:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#939297;">
    <table role="presentation" style="width:100%;border:none;border-spacing:0;">
        <tr>
            <td align="center" style="padding:0;">
                <table role="presentation" style="width:94%;max-width:600px;border:none;border-spacing:0;text-align:left;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
                    <tr>
                        <td style="padding:40px 30px 30px 30px;text-align:center;font-size:24px;font-weight:bold;">
                            <a href="http://www.example.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/logo.png" width="165" alt="Tranquil Life" style="width:80%;max-width:165px;height:auto;border:none;text-decoration:none;color:#ffffff;"></a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:30px;background-color:#ffffff;">
                            <h1 style="margin-top:0;margin-bottom:16px;font-size:26px;line-height:32px;font-weight:bold;letter-spacing:-0.02em;">Hello ${Get.find<DashboardController>().username!.value}!</h1>
                            <p style="margin:0;">You just topped up your <strong>Tranquil Life</strong> account balance with ${Get.find<WalletController>().amountPaid}.
                                New balance: ${Get.find<DashboardController>().balance!.value}</p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:0;font-size:24px;line-height:28px;font-weight:bold;">
                            <a href="http://www.example.com/" style="text-decoration:none;">
                                <img src="https://firebasestorage.googleapis.com/v0/b/mindscapeproject-ef43d.appspot.com/o/emailTemplates%2Ftop-up.png?alt=media&token=e4daad9f-0185-4a7e-a22b-436e439d12b0"
                                     width="600" alt="" style="width:100%;height:auto;display:block;border:none;text-decoration:none;color:#363636;">
                            </a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:35px 30px 11px 30px;font-size:0;background-color:#ffffff;border-bottom:1px solid #f0f0f5;border-color:rgba(201,201,207,.35);">
                            <div style="text-align:center">
                                <div class="col-lge" style="display:inline-block;width:100%;max-width:395px;vertical-align:top;padding-bottom:20px;font-family:Arial,sans-serif;font-size:16px;line-height:22px;color:#363636;">
                                    <p style="margin:0;">
                                        <a href="https://example.com/" style="background: #4CAF50; text-decoration: none; padding: 10px 25px; color: #ffffff; border-radius: 4px; display:inline-block; mso-padding-alt:0;text-underline-color:#ff3884">
                              <span style="mso-text-raise:10pt;font-weight:bold;">Tranquil Life
                              </span>
                                        </a>
                                    </p>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:30px;text-align:center;font-size:12px;background-color:#404040;color:#cccccc;">
                            <p style="margin:0 0 8px 0;">
                                <a href="http://www.facebook.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/facebook_1.png" width="40" height="40" alt="f" style="display:inline-block;color:#cccccc;"></a>
                                <a href="http://www.twitter.com/" style="text-decoration:none;"><img src="https://assets.codepen.io/210284/twitter_1.png" width="40" height="40" alt="t" style="display:inline-block;color:#cccccc;"></a></p>
                            <p style="margin:0;font-size:14px;line-height:20px;">&reg; Skiplab Innovation, Nigeria 2021<br><a class="unsub" href="http://www.example.com/" style="color:#cccccc;text-decoration:underline;">Unsubscribe instantly</a></p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
''';

  void displayPaymentMethods(String top_up_figure) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Select a top-up method"),
          ),
          ListTile(
            title: const Text(
              'Paystack',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () async {
              Get.back();
              print((top_up_figure.substring(0, top_up_figure.length - 4)));
              var subStr = _.uuid.v4();
              var id = subStr.substring(0, subStr.length - 10);

              //Creating a charge model with a amount, I noticed that, the last 2 digits represent digits after decimal
              //this charge item will need a payment Card object which is optional
              Charge charge = Charge()
                ..amount = int.parse(
                        top_up_figure.substring(0, top_up_figure.length - 4)) *
                    100
                //provide Currency code as per iso 4217 currency codes
                ..currency = 'NGN'
                //reference is just a reference string, for description
                ..reference = _.getReference()
                ..card = PaymentCard(
                  number: EncryptionHelper
                      .handleDecryption(_.cardModel!.cardNumber),
                  cvc: EncryptionHelper
                      .handleDecryption(_.cardModel!.cardCVV),
                  expiryMonth: int.parse(
                      EncryptionHelper
                          .handleDecryption(
                          _.cardModel!.cardExpiryDate)
                          .substring(0, 2)),
                  expiryYear: int.parse(
                      EncryptionHelper
                          .handleDecryption(
                          _.cardModel!.cardExpiryDate)
                      .substring(
                          3,
                          EncryptionHelper
                              .handleDecryption(
                              _.cardModel!.cardExpiryDate)
                              .length)),
                )
                ..email = auth!.currentUser!.email;

              //checkout is the main function which will open a dialog box the UI for entering the card details
              //and OTP and other stuff during checkout method and will pay the amount giving a response
              CheckoutResponse response = await _.plugin.checkout(
                Get.context!,
                method: CheckoutMethod
                    .card, // Defaults to CheckoutMethod.selectable
                charge: charge,
              );

              if (response.status == true) {
                transactionsRef!.child(businessProfit).child(id).set({
                  'id': id,
                  'amount': double.parse(top_up_figure),
                  'referenceNumber': _.getReference(),
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'uid': auth!.currentUser!.uid,
                  'type': 'topUp'
                }).then((value) {
                  displaySnackBar("Payment successful 😀!", context);
                }).catchError((e) {
                  print('Error: ${e.toString()}');
                });
              }
            },
          ),
          ListTile(
            title: const Text(
              'Paypal',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () => {
              //TODO: put in Paypal payment method
            },
          ),
          ListTile(
            title: const Text(
              'Bitcoin',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () => {
              //TODO: put in coinbase payment method
            },
          ),
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            title: GooglePayButton(
              paymentConfigurationAsset:
                  '/payment_jsons/default_google_pay.json',
              paymentItems: const [
                PaymentItem(
                  label: 'Total',
                  amount: '99.99',
                  status: PaymentItemStatus.final_price,
                )
              ],
              style: GooglePayButtonStyle.black,
              type: GooglePayButtonType.pay,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: PaymentHelpers().payUsingGoogle,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            title: ApplePayButton(
              paymentConfigurationAsset:
                  '/payment_jsons/default_apple_pay.json',
              paymentItems: const [
                PaymentItem(
                  label: 'Total',
                  amount: '99.99',
                  status: PaymentItemStatus.final_price,
                )
              ],
              style: ApplePayButtonStyle.black,
              type: ApplePayButtonType.buy,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: PaymentHelpers().payUsingApple,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
