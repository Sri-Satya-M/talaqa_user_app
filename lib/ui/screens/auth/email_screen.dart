import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/config/routes.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/auth/login/email_login_screen.dart';
import 'package:alsan_app/ui/screens/otp/otp_screen.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../resources/colors.dart';
import '../../../resources/strings.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  String emailId = '';

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: size.height * 0.05),
            Image.asset(Images.logo, height: 140),
            const SizedBox(height: 32),
            Text(
              langBloc.getString(Strings.signUpWithEmailAddress),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                emailId = value;
              },
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: langBloc.getString(Strings.enterYourEmailId),
              ),
            ),
            const SizedBox(height: 32),
            ProgressButton(
              onPressed: () async {
                if (!emailId.contains("@") || !emailId.contains(".")) {
                  return ErrorSnackBar.show(
                    context,
                    langBloc.getString(Strings.addValidEmailId),
                  );
                }

                var body = {"type": "EMAIL", "email": emailId};

                var response =
                    await userBloc.sendOTP(body: body) as Map<String, dynamic>;

                if (!response.containsKey('token')) {
                  return ErrorSnackBar.show(
                    context,
                    langBloc.getString(Strings.invalidError),
                  );
                }
                userBloc.username = emailId;
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
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.mobile,
                  (route) => false,
                );
              },
              child: Text(
                langBloc.getString(Strings.signUpWithMobileNumber),
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
                        MaterialPageRoute(builder: (context) => EmailLogin()),
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
        ),
      ),
    );
  }
}
