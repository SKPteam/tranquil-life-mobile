import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tranquil_app/app/getx_controllers/on_boarding_two_controller.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';
import 'package:tranquil_app/app/routes/app_pages.dart';


class OnBoardingTwoView extends GetView<OnBoardingTwoController> {

  final OnBoardingTwoController _ = Get.put(OnBoardingTwoController());

  OnBoardingTwoView({Key? key}) : super(key: key);

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wrong Code'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Request for the consultant entry code from Admin'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Request'),
              onPressed: () {
                Navigator.of(context).pop();
                _showEmailFieldDialog();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEmailFieldDialog() async {
    return showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'email address'),
              ),
            ),
            actions: [
              TextButton(
                child: Text('Request'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //Display consultant code entry field
  void _showModalBottomSheet(
      BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(displayWidth(context) * 0.08),
            height: displayHeight(context) * 0.42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Consultant Entry \nCode',
                    style: TextStyle(
                        fontSize: displayWidth(context) * 0.048,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor)),
                SizedBox(height: displayHeight(context) * 0.04),
                TextFormField(
                    controller: _.entryCodeTEC,
                    decoration: InputDecoration(
                      labelText: 'Entry Code',
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: "Enter consultant entry code: code411",
                      hintStyle: TextStyle(
                          fontSize: displayWidth(context) / 25,
                          color: Colors.grey),
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                    )),
                SizedBox(height: displayHeight(context) * 0.04),
                Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: displayHeight(context) * 0.06,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_.entryCodeTEC.text.isNull) {
                              //..
                            } else if (_.entryCodeTEC.text.trim() != 'code411') {
                              _showMyDialog();
                            } else {
                              Navigator.pushNamed(context, Routes.REGISTRATION_ONE);
                              _.userType.value = consultant;
                            }
                          },
                          child: Text('Next',
                              style: TextStyle(
                                  fontSize: displayWidth(context) * 0.040))),
                    ))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_img1.png'),
                    colorFilter:
                    ColorFilter.mode(Color(0xff777474), BlendMode.multiply),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                        child: Container(
                            width: displayWidth(context) * 0.5,
                            height: displayHeight(context) * 0.5,
                            child: Image.asset("assets/images/concept1_logo.png")
                        )
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: displayWidth(context) * 0.12),
                      child: Column(
                        children: [
                          ///Client Option Button
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, Routes.REGISTRATION_ONE);
                                    _.userType.value = client;
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 20),
                                      primary: kPrimaryColor),
                                  child: Text('Client',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: displayWidth(context) *
                                              0.045)))),
                          const SizedBox(height: 16),

                          ///Consultant Option Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  _showModalBottomSheet(Get.context!);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 20),
                                    primary: Colors.white),
                                child: Text(
                                  'Consultant',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize:
                                      displayWidth(context) * 0.045),
                                )),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(context, Routes.SIGN_IN, (route) => false);
                                      //Get.offNamedUntil(Routes.SIGN_IN, (route) => false);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Already have an account? ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              displayWidth(context) / 30),
                                        ),
                                        Text(
                                          'Login',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: kSecondaryColor,
                                              fontSize:
                                              displayWidth(context) / 30),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
