import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/patient_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({super.key});

  @override
  _UpcomingScreenState createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return FutureBuilder<List<Session>>(
      future: sessionBloc.getSessions(query: {"status": "PENDING"}),
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
            return PatientCard(session: sessions[index]);
          },
        );
      },
    );
  }
}
