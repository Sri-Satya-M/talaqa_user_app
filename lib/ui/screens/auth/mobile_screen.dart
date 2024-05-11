import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/otp/otp_screen.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../../../resources/colors.dart';
import '../../../resources/strings.dart';
import 'login/email_login_screen.dart';
import 'login/mobile_login_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  String mobileNumber = '';
  String countryCode = '';
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'SA');

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size.height * 0.1),
              Image.asset(Images.logo, height: 140),
              const SizedBox(height: 48),
              Text(
                langBloc.getString(Strings.signUpWithMobileNumber),
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 48),
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
                    errorMessage:
                        langBloc.getString(Strings.invalidPhoneNumber),
                    inputDecoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: langBloc.getString(
                        Strings.enter10DigitMobileNumber,
                      ),
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
              const SizedBox(height: 64),
              ProgressButton(
                onPressed: () async {
                  var body = {
                    'type': 'MOBILE',
                    'mobileNumber': mobileNumber,
                    'countryCode': countryCode,
                  };

                  var userBloc = Provider.of<UserBloc>(context, listen: false);
                  var response = await userBloc.sendOTP(body: body)
                      as Map<String, dynamic>;

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
                  Expanded(
                    child: Text(
                      "${langBloc.getString(Strings.alreadyAnExistingUser)}?\t",
                      style: textTheme.displaySmall!.copyWith(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MobileLogin(),
                          ),
                        );
                      },
                      child: Text(
                        langBloc.getString(Strings.loginToYourAccount),
                        style: textTheme.displaySmall!.copyWith(
                          color: MyColors.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
