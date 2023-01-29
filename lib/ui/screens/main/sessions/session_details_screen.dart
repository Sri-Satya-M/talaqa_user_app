import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/model/time_of_day.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/patient_details_widget.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/address_card.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';

import '../../../widgets/dynamic_grid_view.dart';
import '../../../widgets/reverse_details_tile.dart';
import '../home/booking/widgets/details_box.dart';
import '../home/booking/widgets/timeslot_details_widget.dart';

class SessionDetailsScreen extends StatelessWidget {
  final Session session;

  const SessionDetailsScreen({super.key, required this.session});

  static Future open(BuildContext context, {required Session session}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SessionDetailsScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: ListView(
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
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('${session.sessionId}'),
                ),
              ],
            ),
          ),
          PatientDetailsWidget(patient: session.patientProfile!),
          ClinicianDetailsWidget(clinician: session.clinician!),
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
                          '${session.clinician?.designation}',
                          style: textTheme.bodyText1,
                        ),
                      ),
                      ReverseDetailsTile(
                        title: const Text('Mode of consultation'),
                        value: Text(
                          '${session.consultationMode}',
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
                    dateTime: session.date!,
                    timeslots:
                        TimeSlot().showTimeslots(session.clinicianTimeSlots!),
                  ),
                  const SizedBox(height: 8),
                  ReverseDetailsTile(
                    title: const Text('Description'),
                    value: Text(
                      session.description!,
                      style: textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AddressCard(address: session.patientAddress!),
          const SizedBox(height: 64),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: ProgressButton(
          onPressed: () {},
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
