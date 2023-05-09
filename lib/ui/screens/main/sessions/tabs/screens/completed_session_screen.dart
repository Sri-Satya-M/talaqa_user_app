import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/session.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../utils/helper.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/reverse_details_tile.dart';
import '../../../home/booking/widgets/bill_details_widget.dart';
import '../../../home/booking/widgets/clinician_details_widget.dart';
import '../../../home/booking/widgets/patient_details_widget.dart';
import '../../../home/booking/widgets/review_time_slot_widget.dart';
import '../../reports/reports_screen.dart';
import '../../widgets/address_card.dart';

class CompletedSessionScreen extends StatefulWidget {
  final String id;

  const CompletedSessionScreen({super.key, required this.id});

  static Future open(BuildContext context, {required String id}) {
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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.completed))),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5BFF9F),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('${session.sessionId}'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langBloc.getString(Strings.speechTherapy),
                    style: textTheme.headline4,
                  ),
                  if (session.consultationMode == 'HOME') ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.home,
                          color: Colors.blue,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          langBloc.getString(Strings.atHome),
                          style: textTheme.bodyText1?.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
                  ],
                ],
              ),
              const SizedBox(height: 8),
              ReviewTimeSlotWidget(
                dateTime: session.date!,
                timeslots:
                    session.sessionTimeslots!.map((e) => e.timeslot!).toList(),
                duration: Helper.getDuration(session.duration),
              ),
              const SizedBox(height: 16),
              ReverseDetailsTile(
                title: Text(langBloc.getString(Strings.clinicianDetails)),
                value: Container(
                  decoration: BoxDecoration(
                    color: MyColors.paleLightGreen,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClinicianDetailsWidget(
                    clinician: session.clinician!,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ReverseDetailsTile(
                title: Text(langBloc.getString(Strings.patientDetails)),
                value: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: const BoxDecoration(
                    color: MyColors.paleLightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: PatientDetailsWidget(
                    patient: session.patientProfile!,
                  ),
                ),
              ),
              if (session.consultationMode == "HOME") ...[
                const SizedBox(height: 16),
                AddressCard(
                  address: session.patientAddress!,
                  onTap: () async {
                    await Helper.openMap(
                      latitude: double.parse(
                        session.patientAddress!.latitude!,
                      ),
                      longitude: double.parse(
                        session.patientAddress!.latitude!,
                      ),
                      name: session.patientProfile!.fullName!,
                      address: Helper.formatAddress(
                        address: session.patientAddress,
                      ),
                    );
                  },
                  suffixIcon: Icons.directions,
                  suffixIconColor: MyColors.primaryColor,
                ),
              ],
              const SizedBox(height: 16),
              ReverseDetailsTile(
                title: Text(langBloc.getString(Strings.symptoms)),
                value: Text('${session.symptom}', style: textTheme.headline2),
              ),
              const SizedBox(height: 16),
              ReverseDetailsTile(
                title: Text(langBloc.getString(Strings.description)),
                value: Text(
                  '${session.description}',
                  style: textTheme.headline2,
                ),
              ),
              const SizedBox(height: 16),
              BillDetailsWidget(
                noOfTimeslots: session.sessionTimeslots!.length,
                totalAmount: session.sessionPayment!.totalAmount!.toDouble(),
                consultationMode: Helper.textCapitalization(
                  text: session.consultationMode,
                ),
              ),
              const SizedBox(height: 16),
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
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          langBloc.getString(Strings.userLocationDetails),
                        ),
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
                            children: [
                              Text(langBloc.getString(Strings.reports)),
                              const Spacer(),
                              const Icon(Icons.arrow_forward, size: 16)
                            ],
                          ),
                        ),
                      ),
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
