import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/bill_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/patient_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/review_time_slot_widget.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/user_bloc.dart';
import '../../../../../../model/time_of_day.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';

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
            timeslots: showTimeslots(sessionBloc.timeslots.values),
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
          BillDetailsWidget(
            noOfTimeslots: sessionBloc.timeslots.length,
            totalAmount: (sessionBloc.selectedModeOfConsultation!.price! *
                    sessionBloc.timeslots.length)
                .toDouble(),
            consultationMode: Helper.textCapitalization(
              text: sessionBloc.selectedModeOfConsultation!.title,
            ),
          ),
          const SizedBox(height: 16),
          ReverseDetailsTile(
            title: const Text('Patient Details'),
            value: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: const BoxDecoration(
                color: MyColors.paleLightBlue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: PatientDetailsWidget(
                patient: sessionBloc.selectedPatient!,
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
          if (sessionBloc.selectedPatient?.medicalRecords != null &&
              sessionBloc.selectedPatient!.medicalRecords!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyColors.divider,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: MyColors.divider),
              ),
              child: Row(
                children: [
                  Image.asset(Images.pdf, width: 24),
                  const SizedBox(width: 16),
                  Text(
                    '(${sessionBloc.selectedPatient!.medicalRecords!.length}) Medical Records',
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<TimeSlot> showTimeslots(dynamic collection) {
    return Helper.sortByKey(
      collection: collection.map((c) => c.toJson()).toList(),
      key: 'startAt',
      obj: (json) => TimeSlot.fromJson(json),
    ).map((e) => e as TimeSlot).toList();
  }
}
