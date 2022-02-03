import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:tranquil_life/constants/style.dart';
import 'package:tranquil_life/controllers/chat_controller.dart';

class ChatRoomCard extends StatefulWidget {
  @override
  _ChatRoomCardState createState() => _ChatRoomCardState();
}

class _ChatRoomCardState extends State<ChatRoomCard> {

  final ChatHistoryController _ = Get.put(ChatHistoryController());


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: kLightBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:Container(
              width: 54.0,
              height: 54.0,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                border: Border.all(width: 2, color: const Color(0xffC9D8CD)),
                image: DecorationImage(
                  image: NetworkImage(_.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
