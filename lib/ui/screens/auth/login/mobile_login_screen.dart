import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/auth/login/email_login_screen.dart';
import 'package:alsan_app/ui/screens/auth/mobile_screen.dart';
import 'package:alsan_app/ui/screens/otp/otp_screen.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class MobileLogin extends StatefulWidget {
  @override
  _MobileLoginState createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  var mobileNumber = '';

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            Image.asset(Images.logo, height: 60, width: 200),
            const SizedBox(height: 72),
            const Text(
              "Login with Mobile Number",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                InternationalPhoneNumberInput(
                  onInputChanged: (value) {
                    if (value.phoneNumber == null) return;

                    mobileNumber = value.phoneNumber
                        .toString()
                        .replaceFirst(value.dialCode.toString(), '')
                        .trim();
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
                  return ErrorSnackBar.show(
                      context, "Enter 10 digit mobile number");
                }

                var body = {'type': 'MOBILE', 'mobileNumber': mobileNumber};

                var response = await userBloc.sendOTP(body: body)
                    as Map<String, dynamic>;

                if (!response.containsKey('token')) {
                  return ErrorSnackBar.show(context, "Invalid Error");
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailLogin()),
                );
              },
              child: const Text("Login With Email Address"),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New user?\t"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MobileScreen()),
                    );
                  },
                  child: const Text(
                    "Create an account",
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
