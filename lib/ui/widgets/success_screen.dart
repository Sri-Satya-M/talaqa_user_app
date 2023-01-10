import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/profile/profile_mobile_screen.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatelessWidget {
  final String type;
  final String message;

  const SuccessScreen({
    super.key,
    required this.type,
    required this.message,
  });

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

              default:
                Container();
            }
          },
          child: const Text("Continue"),
        ),
      ),
    );
  }
}
