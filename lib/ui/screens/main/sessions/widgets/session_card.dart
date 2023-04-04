import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/timeslot_details_widget.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';

import '../../../../../model/session.dart';

class SessionCard extends StatefulWidget {
  final Session session;
  final VoidCallback onTap;

  const SessionCard({
    super.key,
    required this.onTap,
    required this.session,
  });

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return CustomCard(
      width: size.width * 0.85,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.session.sessionId}",
                    style: textTheme.headline4,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: getColor(widget.session.status),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    child: Text(
                      '${widget.session.status}',
                      style: textTheme.bodyText1?.copyWith(color: Colors.white),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Avatar(
                    url: widget.session.clinician?.imageUrl,
                    name: widget.session.clinician?.user?.fullName,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  const SizedBox(width: 8),
                  DetailsTile(
                    title: Text("${widget.session.clinician?.user?.fullName}"),
                    value: Text(
                      "${widget.session.clinician?.designation}",
                      style: textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DynamicGridView(
                spacing: 5,
                count: 2,
                children: [
                  DetailsTile(
                    title: Text("Experience", style: textTheme.caption),
                    value: Text(
                      "${widget.session.clinician?.experience} years exp",
                      style: textTheme.bodyText1,
                    ),
                  ),
                  ReverseDetailsTile(
                    title:
                        Text("Mode of consultation", style: textTheme.caption),
                    value: Text(
                      "${widget.session.consultationMode}",
                      style: textTheme.bodyText1,
                    ),
                  ),
                  ReverseDetailsTile(
                    title: Text("Patient", style: textTheme.caption),
                    value: Text("${widget.session.patientProfile?.fullName}",
                        style: textTheme.bodyText1),
                  ),
                  ReverseDetailsTile(
                    title: const Text('Type'),
                    value: Text(
                      widget.session.type.toString(),
                      style: textTheme.bodyText1,
                    ),
                  ),
                  if (widget.session.consultationMode == "HOME" &&
                      widget.session.status == 'PAID') ...[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              getOtp(widget.session),
                              style: textTheme.caption?.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              TimeslotDetailsWidget(
                dateTime: widget.session.date!,
                timeslots: widget.session.clinicianTimeSlots!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(String? status) {
    switch (status) {
      case "PENDING":
        return MyColors.pending;
      case "APPROVED":
        return MyColors.approved;
      case "PAID":
        return MyColors.paid;
      case "STARTED":
        return MyColors.started;
      case "COMPLETED":
        return MyColors.completed;
      case "REJECTED":
      case "CANCELLED":
        return MyColors.rejected;
      default:
        return MyColors.yellow;
    }
  }
}

String getOtp(Session session) {
  String otp =
      "Your Session\nOTP : ${(Helper.formatDate(date: session.date) == Helper.formatDate(date: DateTime.now())) ? session.otp.toString() : 'XXXX'}";
  return otp;
}
