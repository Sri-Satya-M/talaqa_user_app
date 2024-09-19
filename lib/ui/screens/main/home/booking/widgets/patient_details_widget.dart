import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/strings.dart';
import '../../../../../widgets/avatar.dart';

class PatientDetailsWidget extends StatelessWidget {
  final Profile patient;

  const PatientDetailsWidget({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Avatar(
            url: patient.imageUrl,
            name: patient.fullName,
            borderRadius: BorderRadius.circular(10),
            size: 72,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patient.fullName ?? 'NA', style: textTheme.bodyMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      patient.age?.toString() ?? 'NA',
                      style: textTheme.bodySmall,
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
                        patient.gender?.toCapitalized() == 'MALE'
                            ? langBloc.getString(Strings.male)
                            : patient.gender?.toCapitalized() == 'FEMALE'
                                ? langBloc.getString(Strings.female)
                                : langBloc.getString(Strings.other),
                        style: textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${patient.city ?? 'NA'},\n${patient.state ?? 'NA'},\n${patient.country ?? 'NA'}',
                  style: textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
