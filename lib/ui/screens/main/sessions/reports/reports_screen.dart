import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/reports.dart';
import '../../../../../resources/images.dart';
import '../../../../../resources/strings.dart';
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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.reports))),
      body: FutureBuilder<List<Report>>(
        future: sessionsBloc.getSessionReports(
          id: widget.id,
          query: {'userType': 'CLINICIAN'},
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }
          if (!snapshot.hasData) return const LoadingWidget();

          var reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return EmptyWidget(
              message: langBloc.getString(Strings.reportsWillBeUploadedSoon),
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
                          Text(
                            '${langBloc.getString(Strings.report)} ${i + 1}',
                          ),
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
