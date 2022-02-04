import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tranquil_life/widgets/custom_snackbar.dart';

import 'enums.dart';

class VoiceWidgetInChat extends StatefulWidget {
  final ChatFrom chatFrom;
  final Duration time;
  final DateTime? date;
  final String? avatarUrl;
  final String url;
  const VoiceWidgetInChat(
      {Key? key,
        this.avatarUrl,
        this.chatFrom = ChatFrom.self,
        this.date,
        required this.time,
        required this.url})
      : super(key: key);

  @override
  _VoiceWidgetInChatState createState() => _VoiceWidgetInChatState();
}

class _VoiceWidgetInChatState extends State<VoiceWidgetInChat>
    with SingleTickerProviderStateMixin {
  final DateTime now = DateTime.now();
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late AnimationController animController;
  late ValueNotifier<Animation<double>> fillController;
  bool _mPlayerIsInited = false;
  bool _paused = true;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(duration: widget.time, vsync: this);
    // _mySoundPlayer.openAudioSession().then((value) {
    //   setState(() {
    //     _mPlayerIsInited = true;
    //   });
    // });
    fillController =
        ValueNotifier(Tween<double>(begin: 0, end: 1).animate(animController));
  }

  @override
  void dispose() {
    animController.stop();
    animController.dispose();
    // _mySoundPlayer.closeAudioSession();
    fillController.dispose();
    super.dispose();
  }

  final FlutterSoundPlayer _mySoundPlayer = FlutterSoundPlayer();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: widget.chatFrom == ChatFrom.self
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: widget.chatFrom == ChatFrom.other
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.chatFrom == ChatFrom.other)
                CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Center(
                      child: CircleAvatar(
                        radius: 18,
                        foregroundImage: NetworkImage(
                          widget.avatarUrl ?? '',
                        ),
                      ),
                    )),
              if (widget.chatFrom == ChatFrom.other)
                const SizedBox(
                  width: 15,
                ),
              SizedBox(
                width: size.width * 0.65,
                child: Align(
                  alignment: widget.chatFrom == ChatFrom.self
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black54,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: ValueListenableBuilder(
                                  valueListenable: fillController.value,
                                  builder: (context, double value, child) {
                                    return FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        color: Colors.green,
                                      ),
                                      widthFactor: value,
                                      heightFactor: 1,
                                    );
                                  }),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: _mySoundPlayer.isPlaying
                              ? SvgPicture.asset('assets/icons/icon-pause.svg')
                              : SvgPicture.asset('assets/icons/icon-play.svg'),
                          onPressed: () async {
                            if (animController.isAnimating) {
                              await stopAudio();
                              setState(() {});
                            } else {
                              await playAudio();
                              setState(() {});
                            }
                          },
                        )
                      ],
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
            margin: widget.chatFrom == ChatFrom.other
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
    if (widget.date == null) {
      return df.format(now);
    } else {
      return df.format(widget.date!);
    }
  }

  Future playAudio() async {
    if (_mPlayerIsInited) {
      if (_mySoundPlayer.isStopped) {
        await _mySoundPlayer.startPlayer(
            fromURI: widget.url,
            // codec: Codec.aacADTS,
            whenFinished: () {
              animController.reset();
              setState(() {
                _paused = true;
              });
            });
        animController.forward();
      } else if (_mySoundPlayer.isPaused) {
        setState(() {
          _paused = true;
        });
        await _mySoundPlayer.resumePlayer();
        animController.forward();
      }
    } else {
      displaySnackBar('Can\'t Play Audio', context);
    }
  }

  Future stopAudio() async {
    if (_mySoundPlayer.isPlaying) {
      setState(() {
        _paused = false;
      });
      await _mySoundPlayer.pausePlayer();
      animController.stop();
    }
  }
}