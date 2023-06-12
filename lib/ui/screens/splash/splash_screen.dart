import 'package:alsan_app/bloc/main_bloc.dart';
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

      if (token != null) {
        var userBloc = Provider.of<UserBloc>(context, listen: false);
        var mainBloc = Provider.of<MainBloc>(context, listen: false);
        await userBloc.getProfile();
        MainScreen.open(context);
        mainBloc.changeIndex(0);
      } else {
        await LanguageScreen.open(context: context, isFromLogin: true);
      }
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
