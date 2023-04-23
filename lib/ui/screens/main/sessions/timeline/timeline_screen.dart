import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/timeline_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/session.dart';
import '../../../../../resources/strings.dart';

class TimelineScreen extends StatelessWidget {
  final Session session;

  const TimelineScreen({super.key, required this.session});

  static Future open(BuildContext context, {required Session session}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TimelineScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.timeline))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: TimelineWidget(statuses: session.sessionStatuses!),
      ),
    );
  }
}
