import 'package:alsan_app/ui/screens/main/home/booking/widgets/details_box.dart';
import 'package:flutter/material.dart';

import '../../../../../../model/clinicians.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../widgets/avatar.dart';
import '../../../../../widgets/details_tile.dart';

class ClinicianDetailsWidget extends StatelessWidget {
  final Clinician clinician;

  const ClinicianDetailsWidget({super.key, required this.clinician});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return DetailsBox(
      title: 'Clinician Details',
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Avatar(
              url: clinician.imageUrl,
              name: clinician.user?.fullName,
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
                    clinician.user?.fullName ?? ' NA',
                    style: textTheme.bodyText2,
                  ),
                  value: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinician.designation ?? 'NA',
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${clinician.experience} years Exp.',
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
    );
  }
}
