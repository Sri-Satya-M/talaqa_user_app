import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/session.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../utils/helper.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/dynamic_grid_view.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/reverse_details_tile.dart';
import '../../../home/booking/widgets/patient_details_widget.dart';
import '../../reports/reports_screen.dart';

class CompletedSessionScreen extends StatefulWidget {
  final int id;

  const CompletedSessionScreen({super.key, required this.id});

  static Future open(BuildContext context, {required int id}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CompletedSessionScreen(id: id)),
    );
  }

  @override
  _CompletedSessionScreenState createState() => _CompletedSessionScreenState();
}

class _CompletedSessionScreenState extends State<CompletedSessionScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionsBloc = Provider.of<SessionBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Completed")),
      body: FutureBuilder<Session>(
        future: sessionsBloc.getSessionById(widget.id.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }
          if (!snapshot.hasData) return const LoadingWidget();

          var session = snapshot.data;
          if (session == null) return const EmptyWidget();

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: MyColors.divider.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("Session Details"),
                    ),
                    Divider(color: MyColors.divider.withOpacity(0.1)),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "${session.sessionId}",
                            style: textTheme.headline4,
                          ),
                          const SizedBox(height: 12),
                          DynamicGridView(
                            spacing: 6,
                            count: 2,
                            children: [
                              ReverseDetailsTile(
                                title: Text(
                                  "Speciality",
                                  style: textTheme.caption,
                                ),
                                value: Text(
                                  "${session.clinician!.designation}",
                                  style: textTheme.bodyText1,
                                ),
                              ),
                              ReverseDetailsTile(
                                title: Text(
                                  "${session.consultationMode}",
                                  style: textTheme.caption,
                                ),
                                value: Text("${session.consultationMode}",
                                    style: textTheme.bodyText1),
                              ),
                              ReverseDetailsTile(
                                title: Text(
                                  "Report Status",
                                  style: textTheme.caption,
                                ),
                                value: Text(
                                  session.status == 'REPORT_SUBMITTED'
                                      ? "Not Submitted"
                                      : "Submitted",
                                  style: textTheme.bodyText1,
                                ),
                              ),
                              ReverseDetailsTile(
                                title: Text(
                                  "Duration",
                                  style: textTheme.caption,
                                ),
                                value: Text(
                                  "${Helper.getDuration(session.duration!)} Hrs",
                                  style: textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          //const TimeSlots(),
                          const SizedBox(width: 8),
                          const SizedBox(height: 12),
                          Text(
                            "Description",
                            style: textTheme.caption,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${session.description}",
                            style: textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              PatientDetailsWidget(patient: session.patientProfile!),
              if (session.status == 'REPORT_SUBMITTED') ...[
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: MyColors.divider.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () {
                          ReportsScreen.open(context, id: session.id!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: const [
                              Text("Reports"),
                              Spacer(),
                              Icon(Icons.arrow_forward, size: 16)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),
              if (session.consultationMode == "HOME") ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: MyColors.divider.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text("User Location Details"),
                      ),
                      Divider(color: MyColors.divider.withOpacity(0.1)),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DetailsTile(
                                    title: Text(
                                      session.patientAddress?.addressLine1 ??
                                          '',
                                    ),
                                    value: Text(
                                      Helper.formatAddress(
                                        address: session.patientAddress,
                                      ),
                                      style: textTheme.caption,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${session.patientAddress!.mobileNumber}",
                                    style: textTheme.bodyText1,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
