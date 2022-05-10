// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tranquil_life/constants/app_strings.dart';
import 'package:tranquil_life/constants/controllers.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/onboarding_controller.dart';
import 'package:tranquil_life/controllers/registration_four_controller.dart';
import 'package:tranquil_life/controllers/registration_one_controller.dart';
import 'package:tranquil_life/helpers/responsive_safe_area.dart';
import 'package:tranquil_life/routes/app_pages.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';

import '../../constants/app_font.dart';

class RegistrationOneView extends StatefulWidget {
  const RegistrationOneView({Key? key}) : super(key: key);

  @override
  State<RegistrationOneView> createState() => _RegistrationOneViewState();
}

class _RegistrationOneViewState extends State<RegistrationOneView> {
  final OnBoardingController obc = Get.put(OnBoardingController());
  final RegistrationOneController regOneController = Get.put(RegistrationOneController());
  final _formKeySignIn = GlobalKey <FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailValidator = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  _signIn() async {
    FocusScope.of(context).unfocus();
    if(_formKeySignIn.currentState!.validate()){
      _formKeySignIn.currentState!.save();
      Get.toNamed(Routes.REGISTRATION_TWO);
    }
  }

  CountryCodePicker countryCodePicker(Size size) {
    return CountryCodePicker(
      //when the picker is created for first time this is executed, we set the empty countryCode variable to the initial value
      onInit: (_countryCode) {
        regOneController.countryCode = _countryCode.toString();
      },
      flagWidth: size.width / 18,
      initialSelection: 'NG',
      favorite: ['+234', 'NG'],
      onChanged: (_countryCode) {
        registrationOneController.countryCode = _countryCode.toString();
        print("New Country selected: " + regOneController.countryCode.toString());
      },
      // optional. Shows only country name and flag
      showFlag: true,
      showDropDownButton: true,
      showCountryOnly: false,
      // optional. Shows only country name and flag when popup is closed.
      showOnlyCountryWhenClosed: false,
      // optional. aligns the flag and the Text left
      alignLeft: false,
    );
  }

  TextFormField buildEmailFormField(Size size) {
    return TextFormField(
      // onChanged: (value){
      //   regOneController.email = value;
      // },
      style: TextStyle(
          fontSize: 18,
          color: Colors.black
      ),
      controller: registrationOneController.emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        hintText: "email",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
      // validator: (value){
      //   if (value!.isEmpty){
      //     return 'Email form cannot be empty';
      //   } else if (!_emailValidator.hasMatch(value)){
      //     return 'Please, provide a valid email';
      //   } else {
      //     return null;
      //   }
      // },
    );
  }

// Toggles to make password visible

  TextFormField buildPasswordFormField(Size size) {
    return TextFormField(
      // onChanged: (value){
      //   regOneController.password = value;
      // },
      style: TextStyle(
          fontSize: 18,
          color: Colors.black
      ),
      controller: registrationOneController.passwordTextEditingController,
      obscureText: regOneController.obscureText.value,
      decoration: InputDecoration(
        suffix: InkWell(
            onTap: () {
              regOneController.togglePassword();
            },
            child: Icon(regOneController.obscureText.value ? Icons.visibility : Icons.visibility_off)),
        hintText: "password",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: size.width * 0.04),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return 'Please enter password';
      //   }else if (value.length < 8) {
      //     return 'Password must be up to 8 characters';
      //   }
      //   else if (!value.contains(RegExp(r"[A-Z]"))){
      //     return 'Password must contain at least one uppercase';
      //   }
      //   else if (!value.contains(RegExp(r"[a-z]"))){
      //     return 'Password must contain at least one lowercase';
      //   }else if (!value.contains(RegExp(r"[0-9]"))){
      //     return 'Password must contain at least one number';
      //   }
      //   return null;
      // },
    );
  }

