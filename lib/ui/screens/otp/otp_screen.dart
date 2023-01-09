import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/images.dart';
import 'package:alsan_app/ui/screens/auth/mobile_screen.dart';
import 'package:alsan_app/ui/screens/terms_conditions/terms_conditions.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  final String userName;

  const OtpScreen({super.key, required this.userName});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static Future open({
    required BuildContext context,
    required String userName,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtpScreen(
          userName: userName,
        ),
      ),
    );
  }

  var otp = '';

  @override
  Widget build(BuildContext context) {
    var isEmail = widget.userName.contains('@');
    var text = isEmail ? "email id" : "mobile number";
    var digit = isEmail ? 5 : 4;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 150),
            Image.asset(
              Images.logo,
              height: 60,
              width: 200,
            ),
            const SizedBox(height: 50),
            const Text(
              "OTP Verification",
              textAlign: TextAlign.center,
            ),
            Text(
              "Enter the $digit digit code sent on your \n$text ",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(color: MyColors.primaryColor),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MobileScreen()),
                    );
                  },
                  child: Image.asset(
                    Images.editIcon,
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < digit; i++)
                  SizedBox(
                    width: 40,
                    height: 64,
                    child: TextField(
                      onChanged: (value) {
                        otp += value;
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
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
                const Text("Didn't receive the OTP?\t"),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Resend",
                    style: TextStyle(color: MyColors.primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: ProgressButton(
          onPressed: () {
            // print(otp);
            // return;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TermsConditions(isEmail: isEmail)),
            );
          },
          child: const Text("Submit"),
        ),
      ),
    );
  }
}
