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
  int progress = 0;
  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (progress != 100)
            LinearProgressIndicator(value: progress / 100.0, minHeight: 2)
          else
            Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
