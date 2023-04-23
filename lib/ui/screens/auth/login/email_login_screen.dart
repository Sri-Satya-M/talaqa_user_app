import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/data/local/shared_prefs.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/resources/strings.dart';
import 'package:alsan_app/ui/screens/auth/email_screen.dart';
import 'package:alsan_app/ui/screens/auth/login/mobile_login_screen.dart';
import 'package:alsan_app/ui/screens/main/main_screen.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  bool visibility = true;
  var email = '';
  var password = '';

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
            SizedBox(height: size.height * 0.05),
            Image.asset(Images.logo, height: 140),
            const SizedBox(height: 32),
            Text(
              "${langBloc.getString(Strings.welcomeBack)} !",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Text(
              "${langBloc.getString(Strings.loginToYourAccountWithEmailAddress)}...!",
              style: textTheme.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextFormField(
              onChanged: (value) {
                email = value.toString();
              },
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: langBloc.getString(Strings.enterYourEmailId),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              onChanged: (value) {
                password = value.toString();
              },
              obscureText: visibility,
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: langBloc.getString(Strings.password),
                suffixIcon: IconButton(
                    onPressed: () => setState(() {
                          visibility = !visibility;
                        }),
                    icon: Icon(
                        visibility ? Icons.visibility_off : Icons.visibility)),
              ),
            ),
            const SizedBox(height: 32),
            ProgressButton(
              onPressed: () async {
                if (!email.contains("@") || !email.contains(".")) {
                  return ErrorSnackBar.show(
                    context,
                    langBloc.getString(Strings.enterValidEmailId),
                  );
                }

                var body = {'email': email, 'password': password};

                var response = await userBloc.signInEmail(body: body)
                    as Map<String, dynamic>;

                if (!response.containsKey('access_token')) {
                  return ErrorSnackBar.show(
                    context,
                    langBloc.getString(Strings.invalidError),
                  );
                }

                var token = response['access_token'];
                await Prefs.setToken(token);

                await userBloc.getProfile();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false);
              },
              child: Text(langBloc.getString(Strings.login)),
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
            ProgressButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MobileLogin()),
                );
              },
              child: Text(langBloc.getString(Strings.loginWithMobileNumber)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${langBloc.getString(Strings.newUser)}?\t"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmailScreen()),
                    );
                  },
                  child: Text(
                    // "Create an account",
                    langBloc.getString(Strings.hello),
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
