import 'package:alsan_app/ui/screens/language/language_screen.dart';
import 'package:alsan_app/ui/screens/main/main_screen.dart';
import 'package:flutter/material.dart';

import '../../../data/local/shared_prefs.dart';
import '../../../resources/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checks() async {
    Future.delayed(const Duration(seconds: 2), () async {
      var token = await Prefs.getToken();

      var nextScreen = (token == null) ? LanguageScreen() : MainScreen();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => nextScreen,
        ),
        (route) => false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    checks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Images.logo, height: 250, width: 250),
      ),
    );
  }
}
