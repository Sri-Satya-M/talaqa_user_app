import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebviewScreen({Key? key, required this.url, required this.title})
      : super(key: key);

  static Future open(
      BuildContext context, {
        required String url,
        required String title,
      }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebviewScreen(url: url, title: title),
      ),
    );
  }

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.title.isEmpty)
          ? null
          : AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Stack(
        children: [
          WebView(
            onProgress: (value) {
              const CircularProgressIndicator();
            },
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              isLoading = false;
              setState(() {});
            },
          ),
          isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Stack(),
        ],
      ),
    );
  }
}
