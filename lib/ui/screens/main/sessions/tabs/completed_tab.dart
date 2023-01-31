import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/sesssion_bloc.dart';
import '../../../../../../model/session.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../widgets/session_card.dart';

class CompletedTab extends StatefulWidget {
  const CompletedTab({super.key});

  @override
  _CompletedTabState createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return FutureBuilder<List<Session>>(
      future: sessionBloc.getSessions(query: {
        "status": ["COMPLETED"]
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
