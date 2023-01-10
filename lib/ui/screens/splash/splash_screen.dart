import 'package:alsan_app/ui/screens/main/main_screen.dart';
import 'package:flutter/material.dart';

import '../../../config/routes.dart';
import '../../../data/local/shared_prefs.dart';
import '../../../resources/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checks() async {
    var token = await Prefs.getToken();
    if (token != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (route) => false,
      );
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.language,
      (route) => false,
    );
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
