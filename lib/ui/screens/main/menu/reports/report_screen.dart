import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/ui/screens/main/menu/reports/widgets/report_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/sesssion_bloc.dart';
import '../../../../../resources/strings.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.reports))),
      body: FutureBuilder<List<Session>>(
        future: sessionBloc.getSessions(query: {
          "status": ["REPORT_SUBMITTED"]
        }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }

          if (!snapshot.hasData) return const LoadingWidget();

          var sessions = snapshot.data ?? [];

          if (sessions.isEmpty) return const EmptyWidget();

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              return ReportWidget(session: sessions[index]);
            },
          );
        },
      ),
    );
  }
}
