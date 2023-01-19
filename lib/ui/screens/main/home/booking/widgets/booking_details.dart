import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/ui/screens/main/menu/reports/widgets/time_slot.dart';
import 'package:alsan_app/ui/widgets/dynamic_grid_view.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:flutter/material.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../widgets/avatar.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/image_from_net.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Clinician selectedClinician;
  final Profile selectedPatient;

  const BookingDetailsScreen({
    super.key,
    required this.selectedClinician,
    required this.selectedPatient,
  });

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
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
                    url: widget.selectedPatient.image,
                    name: widget.selectedPatient.fullName,
                    borderRadius: BorderRadius.circular(10),
                    size: 72,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.selectedPatient.fullName ?? 'NA'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            widget.selectedPatient.age?.toString() ?? 'NA',
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
                            child: Text(widget.selectedPatient.gender ?? 'NA',
                                style: textTheme.subtitle2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '${widget.selectedPatient.city ?? 'NA'}, ',
                            style: textTheme.subtitle2,
                          ),
                          Text(
                            widget.selectedPatient.country ?? 'NA',
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
                  ImageFromNet(
                    imageUrl: widget.selectedClinician.image,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    height: 75,
                    width: 75,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DetailsTile(
                        title: Text(
                          widget.selectedClinician.user?.fullName ?? ' NA',
                          style: textTheme.bodyText2,
                        ),
                        value: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectedClinician.designation ?? 'NA',
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
                                    '${widget.selectedClinician.experience} years Exp.',
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
                      'Lorem',
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
                  'Vivamus eget aliquam dui. Integer eu arcu vel arcu suscipit ultrices quis non mauris. Aenean scelerisque, sem eu dictum commodo, velit nisi blandit magna, quis scelerisque ipsum lectus ut libero. Sed elit diam, dignissim ac congue quis, aliquam in purus. Proin ligula nulla, scelerisque quis venenatis pulvinar, congue eget neque. Proin scelerisque metus sit amet dolor tempor vehicula. Sed laoreet quis velit vitae facilisis. Duis ut sapien eu urna laoreet maximus.',
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
