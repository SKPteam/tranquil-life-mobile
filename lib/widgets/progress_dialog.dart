import 'package:flutter/material.dart';
import 'package:tranquil_life/constants/style.dart';

import 'package:tranquil_life/helpers/constants.dart';

class ProgressDialog extends StatelessWidget{

  final String message;
  const ProgressDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6.0)
        ),
        child: Row(
          children: [
            const SizedBox(width: 6.0),
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor)
            ),
            const SizedBox(width: 26.0),
            Text(message,
                style: const TextStyle(
                    color: Colors.black
                )
            )
          ],
        ),
      ),
    );
  }

}