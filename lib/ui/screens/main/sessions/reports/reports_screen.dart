import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/reports.dart';
import '../../../../../resources/images.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/pdf_viewer_screen.dart';

class ReportsScreen extends StatefulWidget {
  final int id;

  const ReportsScreen({super.key, required this.id});

  static Future open(BuildContext context, {required int id}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ReportsScreen(id: id)),
    );
  }

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    var sessionsBloc = Provider.of<SessionBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: FutureBuilder<List<Report>>(
        future: sessionsBloc.getSessionReports(id: widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }
          if (!snapshot.hasData) return const LoadingWidget();

          var reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return const EmptyWidget(
              message: 'Reports will be uploaded soon',
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < reports.length; i++) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () {
                        PdfViewerScreen.open(context, url: reports[i].fileUrl!);
                      },
                      child: Row(
                        children: [
                          Image.asset(Images.pdf, height: 40),
                          const SizedBox(width: 16),
                          Text('Report ${i + 1}'),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
