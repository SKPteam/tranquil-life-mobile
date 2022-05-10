// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/registration_four_controller.dart';
import 'package:tranquil_life/controllers/registration_one_controller.dart';
import 'package:tranquil_life/controllers/registration_two_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_text.dart';

import '../../widgets/custom_snackbar.dart';



class RegistrationTwoView extends StatefulWidget {
  const RegistrationTwoView({Key? key}) : super(key: key);

  @override
  State<RegistrationTwoView> createState() => _RegistrationTwoViewState();
}

class _RegistrationTwoViewState extends State<RegistrationTwoView> {
  final controller = Get.put(RegistrationTwoController());
  final RegistrationOneController regOneController = Get.put(RegistrationOneController());
  final RegistrationFourController regFourController = Get.put(RegistrationFourController());
  final _formKey = GlobalKey <FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // _signIn() async {
  //   FocusScope.of(context).unfocus();
  //   if(_formKeySignIn.currentState!.validate()){
  //     _formKeySignIn.currentState!.save();
  //     Get.toNamed(Routes.REGISTRATION_THREE);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
        responsiveBuilder: (context, size) =>
            Obx(() =>
                Scaffold(
                  key: scaffoldKey,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      "Sign Up",
                      style: TextStyle(color: Color(0xffBEBEBE)),
                    ),
                  ),
                  body: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                          onBoardingController.userType.value == client
                              ? AssetImage('assets/images/bg_img1.png')
                              : AssetImage('assets/images/bg_img2.png'),
                          colorFilter: ColorFilter.mode(
                              Color(0xff777474), BlendMode.multiply),
                          fit: BoxFit.cover),
                    ),
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.1),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: size.height * 0.08), // 4%
                                Text("Complete Profile",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      height: size.height * 0.0015,
                                    )),
                                SizedBox(height: size.height * 0.02),
                                Text("Complete your details",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xffDDDDDD),
                                        fontSize: 18)),
                                SizedBox(height: size.height * 0.08),
                                Form(
                                  key: _formKey,
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child: buildFirstNameFormField(size),
                                        ),
                                        SizedBox(height: size.height * 0.020),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          child: buildLastNameFormField(size),
                                        ),
                                        SizedBox(height: size.height * 0.020),
                                        userTypeWidgets(size)
                                      ],
                                    ))
                              ],
                            ),
                            //end
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
    );
  }

  Widget userTypeWidgets(Size size){
    if(onBoardingController.userType.value == client){
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: buildUserNameFormField(size),
          ),
          SizedBox(
              height: size.height * 0.02),
          ClipRRect(
            borderRadius: BorderRadius.circular(
                4),
            child: buildDOBFormField(size),
          ),
          SizedBox(height: size.height * 0.03),
          SizedBox(
            width: size.width * 0.6,
            height: 60,
            child: ElevatedButton(
                onPressed: () async{
                  await registrationTwoController
                      .checkForUsername()
                      .then((value) {
                    if (kUserNameExists ==
                        value) {
                      registrationTwoController
                          .usernameExists.value =
                      true;
                    } else {
                      registrationTwoController
                          .usernameExists.value =
                      false;
                    }
                  }).onError((error, stackTrace) {
                    print(
                        "CHECK FOR USERNAME: ERROR: $error");
                  });


                  if (registrationTwoController
                      .firstNameTextEditingController
                      .text.isEmpty) {
                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: kFirstNameNullError,
                        backgroundColor: active);
                  }
                  else
                  if (registrationTwoController
                      .lastNameTextEditingController
                      .text.isEmpty) {
                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: kLastNameNullError,
                        backgroundColor: active);
                  }
                  else
                  if (registrationTwoController
                      .userNameTextEditingController
                      .text.isEmpty) {
                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: kUserNameNullError,
                        backgroundColor: active);
                  }
                  else
                  if (registrationTwoController
                      .usernameExists.value) {
                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: kUserNameExists,
                        backgroundColor: active);
                  }
                  else
                  if (registrationTwoController
                      .age.value < 16) {
                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: kTooYoungError,
                        backgroundColor: active);
                  }
                  else {
                    //Get.toNamed(Routes.REGISTRATION_THREE);
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 20),
                    primary: kPrimaryColor),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )),
          ),
          SizedBox(height: size.height * 0.040),
        ],
      );
    }
    else{
      return Column(
        children: [
          SizedBox(height: size.height * 0.002),
          ClipRRect(
            borderRadius: BorderRadius.circular(
                4),
            child: buildDOBFormField(size),
          ),
          SizedBox(height: size.height * 0.020),
          ClipRRect(
            borderRadius: BorderRadius.circular(
                4),
            child: identityDocField(size),
          ),
          SizedBox(height: size.height * 0.020),
          ClipRRect(
            borderRadius: BorderRadius.circular(
                4),
            child: cvDocField(size),
          ),
          SizedBox(height: size.height * 0.03),
          SizedBox(
            width: size.width * 0.6,
            height: 60,
            child: ElevatedButton(
                onPressed: () async{

                  if (registrationTwoController
                      .firstNameTextEditingController
                      .text.isEmpty) {

                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: kFirstNameNullError,
                        backgroundColor: active);
                  }
                  else if (registrationTwoController
                      .lastNameTextEditingController
                      .text.isEmpty) {

                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: kLastNameNullError,
                        backgroundColor: active);
                  }
                  else if (registrationTwoController
                      .passportPath
                      .value.isEmpty) {

                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: "Passport or Driver's license is required",
                        backgroundColor: active);
                  }
                  else if (registrationTwoController
                      .cvPath.value.isEmpty) {
                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: "Resumé is required",
                        backgroundColor: active);
                  }
                  else if (registrationTwoController
                      .age.value < 16) {

                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: "Error",
                        message: kTooYoungError,
                        backgroundColor: active);
                  }
                  else {
                    regFourController.saveFilesToFbStorage();

                    //Get.toNamed(Routes.REGISTRATION_THREE);
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 20),
                    primary: kPrimaryColor),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )),
          ),
          SizedBox(height: size.height * 0.040),
        ],
      );
    }
  }


  TextFormField buildFirstNameFormField(Size size) {
    return TextFormField(
      //validator: (value) => (value!.isEmpty? "Please enter your first name" : null),
      // onChanged: (value){
      //   regOneController.firstname = value;
      // },
      controller: registrationTwoController.firstNameTextEditingController,
      style: TextStyle(
          fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "first name",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField(Size size) {
    return TextFormField(
      //validator: (value) => (value!.isEmpty? "Please enter your last name" : null),
      //onChanged: (value){regOneController.lastname = value;},
      controller: registrationTwoController.lastNameTextEditingController,
      style: TextStyle(
          fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "last name",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildUserNameFormField(Size size) {
    return TextFormField(
      //validator: (value) => (value!.isEmpty? "Please enter your username" : null),
      // onChanged: (value){
      //   regOneController.username = value;
      // },
      controller: registrationTwoController.userNameTextEditingController,
      style: TextStyle(
          fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "username",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: registrationTwoController.currentDate,
        firstDate: DateTime(1970),
        lastDate: registrationTwoController.currentDate);
    if (pickedDate != null && pickedDate != registrationTwoController.currentDate) {
      setState(() {
        registrationTwoController.day = pickedDate.day;
        registrationTwoController.month = pickedDate.month;
        registrationTwoController.year = pickedDate.year;
        registrationTwoController.day = pickedDate.day;
        registrationTwoController.age.value = registrationTwoController.currentDate.year - registrationTwoController.year!;
      });
    }

    if (registrationTwoController.month! > registrationTwoController.currentDate.month) {
      registrationTwoController.age.value--;
    } else if (registrationTwoController.month! == registrationTwoController.currentDate.month) {
      if (registrationTwoController.day! > registrationTwoController.currentDate.day) {
        registrationTwoController.age.value--;
      }
    }
    String formattedDOB = registrationTwoController.dateFormatter.format(pickedDate!);
    registrationTwoController.dateOfBirth = formattedDOB.toString();
    registrationTwoController.dobTextEditingController.text = registrationTwoController.dateOfBirth ?? '';
  }

  TextFormField buildDOBFormField( Size size) {
    return TextFormField(
      //validator: (value) => (value!.isEmpty? "Please enter your Date of Birth" : null),
      controller: registrationTwoController.dobTextEditingController,
      showCursor: false,
      readOnly: true,
      onTap: () {
        registrationTwoController.selectDate(Get.context!);
      },
      style: TextStyle(
          fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "age",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  Container identityDocField(Size size) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: light,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 11.0, horizontal: size.width * 0.04
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text:
              registrationTwoController.passportPath.value.isEmpty
                  ? "Passport or Driver's License"
                  : (registrationTwoController.passportPath.value.length > 24
                  ? (registrationTwoController.passportPath.value.substring(0, 24) + "..." )
                  : registrationTwoController.passportPath.value),
                size: 18, weight: FontWeight.normal, align: TextAlign.start, key: null, color: Colors.grey,),
              IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: (){
                  setState(() {
                    registrationTwoController.selectImageFromGallery("passport", 0);
                  });
                },
              )
            ],
          ),
        )
    );
  }

  Container cvDocField(Size size) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: light,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 11.0, horizontal: size.width * 0.04
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text:
              registrationTwoController.cvPath.value.isEmpty
                  ? "Upload your resumé"
                  : (registrationTwoController.cvPath.value.length > 24
                  ? (registrationTwoController.cvPath.value.substring(0, 24) + "..." )
                  : registrationTwoController.cvPath.value),
                size: 18,
                weight: FontWeight.normal, align: TextAlign.start, key: null, color: Colors.grey,),
              IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: (){
                  registrationTwoController.selectImageFromGallery("cv", 0);
                },
              )
            ],
          ),
        )
    );
  }
}
