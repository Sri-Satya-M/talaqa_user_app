import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/model/time_of_day.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/patient_details_widget.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/address_card.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/timeline_widget.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/sesssion_bloc.dart';
import '../../../widgets/dynamic_grid_view.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/reverse_details_tile.dart';
import '../home/booking/widgets/details_box.dart';
import '../home/booking/widgets/timeslot_details_widget.dart';

class SessionDetailsScreen extends StatefulWidget {
  final Session session;

  const SessionDetailsScreen({super.key, required this.session});

  static Future open(BuildContext context, {required Session session}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SessionDetailsScreen(
          session: session,
        ),
      ),
    );
  }

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: FutureBuilder<Session>(
          future: sessionBloc.getSessionById(widget.session.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return CustomErrorWidget(error: snapshot.error);
            }
            if (!snapshot.hasData) return const LoadingWidget();
            var data = snapshot.data;
            if (data == null) return const EmptyWidget();

            return ListView(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.divider),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Text('Session ID'),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5BFF9F),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('${widget.session.sessionId}'),
                      ),
                    ],
                  ),
                ),
                PatientDetailsWidget(patient: widget.session.patientProfile!),
                ClinicianDetailsWidget(clinician: widget.session.clinician!),
                DetailsBox(
                  title: 'Session Details',
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DynamicGridView(
                          count: 2,
                          spacing: 8,
                          children: [
                            ReverseDetailsTile(
                              title: const Text('Specialty'),
                              value: Text(
                                '${widget.session.clinician?.designation}',
                                style: textTheme.bodyText1,
                              ),
                            ),
                            ReverseDetailsTile(
                              title: const Text('Mode of consultation'),
                              value: Text(
                                '${widget.session.consultationMode}',
                                style: textTheme.bodyText1,
                              ),
                            ),
                            ReverseDetailsTile(
                              title: const Text('Duration'),
                              value: Text(
                                'Lorem',
                                style: textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TimeslotDetailsWidget(
                          dateTime: widget.session.date!,
                          timeslots: TimeSlot().showTimeslots(
                              widget.session.clinicianTimeSlots!),
                        ),
                        const SizedBox(height: 8),
                        ReverseDetailsTile(
                          title: const Text('Description'),
                          value: Text(
                            widget.session.description!,
                            style: textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                (widget.session.consultationMode == "HOME")
                    ? AddressCard(address: widget.session.patientAddress!)
                    : const SizedBox(),
                TimelineWidget(statuses: widget.session.sessionStatuses!),
                const SizedBox(height: 64),
              ],
            );
          }),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ProgressButton(
          onPressed: () {},
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
