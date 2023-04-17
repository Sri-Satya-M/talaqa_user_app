import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/data/local/shared_prefs.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
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
            const Text(
              "Welcome Back !",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Text(
              'Login to your account with email address',
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
              decoration: const InputDecoration(
                hintText: "Enter your email ID",
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
                hintText: "Password",
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
                  return ErrorSnackBar.show(context, "Enter Valid email ID");
                }

                var body = {'email': email, 'password': password};

                var response = await userBloc.signInEmail(body: body)
                    as Map<String, dynamic>;

                if (!response.containsKey('access_token')) {
                  return ErrorSnackBar.show(context, "Invalid Error");
                }

                var token = response['access_token'];
                await Prefs.setToken(token);

                await userBloc.getProfile();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    (route) => false);
              },
              child: const Text("Login"),
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
                const Text("or"),
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
                  MaterialPageRoute(builder: (context) => MobileLogin()),
                );
              },
              child: const Text("Login With Mobile Number"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New user?\t"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmailScreen()),
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
