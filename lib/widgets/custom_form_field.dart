import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  final String hint;
  final bool showCursor;
  final Function() onTap;
  final bool readOnly, obscureText;
  final Function() togglePassword;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final List<TextInputFormatter> formatters;

  const CustomFormField(
      {Key? key, required this.hint,
        required this.textEditingController,
        required this.showCursor,
        required this.formatters,
        this.readOnly = false,
        required this.onTap,
        required this.textInputType,
        required this.obscureText,
        required this.togglePassword}) : super(key: key);

  Widget icon(){
    if(hint == 'Password'){
      return Icon(obscureText==false ? Icons.visibility : Icons.visibility_off);
    }else{
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: textEditingController,
      showCursor: showCursor,
      onTap: onTap,
      obscureText: obscureText,
      inputFormatters: formatters,
      keyboardType: textInputType,
      style: TextStyle(
          fontSize: 18,
          color: Colors.black
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        TextStyle(fontSize: 18, color: Colors.grey),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        suffix: InkWell(
            onTap: togglePassword,
            child: icon()
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: 16),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}