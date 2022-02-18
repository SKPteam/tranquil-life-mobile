// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewUI extends StatelessWidget {
  final String? url;
  WebViewUI({Key? key, this.url}) : super(key: key);

  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    print(url!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: url.toString(),
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith(url.toString())) {
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              } else {
                print('launching external navigation to $request');
                launch(request.url.toString());
                return NavigationDecision.prevent;
              }
            },
            // onPageStarted: (url) {
            //   setState(() {
            //     loadingPercentage = 0;
            //   });
            // },
            // onProgress: (progress) {
            //   setState(() {
            //     loadingPercentage = progress;
            //   });
            // },
            // onPageFinished: (url) {
            //   setState(() {
            //     loadingPercentage = 100;
            //   });
            // },
          ),

          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      )
    );
  }
}
