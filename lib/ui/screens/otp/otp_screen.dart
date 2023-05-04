import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/auth/mobile_screen.dart';
import 'package:alsan_app/ui/screens/main/main_screen.dart';
import 'package:alsan_app/ui/screens/terms_conditions/terms_conditions.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../data/local/shared_prefs.dart';
import '../../../resources/strings.dart';

class OtpScreen extends StatefulWidget {
  String token;

  OtpScreen({super.key, required this.token});

  static Future open(
    BuildContext context, {
    required String token,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtpScreen(token: token),
      ),
    );
  }

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var otp = '';

  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var isEmail = userBloc.username.contains('@');
    var text = isEmail ? "email id" : "mobile number";
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            Image.asset(Images.logo, height: 140),
            const SizedBox(height: 32),
            Text(
              langBloc.getString(Strings.otpVerification),
              textAlign: TextAlign.center,
            ),
            Text(
              "${langBloc.getString(Strings.enterTheOtpCodeSentToYour)} \n$text ",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userBloc.username,
                  style: const TextStyle(color: MyColors.primaryColor),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileScreen(),
                      ),
                    );
                  },
                  child: Image.asset(Images.editIcon, height: 16, width: 16),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 4; i++)
                  SizedBox(
                    width: 40,
                    height: 64,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          otp += value;
                          FocusScope.of(context).nextFocus();
                        } else {
                          otp = otp.substring(0, i);
                          print(otp);
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${langBloc.getString(Strings.didntReceiveTheOtp)}?\t"),
                TextButton(
                  onPressed: () async {
                    var body = {};
                    body['type'] = isEmail ? 'EMAIL' : 'MOBILE';
                    body[isEmail ? 'email' : 'mobileNumber'] =
                        userBloc.username;

                    var response = await userBloc.sendOTP(body: body)
                        as Map<String, dynamic>;

                    if (!response.containsKey('token')) {
                      return ErrorSnackBar.show(
                          context, langBloc.getString(Strings.invalidError));
                    }

                    widget.token = response['token'];
                  },
                  child: Text(
                    langBloc.getString(Strings.resend),
                    style: const TextStyle(color: MyColors.primaryColor),
                  ),
                ),
              ],
            ),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: ProgressButton(
          onPressed: () async {
            if (otp.length == 4) {
              var body = {'token': widget.token, 'otp': otp};

              body[isEmail ? 'email' : 'mobileNumber'] = userBloc.username;
              print(body);
              var response = await userBloc.verifyOTP(
                body: body,
              ) as Map<String, dynamic>;

              if (response.containsKey('message')) {
                TermsConditions.open(context);
              } else if (response.containsKey('access_token')) {
                await Prefs.setToken(response['access_token']);
                await userBloc.getProfile();
                MainScreen.open(context);
              } else {
                return ErrorSnackBar.show(
                  context,
                  langBloc.getString(Strings.invalidError),
                );
              }
            } else {
              return ErrorSnackBar.show(
                context,
                langBloc.getString(Strings.enter4digitOtp),
              );
            }
          },
          child: Text(langBloc.getString(Strings.submit)),
        ),
      ),
    );
  }
}
