import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/auth/login/email_login_screen.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/routes.dart';
import '../../../resources/strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
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
              '${langBloc.getString(Strings.welcomeBack)}!',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium!.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              langBloc.getString(Strings.createAnAccount),
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ProgressButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.mobile);
              },
              child: Text(
                langBloc.getString(Strings.signUpWithMobileNumber),
                style: textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.palePink,
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.email);
              },
              child: Text(
                langBloc.getString(Strings.signUpWithEmailAddress),
                style: textTheme.labelLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "${langBloc.getString(Strings.alreadyAnExistingUser)}?\t",
                    style: textTheme.displaySmall!.copyWith(
                      fontSize: 12,
                    ),
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
                )
              ],
            ),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
