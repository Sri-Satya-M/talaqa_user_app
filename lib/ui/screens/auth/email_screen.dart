import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/config/routes.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/auth/login/email_login_screen.dart';
import 'package:alsan_app/ui/screens/otp/otp_screen.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  String emailId = '';

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 120),
            Image.asset(Images.logo, height: 60, width: 200),
            const SizedBox(height: 92),
            const Text(
              "Sign up with Email Address",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                emailId = value;
              },
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Enter your email ID",
              ),
            ),
            const SizedBox(height: 40),
            ProgressButton(
              onPressed: () async {
                if (!emailId.contains("@") || !emailId.contains(".")) {
                  return ErrorSnackBar.show(context, "Add Valid email ID");
                }

                var body = {"type": "EMAIL", "email": emailId};

                var response =
                    await userBloc.sendOTP(body: body) as Map<String, dynamic>;

                if (!response.containsKey('token')) {
                  return ErrorSnackBar.show(context, "Invalid Error");
                }
                userBloc.username = emailId;
                OtpScreen.open(context, token: response['token']);
              },
              child: const Text("Get OTP"),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 50,
                  height: 1,
                  color: Colors.black.withOpacity(0.2),
                ),
                const Text("or"),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 50,
                  height: 1,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ProgressButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.mobile,
                  (route) => false,
                );
              },
              child: const Text("Sign Up With Mobile Number"),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
