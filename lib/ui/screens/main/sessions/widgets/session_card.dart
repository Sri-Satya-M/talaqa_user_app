import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/timeslot_details_widget.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/session.dart';
import '../../../../../resources/strings.dart';

class SessionCard extends StatefulWidget {
  final Session session;
  final VoidCallback onTap;

  const SessionCard({super.key, required this.onTap, required this.session});

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return CustomCard(
      width: size.width * 0.9,
      radius: 5,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.session.sessionId}",
                    style: textTheme.headlineMedium,
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
                      Helper.textCapitalization(
                        text: widget.session.status!.split('_').join(' '),
                      ),
                      style: textTheme.bodyLarge?.copyWith(color: Colors.white),
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
                      style: textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DynamicGridView(
                spacing: 16,
                count: 2,
                children: [
                  DetailsTile(
                    title: Text(
                      langBloc.getString(Strings.experience),
                      style: textTheme.bodySmall,
                    ),
                    value: Text(
                      "${widget.session.clinician?.experience} years exp",
                      style: textTheme.bodyLarge,
                    ),
                  ),
                  ReverseDetailsTile(
                    title: Text(
                      langBloc.getString(Strings.modeOfConsultation),
                      style: textTheme.bodySmall,
                    ),
                    value: Text(
                      "${widget.session.consultationMode}",
                      style: textTheme.bodyLarge,
                    ),
                  ),
                  ReverseDetailsTile(
                    title: Text(
                      langBloc.getString(Strings.patient),
                      style: textTheme.bodySmall,
                    ),
                    value: Text("${widget.session.patientProfile?.fullName}",
                        style: textTheme.bodyLarge),
                  ),
                  ReverseDetailsTile(
                    title: Text(langBloc.getString(Strings.type)),
                    value: Text(
                      widget.session.symptom ?? 'NA',
                      style: textTheme.bodyLarge!,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
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
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              getOtp(widget.session),
                              style: textTheme.bodySmall?.copyWith(
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
                timeslots: widget.session.sessionTimeslots!
                    .map((e) => e.timeslot!)
                    .toList(),
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
