import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/patient_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/session_details_widget.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/user_bloc.dart';
import '../../../../../../resources/colors.dart';

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
    };

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PatientDetailsWidget(patient: sessionBloc.selectedPatient!),
          ClinicianDetailsWidget(clinician: sessionBloc.selectedClinician!),
          const SessionDetailsWidget(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: MyColors.divider.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Consultation Bill Details"),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Consultation fee (${noOfSlots} Slots) Fee",
                        style: textTheme.subtitle2
                            ?.copyWith(color: Colors.black.withOpacity(1)),
                      ),
                      Text(
                        "$totalAmount Dirham",
                        style: textTheme.subtitle2
                            ?.copyWith(color: Colors.black.withOpacity(1)),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount"),
                      Text("$totalAmount Dirham")
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          ProgressButton(
            onPressed: () async {
              var response = await sessionBloc.createSessions(body: body)
                  as Map<String, dynamic>;
              if (response.containsKey('status') &&
                  response['status'] != null) {
                SuccessScreen.open(
                  context,
                  type: '',
                  message: response['message'],
                );
              }
            },
            child: const Text("Book Now"),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
