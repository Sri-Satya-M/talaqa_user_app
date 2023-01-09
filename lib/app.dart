import 'package:alsan_app/resources/theme.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';

import 'bloc/progress_bloc.dart';
import 'config/application.dart';
import 'config/routes.dart';
import 'ui/widgets/progress_block_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  App({Key? key}) : super(key: key) {
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
        ],
        child: ProgressBlockWidget(
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'ALSAN',
            theme: AppTheme.theme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Application.router?.generator,
          ),
        ),
      ),
    );
  }
}
