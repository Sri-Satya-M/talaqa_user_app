import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../resources/strings.dart';

class TermsConditions extends StatefulWidget {
  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TermsConditions(),
      ),
    );
  }

  const TermsConditions({super.key});

  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  bool check = false;
  late bool isEmail;
  bool isLoading = true;

  int progress = 0;
  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    var langBloc = Provider.of<LangBloc>(context, listen: false);

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
      ..loadRequest(
        Uri.parse(
          langBloc.appLanguage == 'English'
              ? 'https://talaqa.online/terms-conditions'
              : 'https://talaqa.online/ar/terms-conditions',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    isEmail = userBloc.username.contains("@");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            Image.asset(Images.logo, height: 60, width: 200),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.15),
                    width: 1.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: WebViewWidget(controller: controller),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: check,
                  onChanged: (value) {
                    setState(() {
                      check = value as bool;
                    });
                  },
                ),
                Text(langBloc.getString(Strings.iAgreeToTheTermsAndConditions))
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: (!check)
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 32,
              ),
              child: ProgressButton(
                onPressed: () {
                  var message = isEmail
                      ? langBloc.getString(
                          Strings.yourEmailIdHasBeenSuccessfullyVerified,
                        )
                      : langBloc.getString(
                          Strings.yourMobileNumberHasBeenSuccessfullyVerified,
                        );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccessScreen(
                        message: message,
                        type: isEmail ? 'EMAIL' : 'MOBILE',
                      ),
                    ),
                  );
                },
                child: Text(langBloc.getString(Strings.proceed)),
              ),
            ),
    );
  }
}
