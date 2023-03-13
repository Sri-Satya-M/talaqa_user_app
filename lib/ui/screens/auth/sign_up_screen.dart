import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/auth/login/email_login_screen.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';

import '../../../config/routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 142),
            Image.asset(Images.logo, height: 70, width: 200),
            const SizedBox(height: 64),
            const Text(
              "Welcome!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const Text(
              "create an account",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ProgressButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.mobile,
                  (route) => false,
                );
              },
              child: const Text("Sign Up With Mobile Number"),
            ),
            const SizedBox(height: 16),
            ProgressButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.email,
                  (route) => false,
                );
              },
              child: const Text("Sign Up With Email Address"),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already an existing user?\t"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmailLogin()),
                    );
                  },
                  child: const Text(
                    "Login to your account",
                    style: TextStyle(color: MyColors.primaryColor),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
