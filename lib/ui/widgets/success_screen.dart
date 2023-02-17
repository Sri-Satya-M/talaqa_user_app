import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/main/main_screen.dart';
import 'package:alsan_app/ui/screens/profile/profile_email_screen.dart';
import 'package:alsan_app/ui/screens/profile/profile_mobile_screen.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../model/session.dart';

class SuccessScreen extends StatelessWidget {
  final String type;
  final String message;
  final Session? session;

  const SuccessScreen({
    super.key,
    required this.type,
    required this.message,
    this.session,
  });

  static Future open(
    BuildContext context, {
    required String type,
    required String message,
    Session? session,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SuccessScreen(
          type: type,
          message: message,
          session: session,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(Images.success, height: 250, width: 250),
            const SizedBox(height: 24),
            if (session?.id != null) ...[],
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 32,
        ),
        child: ProgressButton(
          onPressed: () {
            switch (type) {
              case 'MOBILE':
                ProfileMobileScreen.open(context);
                break;
              case 'MAIN':
                MainScreen.open(context);
                break;
              case 'EMAIL':
                ProfileEmailScreen.open(context);
                break;
              case 'Payment':
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
                break;
              default:
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
            }
          },
          child: const Text("Continue"),
        ),
      ),
    );
  }
}
