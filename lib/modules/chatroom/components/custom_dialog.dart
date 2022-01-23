import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
  final void Function()? onpressed;
  final String? consultantName;

  const CustomDialogBox({Key? key, this.onpressed, this.consultantName})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 5,
            ),
            Text(
              'End Session',
              style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(
              flex: 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.12),
              child: Text(
                'Do you want to end your current meeting with ${widget.consultantName}?',
                style: TextStyle(color: Colors.green[600], fontSize: 16),
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            const Divider(
              thickness: 2,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onpressed?.call();
              },
              child: Text(
                'YES',
                style: TextStyle(
                    color: Colors.green[900],
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
