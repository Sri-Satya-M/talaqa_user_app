import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/ui/screens/main/sessions/tabs/upcoming_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tabs/cancelled_tab.dart';
import 'tabs/completed_tab.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

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
            return const UpcomingTab();
          case 1:
            return const CompletedTab();
          case 2:
            return const CancelledTab();
          default:
            return const SizedBox();
        }
      },
    );
  }
}
