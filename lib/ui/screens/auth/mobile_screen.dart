import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/config/routes.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/otp/otp_screen.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  String mobileNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 120),
            Image.asset(
              Images.logo,
              height: 60,
              width: 200,
            ),
            const SizedBox(height: 92),
            const Text(
              "Sign up with Mobile number",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                InternationalPhoneNumberInput(
                  onInputChanged: (value) {
                    if (value.phoneNumber == null) return;
                    mobileNumber = value.phoneNumber.toString().trim();
                  },
                  textStyle: const TextStyle(color: Colors.black),
                  formatInput: false,
                  maxLength: 10,
                  errorMessage: 'Invalid Phone Number',
                  inputDecoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Mobile Number',
                  ),
                  selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                  spaceBetweenSelectorAndTextField: 0,
                ),
                Positioned(
                  left: 90,
                  top: 8,
                  bottom: 8,
                  child: Container(
                    height: 40,
                    width: 1,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ProgressButton(
              onPressed: () async {
                if (mobileNumber.length < 10) {
                  ErrorSnackBar.show(context, 'Enter 10 digit mobile number');
                  return;
                }

                var body = {'type': 'MOBILE', 'mobileNumber': mobileNumber};

                var userBloc = Provider.of<UserBloc>(context, listen: false);
                var response =
                    await userBloc.sendOTP(body: body) as Map<String, dynamic>;

                if (!response.containsKey('token')) {
                  return ErrorSnackBar.show(context, 'Invalid Error');
                }
                userBloc.username = mobileNumber;
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
                  onPressed: () {},
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
