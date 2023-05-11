import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/clinicians.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../widgets/avatar.dart';

class ClinicianDetailsWidget extends StatelessWidget {
  final Clinician clinician;

  const ClinicianDetailsWidget({super.key, required this.clinician});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(
            url: clinician.imageUrl,
            name: clinician.user?.fullName,
            borderRadius: BorderRadius.circular(10),
            size: 72,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  clinician.user?.fullName ?? 'NA',
                  style: textTheme.bodyText2,
                ),
                Text(
                  clinician.designation ?? 'NA',
                  style: textTheme.caption?.copyWith(
                    color: MyColors.cerulean,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset(Images.voice, width: 12),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        clinician.languagesKnown ?? 'NA',
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
              '${clinician.experience} ${langBloc.getString(Strings.yearsExp)}',
              style: textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }
}
