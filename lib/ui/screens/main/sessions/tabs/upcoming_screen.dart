import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../widgets/session_card.dart';

class UpcomingTab extends StatefulWidget {
  const UpcomingTab({super.key});

  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab> {
  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return FutureBuilder<List<Session>>(
      future: sessionBloc.getSessions(query: {
        "status": ["PENDING", "APPROVED","PAID"]
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }
        if (!snapshot.hasData) {
          return const LoadingWidget();
        }
        var sessions = snapshot.data ?? [];
        if (sessions.isEmpty) return const EmptyWidget();
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            return SessionCard(session: sessions[index]);
          },
        );
      },
    );
  }
}
