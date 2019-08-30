import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatelessWidget {
  const BrowserPage({Key key, this.url}) : super(key: key);
  
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(initialUrl: url,),
    );
  }
}