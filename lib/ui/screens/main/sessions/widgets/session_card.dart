import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/timeslot_details_widget.dart';
import 'package:alsan_app/ui/screens/main/sessions/session_details_screen.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:flutter/material.dart';

import '../../../../../model/session.dart';

class SessionCard extends StatelessWidget {
  final Session session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => SessionDetailsScreen.open(context, session: session),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${session.sessionId}",
                    style: textTheme.headline4,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: MyColors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    child: Text(
                      '${session.status}',
                      style: textTheme.bodyText1,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Avatar(
                    url: session.clinician?.image,
                    name: session.clinician?.user?.fullName,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  const SizedBox(width: 8),
                  DetailsTile(
                    title: Text("${session.clinician?.user?.fullName}"),
                    value: Text(
                      "${session.clinician?.experience} years exp",
                      style: textTheme.caption,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DynamicGridView(
                spacing: 5,
                count: 2,
                children: [
                  ReverseDetailsTile(
                    title: Text("Speciality", style: textTheme.caption),
                    value: Text(
                      "${session.clinician?.designation}",
                      style: textTheme.bodyText1,
                    ),
                  ),
                  ReverseDetailsTile(
                    title:
                        Text("Mode of consultation", style: textTheme.caption),
                    value: Text("${session.consultationMode}",
                        style: textTheme.bodyText1),
                  ),
                  ReverseDetailsTile(
                    title: Text("Patient", style: textTheme.caption),
                    value: Text("${session.patientProfile?.fullName}",
                        style: textTheme.bodyText1),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TimeslotDetailsWidget(
                dateTime: session.date!,
                timeslots: session.clinicianTimeSlots!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