  TextFormField buildConformPassFormField(Size size) {
    return TextFormField(
      style: TextStyle(
          fontSize: 18,
          color: Colors.black
      ),
      controller: registrationOneController.confirmPwdTextEditingController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "re-enter your password",
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
        //prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
      // validator: (value){
      //   if (value!.isEmpty) {
      //     return "Please confirm password";
      //   } else if (value != regOneController.passwordTextEditingController.text) {
      //     return "Password do not match";
      //   } else {
      //     return null;
      //   }
      // },
    );
  }
  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
        responsiveBuilder: (context, size)=>
            Obx(() =>
                Scaffold(
                  key: scaffoldKey,
                  //resizeToAvoidBottomPadding: false,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent, elevation: 0,
                    title: Text("Sign Up", style: TextStyle(color: Color(0xffBEBEBE)),),),
                  body: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: onBoardingController.userType.value == client ? AssetImage('assets/images/bg_img1.png') : AssetImage('assets/images/bg_img2.png'),
                            colorFilter: ColorFilter.mode(Color(0xff777474), BlendMode.multiply), fit: BoxFit.cover),),
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.1),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: size.height * 0.08),
                                  // 4%
                                  Text("Register Account",
                                      style: TextStyle(fontSize: 30, color: Colors.white, height: size.height * 0.0015,)),
                                  SizedBox(height: size.height * 0.02),
                                  Text("Complete your details",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xffDDDDDD),
                                          fontSize: 18)),
                                  SizedBox(height: size.height * 0.08),
                                  Form(
                                    key: _formKeySignIn,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: buildEmailFormField(size),
                                          ),
                                          SizedBox(
                                              height: size.height * 0.02),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: Container(
                                                width: double.infinity,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: size.width * 0.024),
                                                  child: Row(
                                                    children: [
                                                      countryCodePicker(size),
                                                      Flexible(
                                                          flex: 2,
                                                          child: TextFormField(
                                                              // validator: (value) {
                                                              //   if(value!.isEmpty) {
                                                              //     return "Please enter your phone number";
                                                              //   }else if (value.length < 6){
                                                              //     return "Please enter a valid phone number";
                                                              //   }
                                                              //   return null;
                                                              // },
                                                            // onChanged: (value){
                                                            //   regOneController.phone = value;
                                                            // },
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.digitsOnly
                                                            ],
                                                            keyboardType:
                                                            TextInputType.number,
                                                            controller: registrationOneController.phoneNumTextEditingController,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors.black
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText: 'phone number',
                                                              hintStyle:
                                                              TextStyle(fontSize: 18, color: Colors.grey),
                                                              fillColor: Colors.white,
                                                              border: InputBorder.none,
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                              height: size.height * 0.020),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: buildPasswordFormField(size),
                                          ),
                                          SizedBox(
                                              height: size.height * 0.020),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: buildConformPassFormField(size),
                                          ),
                                          SizedBox(
                                              height: size.height * 0.045),
                                          SizedBox(
                                            width: size.width * 0.6,
                                            height: 60,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                   registrationOneController.phoneNumber =
                                                       '${registrationOneController.countryCode}'
                                                      '${registrationOneController.phoneNumTextEditingController.text
                                                      .replaceAll(RegExp(r'^0+(?=.)'), '')}';

                                                  if(registrationOneController
                                                      .emailTextEditingController.text.isEmpty) {
                                                    CustomSnackBar.showSnackBar(
                                                        context: context,
                                                        title: "Error",
                                                        message: kEmailNullError,
                                                        backgroundColor: Colors.red);
                                                  }
                                                  else if(!emailValidatorRegExp
                                                      .hasMatch(registrationOneController
                                                      .emailTextEditingController
                                                      .text)) {
                                                    CustomSnackBar.showSnackBar(
                                                        context: context,
                                                        title: "Error",
                                                        message: kInvalidEmailError,
                                                        backgroundColor: Colors.red);
                                                  }
                                                  else if(registrationOneController
                                                      .passwordTextEditingController.text.isEmpty) {
                                                    CustomSnackBar.showSnackBar(
                                                        context: context,
                                                        title: "Error",
                                                        message: kPassNullError,
                                                        backgroundColor: Colors.red);
                                                  }
                                                  else if(registrationOneController
                                                      .passwordTextEditingController.text
                                                      .length < 6) {
                                                    CustomSnackBar.showSnackBar(
                                                        context: context,
                                                        title: "Error",
                                                        message: kShortPassError,
                                                        backgroundColor: Colors.red);
                                                  }
                                                  else if (registrationOneController
                                                      .passwordTextEditingController
                                                      .text != registrationOneController
                                                      .confirmPwdTextEditingController.text) {
                                                    CustomSnackBar.showSnackBar(
                                                        context: context,
                                                        title: "Error",
                                                        message: kMatchPassError,
                                                        backgroundColor: Colors.red);
                                                  }
                                                  else if (!passwordValidatorRegExp
                                                      .hasMatch(registrationOneController
                                                      .passwordTextEditingController
                                                      .text)) {
                                                    registrationOneController.displaySnackBar(
                                                        kInvalidPassError, context);
                                                  } else if (registrationOneController
                                                      .countryCode == null) {
                                                    CustomSnackBar.showSnackBar(
                                                        context: context,
                                                        title: "Error",
                                                        message: "Select a country code",
                                                        backgroundColor: Colors.red);
                                                  } else {
                                                    Get.toNamed(Routes.REGISTRATION_TWO);
                                                  }
                                                  //_signIn();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 0, vertical: 20),
                                                    primary: kPrimaryColor),
                                                child: Text(
                                                  'Next',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                              height: size.height * 0.06),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: 'By clicking Next, you are indicating that you have read and agreed to the ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    fontFamily: josefinSansRegular
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'Terms of Service ',
                                                style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    fontFamily: josefinSansRegular
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'and ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    fontFamily: josefinSansRegular
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'Privacy Policy',
                                                style: TextStyle(
                                                  color: yellow,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: josefinSansRegular,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ]),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                )
            )
    );
  }
}
