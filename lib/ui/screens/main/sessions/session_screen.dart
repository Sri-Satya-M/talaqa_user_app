import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/ui/screens/main/sessions/cancelled_screen.dart';
import 'package:alsan_app/ui/screens/main/sessions/completed_screen.dart';
import 'package:alsan_app/ui/screens/main/sessions/upcoming_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionScreen extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  Widget build(BuildContext context) {
    var mainBloc = Provider.of<MainBloc>(context, listen: true);
    return Builder(
      builder: (context) {
        switch (mainBloc.tab) {
          case 0:
            return UpcomingScreen();
          case 1:
            return CompletedScreen();
          case 2:
            return CancelledScreen();
          default:
            return const SizedBox();
        }
      },
    );
  }
}
