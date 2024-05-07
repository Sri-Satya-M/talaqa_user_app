import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bloc/main_bloc.dart';
import '../../../bloc/user_bloc.dart';
import '../../../data/local/shared_prefs.dart';
import '../../../resources/images.dart';
import '../language/language_screen.dart';
import '../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool selected = false;

  checks() async {
    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() => selected = true),
    );
    Future.delayed(const Duration(seconds: 3), () async {
      var userBloc = Provider.of<UserBloc>(context, listen: false);
      var mainBloc = Provider.of<MainBloc>(context, listen: false);

      var token = await Prefs.getToken();
      if (token != null) {
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            top: !selected ? 0 : (MediaQuery.of(context).size.height / 2) - 110,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: Image.asset(Images.logo_1, height: 80, width: 80),
          ),
          AnimatedPositioned(
            bottom:
                !selected ? 0 : (MediaQuery.of(context).size.height / 2) - 70,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: Image.asset(Images.logo_2, height: 110, width: 110),
          )
        ],
      ),
    );
  }
}
