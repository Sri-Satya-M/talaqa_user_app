import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' as f;

import '../ui/screens/auth/sign_up_screen.dart';
import '../ui/screens/language/language_screen.dart';
import '../ui/screens/onboarding/onboarding_screen.dart';
import '../ui/screens/splash/splash_screen.dart';

extension MaterialFluro on FluroRouter {
  void defineMat(String path, Handler handler) {
    define(
      path,
      handler: handler,
      transitionType: TransitionType.material,
    );
  }
}

extension RouteString on String {
  String setId(String id) {
    return replaceFirst(':id', id);
  }
}

class Routes {
  static String root = '/';
  static String language = '/language';
  static String onBoarding = "/onBoarding";
  static String signUp = "/signUp";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = notFoundHandler;

    router.define(
      root,
      handler: rootHandler,
      transitionType: TransitionType.material,
    );

    router.define(
      language,
      handler: languageHandler,
      transitionType: TransitionType.material,
    );

    router.define(
      onBoarding,
      handler: onBoardingHandler,
      transitionType: TransitionType.material,
    );

    router.define(
      onBoarding,
      handler: onBoardingHandler,
      transitionType: TransitionType.material,
    );

    router.define(
      signUp,
      handler: signUpHandler,
      transitionType: TransitionType.material,
    );
  }
}

var notFoundHandler = Handler(
  type: HandlerType.function,
  handlerFunc: (context, params) {
    var path = f.ModalRoute.of(context!)!.settings.name;
    return f.ErrorWidget('$path route was not found!');
  },
);

var rootHandler = Handler(
  handlerFunc: (context, params) => const SplashScreen(),
);

var languageHandler = Handler(
  handlerFunc: (context, params) => const LanguageScreen(),
);

var onBoardingHandler = Handler(
  handlerFunc: (context, params) => const OnBoardingScreen(),
);

var signUpHandler = Handler(
  handlerFunc: (context, params) => const SignUpScreen(),
);
