import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/ui/screens/main/menu/reports/widgets/time_slot.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../widgets/avatar.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/image_from_net.dart';

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
    var body = {
      'clinic_id': sessionBloc?.selectedClinician?.toJson(),
      'patient_id': sessionBloc.selectedPatient?.toJson(),
      'mode_of_consultation': sessionBloc.selectedModeOfConsultation?.toJson(),
      'date': sessionBloc.selectedDate,
      'timsSlots': sessionBloc.selectedTimeSlotIds,
      'description': sessionBloc.description,
    };

    print('body: $body');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Patient Details',
                style: textTheme.caption?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Row(
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
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Clinician Details',
                style: textTheme.caption?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Row(
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
                                      borderRadius: BorderRadius.circular(10)),
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
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Session Details',
                style: textTheme.caption?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 16),
              DynamicGridView(
                count: 2,
                spacing: 0,
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
                  '${sessionBloc.description}',
                  style: textTheme.bodyText1,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Consultation Bill Details',
                  style: textTheme.caption?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 16),
                DynamicGridView(
                  spacing: 0,
                  count: 2,
                  children: [
                    ReverseDetailsTile(
                      title: const Text('Mode of Consultation'),
                      value: Text(
                        '2 slots - Video',
                        style: textTheme.bodyText1,
                      ),
                    ),
                    ReverseDetailsTile(
                      title: const Text('Consultation Fee'),
                      value: Text(
                        '200 Dirham',
                        style: textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Total Amount'),
                    Text('200 Dirham'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
