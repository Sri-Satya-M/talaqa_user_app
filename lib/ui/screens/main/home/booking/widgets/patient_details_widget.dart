import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/details_box.dart';
import 'package:flutter/material.dart';

import '../../../../../widgets/avatar.dart';

class PatientDetailsWidget extends StatelessWidget {
  final Profile patient;

  const PatientDetailsWidget({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return DetailsBox(
      title: 'Patient Details',
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Avatar(
              url: patient.image,
              name: patient.fullName,
              borderRadius: BorderRadius.circular(10),
              size: 72,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patient.fullName ?? 'NA'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      patient.age?.toString() ?? 'NA',
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
                      child: Text(patient.gender ?? 'NA',
                          style: textTheme.subtitle2),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${patient.city ?? 'NA'}, ',
                      style: textTheme.subtitle2,
                    ),
                    Text(
                      patient.country ?? 'NA',
                      style: textTheme.subtitle2,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
