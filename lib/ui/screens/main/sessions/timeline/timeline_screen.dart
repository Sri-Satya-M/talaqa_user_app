import 'package:alsan_app/ui/screens/main/sessions/widgets/timeline_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../model/session.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Timeline')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: TimelineWidget(statuses: session.sessionStatuses!),
      ),
    );
  }
}
