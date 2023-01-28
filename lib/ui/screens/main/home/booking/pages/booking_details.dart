import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/screens/main/menu/reports/widgets/time_slot.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/user_bloc.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../widgets/avatar.dart';
import '../../../../../widgets/details_tile.dart';

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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MyColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    'Patient Details',
                    style: textTheme.caption?.copyWith(color: Colors.black),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
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
                                sessionBloc.selectedPatient?.age?.toString() ??
                                    'NA',
                                style: textTheme.caption,
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                    sessionBloc.selectedPatient?.gender ?? 'NA',
                                    style: textTheme.subtitle2),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MyColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    'Clinician Details',
                    style: textTheme.caption?.copyWith(color: Colors.black),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Avatar(
                        url: sessionBloc.selectedClinician?.image,
                        name: sessionBloc.selectedClinician?.user?.fullName,
                        borderRadius: BorderRadius.circular(10),
                        size: 72,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DetailsTile(
                            title: Text(
                              sessionBloc.selectedClinician?.user?.fullName ??
                                  ' NA',
                              style: textTheme.bodyText2,
                            ),
                            value: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sessionBloc.selectedClinician?.designation ??
                                      'NA',
                                  style: textTheme.caption?.copyWith(
                                    color: MyColors.cerulean,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                          color: MyColors.paleBlue,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        '${sessionBloc.selectedClinician?.experience} years Exp.',
                                        style: textTheme.subtitle2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MyColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text('Session Details'),
                ),
                const Divider(),
                Padding(
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
                              'Lorem',
                              style: textTheme.bodyText1,
                            ),
                          ),
                          ReverseDetailsTile(
                            title: const Text('Mode of consultation'),
                            value: Text(
                              '${sessionBloc.selectedModeOfConsultation?.type}',
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
                      TimeSlot(),
                      const SizedBox(height: 8),
                      ReverseDetailsTile(
                        title: const Text('Description'),
                        value: Text(
                          description!,
                          style: textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
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
              if (response.containsKey('status') && response['status'] != null) {
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
