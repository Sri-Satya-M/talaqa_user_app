import 'dart:ui';

import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/sesssion_bloc.dart';
import '../../../../../../model/session.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../widgets/error_snackbar.dart';
import '../../../../../widgets/progress_button.dart';
import '../../../home/booking/widgets/timeslot_details_widget.dart';

class ReportWidget extends StatefulWidget {
  final Session session;

  const ReportWidget({super.key, required this.session});

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("${widget.session.sessionId}", style: textTheme.headline4),
          const SizedBox(height: 16),
          DynamicGridView(
            spacing: 0,
            count: 2,
            children: [
              DetailsTile(
                title: Text(langBloc.getString(Strings.patient),
                    style: textTheme.caption),
                value: Text(
                  "${widget.session.patientProfile!.fullName}",
                  style: textTheme.headline3?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              DetailsTile(
                title: Text(langBloc.getString(Strings.clinician),
                    style: textTheme.caption),
                value: Text(
                  "Dr. ${widget.session.clinician!.user!.fullName}",
                  style: textTheme.headline3?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TimeslotDetailsWidget(
                  dateTime: widget.session.date!,
                  timeslots: widget.session.clinicianTimeSlots!,
                ),
              ),
            ],
          ),
          ProgressButton(
            onPressed: () async {
              try {
                var reports = await sessionBloc.getSessionReports(
                  id: widget.session.id!,
                );

                final permission = await Permission.storage.request();

                if (permission.isGranted) {
                  ErrorSnackBar.show(context,
                      '${langBloc.getString(Strings.downloadingReports)}...!');
                  for (var report in reports) {
                    final externalDir = await getExternalStorageDirectory();
                    String url = '${report.fileUrl}';
                  }
                  ErrorSnackBar.show(
                    context,
                    '${langBloc.getString(Strings.reportsDownloaded)}',
                  );
                } else {
                  ErrorSnackBar.show(
                    context,
                    langBloc.getString(Strings.permissionDenied),
                  );
                }
              } catch (e) {}
            },
            child: Text(langBloc.getString(Strings.downloadReport)),
          ),
        ],
      ),
    );
  }
}
