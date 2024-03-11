import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';

import 'bloc/agora_bloc.dart';
import 'bloc/language_bloc.dart';
import 'bloc/location_bloc.dart';
import 'bloc/main_bloc.dart';
import 'bloc/payment_bloc.dart';
import 'bloc/progress_bloc.dart';
import 'bloc/session_bloc.dart';
import 'bloc/user_bloc.dart';
import 'config/application.dart';
import 'config/routes.dart';
import 'resources/theme.dart';
import 'ui/widgets/progress_block_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  final LangBloc langBloc;

  App({Key? key, required this.langBloc}) : super(key: key) {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProgressBloc()),
          ChangeNotifierProvider(create: (_) => MainBloc()),
          ChangeNotifierProvider(create: (_) => UserBloc()),
          ChangeNotifierProvider(create: (_) => SessionBloc()),
          ChangeNotifierProvider(create: (_) => LocationBloc()),
          ChangeNotifierProvider(create: (_) => AgoraBloc()),
          ChangeNotifierProvider(create: (_) => PaymentBloc()),
          ChangeNotifierProvider.value(value: langBloc),
        ],
        child: ProgressBlockWidget(
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Talaqa App: Book A Doctor Now',
            theme: AppTheme.theme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Application.router?.generator,
            scrollBehavior: const ScrollBehavior().copyWith(
              overscroll: false,
            ),
          ),
        ),
      ),
    );
  }
}
