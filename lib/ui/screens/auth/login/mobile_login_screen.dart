import 'package:alsan_app/bloc/language_bloc.dart';
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

import '../../../../resources/strings.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  _MobileLoginState createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  var mobileNumber = '';
  String countryCode = '';

  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'SA');

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: size.height * 0.10),
            Image.asset(Images.logo, height: 140),
            const SizedBox(height: 32),
            Text(
              langBloc.getString(Strings.loginWithMobileNumber),
              style: textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Stack(
              children: [
                InternationalPhoneNumberInput(
                  initialValue: phoneNumber,
                  onInputChanged: (value) {
                    if (value.phoneNumber == null) return;
                    mobileNumber = value.phoneNumber
                        .toString()
                        .replaceFirst(value.dialCode.toString(), '')
                        .trim();
                    countryCode = '${value.dialCode}';
                  },
                  textStyle: const TextStyle(color: Colors.black),
                  formatInput: false,
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
            const SizedBox(height: 32),
            ProgressButton(
              onPressed: () async {
                var body = {
                  'type': 'MOBILE',
                  'mobileNumber': mobileNumber,
                  'countryCode': countryCode,
                };

                var response = await userBloc.sendOTP(body: body);

                if (!response.containsKey('token')) {
                  return ErrorSnackBar.show(
                    context,
                    langBloc.getString(Strings.invalidError),
                  );
                }

                userBloc.username = mobileNumber;
                userBloc.countryCode = countryCode;
                OtpScreen.open(context, token: response['token']);
              },
              child: Text(langBloc.getString(Strings.getOtp)),
            ),
            const SizedBox(height: 32),
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
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.palePink,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailLogin()),
                );
              },
              child: Text(
                langBloc.getString(Strings.loginWithEmailAddress),
                style: textTheme.labelLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${langBloc.getString(Strings.newUser)}?\t"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileScreen(),
                      ),
                    );
                  },
                  child: Text(
                    langBloc.getString(Strings.createAnAccount),
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
