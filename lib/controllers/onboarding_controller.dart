import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/routes/app_pages.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController instance = Get.find();


  RxInt currentPage = 0.obs;
  List<Map<String, String>> onBoardingData = [
    {
      "text": "Let’s connect & get you to a brighter state. \nWhat brings you to Tranquil Life?",
      "image": "assets/images/onboarding_img1.png"
    },
    {
      "text":
      "Tranquil Life creates an all day access to Therapists, \nCounsellors and Psychologists.",
      "image": "assets/images/onboarding_img2.png"
    }
  ];

  RxString userType = ''.obs;
  TextEditingController entryCodeTEC = TextEditingController();


  //Display consultant code entry field
  void _entryCodeBottomSheet(
      BuildContext context, Size size) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(size.width * 0.08),
            height: size.height * 0.42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Consultant Entry \nCode',
                    style: TextStyle(
                        fontSize: size.width * 0.048,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor)),
                SizedBox(height: size.height * 0.04),
                TextFormField(
                    controller: entryCodeTEC,
                    decoration: InputDecoration(
                      labelText: 'Entry Code',
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: "Enter consultant entry code: code411",
                      hintStyle: TextStyle(
                          fontSize: size.width / 25,
                          color: Colors.grey),
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                    )),
                SizedBox(height: size.height * 0.03),
                Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: size.height * 0.06,
                      child: ElevatedButton(
                          onPressed: () {
                            if (entryCodeTEC.text.isNull) {
                              //..
                            } else if (entryCodeTEC.text.trim() != 'code411') {
                              // _showMyDialog();
                            } else {
                              Navigator.pushNamed(context, Routes.REGISTRATION_ONE);
                              userType.value = consultant;
                            }
                          },
                          child: Text('Next',
                              style: TextStyle(
                                  fontSize: size.width * 0.040))),
                    ))
              ],
            ),
          );
        });
  }
}