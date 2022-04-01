import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

class ProgressDialogHelper{
  late NAlertDialog dialog;

  showProgressDialog(BuildContext context, String text){
    dialog = NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text("Please wait"),
      content: Row(
        children: [
          const CupertinoActivityIndicator(radius: 20, color: Colors.yellow,),
          SizedBox(width: 10,),
          Text(text),
        ],
      ),
      blur: 2,
      dismissable: false,
    );
    dialog.show(context, transitionType: DialogTransitionType.Shrink);
  }

  hideProgressDialog(BuildContext context){
    Navigator.pop(context);
  }
}