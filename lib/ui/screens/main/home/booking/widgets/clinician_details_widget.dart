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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
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
                  url: clinician.image,
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
                                    borderRadius: BorderRadius.circular(10)),
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
        ],
      ),
    );
  }
}
