import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'enums.dart';

class TextWidgetInChat extends StatelessWidget {
  final ChatFrom chatFrom;
  final String message;
  final DateTime? date;
  final String avatarUrl;
  final DateTime now = DateTime.now();
  final df = DateFormat('dd/MM/yyyy hh:mm a');

  TextWidgetInChat(
      {Key? key,
      required this.avatarUrl,
      this.chatFrom = ChatFrom.self,
      this.date,
      required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: chatFrom == ChatFrom.self
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: chatFrom == ChatFrom.other
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (chatFrom == ChatFrom.other)
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Center(
                    child: CircleAvatar(
                      radius: 18,
                      foregroundImage: CachedNetworkImageProvider(
                        avatarUrl,
                      ),
                    ),
                  ),
                ),
              if (chatFrom == ChatFrom.other)
                const SizedBox(
                  width: 15,
                ),
              SizedBox(
                width: size.width * 0.65,
                child: Align(
                  alignment: chatFrom == ChatFrom.self
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black54,
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            margin: chatFrom == ChatFrom.other
                ? const EdgeInsets.only(left: 65)
                : const EdgeInsets.only(right: 5),
            child: Text(
              getDate(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          )
        ],
      ),
    );
  }

  String getDate() {
    if (date == null) {
      return df.format(now);
    } else {
      return df.format(date!);
    }
  }
}
