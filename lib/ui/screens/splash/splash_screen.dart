import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/ui/screens/language/language_screen.dart';
import 'package:alsan_app/ui/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

      // var nextScreen = (token == null) ? LanguageScreen() : MainScreen();
      if (token == null) {
        await LanguageScreen.open(context: context, isFromLogin: true);
      }

      if (token != null) {
        var userBloc = Provider.of<UserBloc>(context, listen: false);
        await userBloc.getProfile();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }

      return;
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
