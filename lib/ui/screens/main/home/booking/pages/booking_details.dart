import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/review_time_slot_widget.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/user_bloc.dart';
import '../../../../../../model/time_of_day.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../widgets/avatar.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var noOfSlots = sessionBloc.selectedTimeSlotIds!.length;
    var totalAmount = sessionBloc.selectedModeOfConsultation!.price! *
        sessionBloc.selectedTimeSlotIds!.length;
    var description =
        sessionBloc.description == null || sessionBloc.description!.isEmpty
            ? 'NA'
            : sessionBloc.description;

    var body = {
      'timeSlotIds': sessionBloc.selectedTimeSlotIds,
      'date': Helper.formatDate(date: sessionBloc.selectedDate),
      'day': Helper.formatDate(date: sessionBloc.selectedDate, pattern: 'EEEE'),
      'description': description,
      'consultationMode': sessionBloc.selectedModeOfConsultation!.type,
      'consultationFee': totalAmount,
      'patientId': userBloc.profile!.id,
      'patientProfileId': sessionBloc.selectedPatient!.id,
      'clinicianId': sessionBloc.selectedClinician!.id,
      'totalAmount': totalAmount,
      'patientAddressId': sessionBloc.selectedAddressId,
      'type': sessionBloc.symptom
    };

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Speech Therapy', style: textTheme.headline4),
              if (sessionBloc.selectedModeOfConsultation!.type == 'Home') ...[
                Row(
                  children: [
                    const Icon(Icons.home, color: Colors.lightBlue),
                    Text(
                      'At Home',
                      style: textTheme.bodyText1?.copyWith(
                        color: Colors.lightBlue,
                      ),
                    ),
                  ],
                )
              ],
            ],
          ),
          const SizedBox(height: 16),
          ReviewTimeSlotWidget(
            dateTime: sessionBloc.selectedDate!,
            timeslots: showTimeslots(
              sessionBloc.timeslots.values,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: MyColors.paleLightGreen,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClinicianDetailsWidget(
              clinician: sessionBloc.selectedClinician!,
            ),
          ),
          // const SessionDetailsWidget(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MyColors.cementShade2,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Consultation Bill Details', style: textTheme.bodyText1),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Consultation fee (${sessionBloc.timeslots.length} Slots video)',
                    ),
                    const Spacer(),
                    Text(
                        '${sessionBloc.selectedModeOfConsultation!.price! * sessionBloc.timeslots.length} Dihram'),
                  ],
                ),
                const SizedBox(height: 12),
                const DottedLine(dashGapLength: 4, dashColor: MyColors.divider),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Total Amount'),
                    const Spacer(),
                    Text(
                      '${sessionBloc.selectedModeOfConsultation!.price! * sessionBloc.timeslots.length} Dirham',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ReverseDetailsTile(
            title: const Text('Patient Details'),
            value: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: const BoxDecoration(
                color: MyColors.paleLightBlue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Avatar(
                    url: sessionBloc.selectedPatient?.image,
                    name: sessionBloc.selectedPatient?.fullName,
                    borderRadius: BorderRadius.circular(10),
                    size: 72,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sessionBloc.selectedPatient?.fullName ?? 'NA'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${sessionBloc.selectedPatient?.age?.toString()} years',
                            style: textTheme.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '${sessionBloc.selectedPatient?.city ?? 'NA'}, ',
                            style: textTheme.subtitle2,
                          ),
                          Text(
                            sessionBloc.selectedPatient?.country ?? 'NA',
                            style: textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          Helper.textCapitalization(
                            text: sessionBloc.selectedPatient?.gender,
                          ),
                          style: textTheme.subtitle2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ReverseDetailsTile(
            title: const Text('Symptoms'),
            value: Text('${sessionBloc.symptom}', style: textTheme.headline4),
          ),
          const SizedBox(height: 16),
          ReverseDetailsTile(
            title: const Text('Description'),
            value: Text(
              'Vivamus eget aliquam dui. Integer eu arcu vel arcu suscipit ultrices quis non mauris. Aenean scelerisque, sem eu dictum commodo.',
              style: textTheme.bodyText1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: MyColors.divider,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: MyColors.divider)),
            child: Row(
              children: [
                Image.asset(
                  Images.pdf,
                  width: 24,
                ),
                const SizedBox(width: 16),
                const Text('Medical Records'),
                const Spacer(),
                Image.asset(Images.download, height: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ProgressButton(
          //   onPressed: () async {
          //     print(body);
          //     var response = await sessionBloc.createSessions(body: body)
          //         as Map<String, dynamic>;
          //     if (response.containsKey('status') &&
          //         response['status'] != null) {
          //       SuccessScreen.open(
          //         context,
          //         type: '',
          //         message: response['message'],
          //       );
          //     }
          //   },
          //   child: const Text("Book Now"),
          // ),
        ],
      ),
    );
  }

  List<TimeSlot> showTimeslots(dynamic collection) {
    return Helper.sortByKey(
      collection: collection.map((c) => c.toMap()).toList(),
      key: 'startAt',
      obj: (json) => TimeSlot.fromMap(json),
    ).map((e) => e as TimeSlot).toList();
  }
}
