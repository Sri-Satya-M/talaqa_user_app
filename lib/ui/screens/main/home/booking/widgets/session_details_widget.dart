import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/time_of_day.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/details_box.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/timeslot_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/strings.dart';
import '../../../../../../utils/helper.dart';
import '../../../../../widgets/dynamic_grid_view.dart';
import '../../../../../widgets/reverse_details_tile.dart';

class SessionDetailsWidget extends StatelessWidget {
  const SessionDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var description =
        sessionBloc.description == null || sessionBloc.description!.isEmpty
            ? 'NA'
            : sessionBloc.description;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return DetailsBox(
      title: langBloc.getString(Strings.sessionDetails),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DynamicGridView(
              count: 2,
              spacing: 8,
              children: [
                ReverseDetailsTile(
                  title: Text(langBloc.getString(Strings.speciality)),
                  value: Text(
                    '${sessionBloc.selectedClinician?.designation}',
                    style: textTheme.bodyLarge,
                  ),
                ),
                ReverseDetailsTile(
                  title: Text(langBloc.getString(Strings.modeOfConsultation)),
                  value: Text(
                    '${sessionBloc.selectedModeOfConsultation?.type}',
                    style: textTheme.bodyLarge,
                  ),
                ),
                ReverseDetailsTile(
                  title: Text(langBloc.getString(Strings.duration)),
                  value: Text(
                    '01:00 hrs',
                    style: textTheme.bodyLarge,
                  ),
                ),
                ReverseDetailsTile(
                  title: Text(langBloc.getString(Strings.type)),
                  value: Text(
                    sessionBloc.symptom.toString(),
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TimeslotDetailsWidget(
              dateTime: sessionBloc.selectedDate!,
              timeslots: showTimeslots(
                sessionBloc.timeslots.values,
              ),
            ),
            const SizedBox(height: 8),
            ReverseDetailsTile(
              title: Text(langBloc.getString(Strings.description)),
              value: Text(
                description!,
                style: textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TimeSlot> showTimeslots(dynamic collection) {
    return Helper.sortByKey(
      collection: collection.map((c) => c.toMap()).toList(),
      key: 'startAt',
      obj: (json) => TimeSlot.fromJson(json),
    ).map((e) => e as TimeSlot).toList();
  }
}
