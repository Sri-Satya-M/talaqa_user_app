import 'dart:isolate';
import 'dart:ui';

import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/sesssion_bloc.dart';
import '../../../../../../model/session.dart';
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
    registerCallback();
  }

  void registerCallback() async {
    ReceivePort _port = ReceivePort();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(
      'downloader_send_port',
    );
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
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
                title: Text("Patient", style: textTheme.caption),
                value: Text(
                  "${widget.session.patientProfile!.fullName}",
                  style: textTheme.headline3?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              DetailsTile(
                title: Text("Clinican", style: textTheme.caption),
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
                  ErrorSnackBar.show(context, 'Downloading Reports...!');
                  for (var report in reports) {
                    final externalDir = await getExternalStorageDirectory();
                    String url = '${report.fileUrl}';
                    FlutterDownloader.enqueue(
                      url: url,
                      fileName: url.split('/').last,
                      savedDir: externalDir?.path ?? '',
                      showNotification: true,
                      openFileFromNotification: true,
                    );
                  }
                  ErrorSnackBar.show(context, 'Reports Downloaded');
                } else {
                  ErrorSnackBar.show(context, 'Permission Denied');
                }
              } catch (e) {}
            },
            child: const Text("Download Report"),
          )
        ],
      ),
    );
  }
}
