import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatelessWidget {
  final String message;
  final String type;
  final bool isEmailCheck;

  const SuccessScreen(
      {super.key,
      required this.message,
      required this.type,
      required this.isEmailCheck});


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
            // isEmailCheck
            //     ? Navigator.of(context).pushNamedAndRemoveUntil(
            //         Routes.emailProfile, (route) => false)
            //     : Navigator.of(context).pushNamedAndRemoveUntil(
            //         Routes.mobileProfile, (route) => false);
          },
          child: const Text("Continue"),
        ),
      ),
    );
  }
}
