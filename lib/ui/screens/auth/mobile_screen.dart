import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/config/routes.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/auth/login/mobile_login_screen.dart';
import 'package:alsan_app/ui/screens/otp/otp_screen.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../../../resources/strings.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  String mobileNumber = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: size.height * 0.05),
            Image.asset(Images.logo, height: 140),
            const SizedBox(height: 32),
            Text(
              langBloc.getString(Strings.signUpWithMobileNumber),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 32),
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
                  errorMessage: langBloc.getString(Strings.invalidPhoneNumber),
                  inputDecoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: langBloc.getString(Strings.mobileNumber),
                  ),
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
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
            const SizedBox(height: 54),
            ProgressButton(
              onPressed: () async {
                if (mobileNumber.length < 10) {
                  ErrorSnackBar.show(
                    context,
                    langBloc.getString(
                      Strings.enter10DigitMobileNumber,
                    ),
                  );
                  return;
                }

                var body = {'type': 'MOBILE', 'mobileNumber': mobileNumber};

                var userBloc = Provider.of<UserBloc>(context, listen: false);
                var response =
                    await userBloc.sendOTP(body: body) as Map<String, dynamic>;

                if (!response.containsKey('token')) {
                  return ErrorSnackBar.show(
                    context,
                    langBloc.getString(Strings.invalidError),
                  );
                }
                userBloc.username = mobileNumber;
                OtpScreen.open(context, token: response['token']);
              },
              child: Text(langBloc.getString(Strings.getOtp)),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 50,
                  height: 1,
                  color: Colors.black.withOpacity(0.2),
                ),
                Text(langBloc.getString(Strings.or)),
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
              child: Text(langBloc.getString(Strings.signUpWithEmailAddress)),
            ),
            const SizedBox(height: 32),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${langBloc.getString(Strings.alreadyAnExistingUser)}?\t"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileLogin(),
                      ),
                    );
                  },
                  child: Text(
                    langBloc.getString(Strings.loginToYourAccount),
                    style: const TextStyle(color: MyColors.primaryColor),
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
