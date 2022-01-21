import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tranquil_app/app/utils/constants.dart';
import 'package:tranquil_app/app/utils/sizes_helpers.dart';

class GreyBorderContainerForDetails extends StatefulWidget {
  const GreyBorderContainerForDetails({
    Key? key,
    required this.svgUrl,
    required this.title,
    this.info,
    this.isUserClient = true,
    this.infoController,
  })  : assert(isUserClient || infoController != null,
  "infoController parameter is a must when user is a consultant to create a textfield to change the info and pass the info text as initial text"),
        assert(!isUserClient || info != null,
        "If user is a client then the info parameter is required"),
        super(key: key);
  final bool isUserClient;
  final String svgUrl;
  final String title;
  final TextEditingController? infoController;
  final String? info;

  @override
  _GreyBorderContainerForDetailsState createState() =>
      _GreyBorderContainerForDetailsState();
}

class _GreyBorderContainerForDetailsState
    extends State<GreyBorderContainerForDetails> {
  bool isEditPressed = false;

  @override
  Widget build(BuildContext context) {
    return
      //------------------------
      // CONTAINER WITH GREY BORDER
      //------------------------
      Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[400]!,
          ),
        ),
        width: displayWidth(context) * 0.86,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //------------------------
            // SVG
            //------------------------
            Container(
              height: displayHeight(context) * 0.05,
              width: displayHeight(context) * 0.05,
              child: SvgPicture.asset(
                widget.svgUrl,
                fit: BoxFit.contain,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            //------------------------
            // TITLES
            //------------------------
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------
                  // TITLE
                  //------------------------
                  Expanded(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: kPrimaryDarkColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  if (!isEditPressed) ...[
                    if (widget.isUserClient)
                    //------------------------
                    // INFO
                    //------------------------
                      Expanded(
                        child: Text(
                          widget.info ?? '',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    if (!widget.isUserClient)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                widget.infoController?.text ?? '',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: kPrimaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditPressed = true;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                  if (isEditPressed)
                  //------------------------
                  // TextField for editing info
                  //------------------------
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: widget.infoController,
                              decoration: InputDecoration(
                                errorBorder: InputBorder.none,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                disabledBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Enter the ${widget.title}',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.done,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                isEditPressed = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}