import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioCallScreen extends StatelessWidget {
  const AudioCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              'assets/images/avatar_img1.png',
              fit: BoxFit.cover,
            )),
            Positioned.fill(
                child: Container(
              color: Colors.black45,
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(
                  flex: 2,
                ),
                Center(
                    child: Hero(
                  tag: 'title',
                  child: Text(
                    'Dr. Charles Richard',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1!.fontFamily),
                  ),
                )),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    '12:08',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1!.fontFamily),
                  ),
                ),
                Spacer(
                  flex: 11,
                ),
                Container(
                  height: 60,
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white70,
                ),
                Container(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.videocam_off,
                          color: Colors.transparent,
                          size: 36,
                        ),
                        onPressed: () {},
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        // padding: const EdgeInsets.all(4),
                        child: IconButton(
                          icon: Icon(
                            Icons.call_end,
                            color: Colors.red,
                            size: 45,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.mic_off,
                          color: Colors.white70,
                          size: 38,
                        ),
                        onPressed: () {
                          //TODO: on mic-off clicked
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
            // Positioned(
            //   bottom: 145,
            //   left: 10,
            //   child: Container(
            //     height: size.height * 0.25,
            //     width: size.width * 0.4,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(12),
            //       child: Image.asset(
            //         'assets/images/avatar_img2.png',
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
