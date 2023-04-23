import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/model/time_of_day.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/strings.dart';
import '../../../../../../utils/helper.dart';

class TimeslotDetailsWidget extends StatelessWidget {
  final DateTime dateTime;
  final List<TimeSlot> timeslots;

  const TimeslotDetailsWidget({
    super.key,
    required this.dateTime,
    required this.timeslots,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return SizedBox(
      height: 75,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateTime.day.toString()),
                Text(
                  Helper.formatDate(date: dateTime, pattern: 'MMM'),
                  style: textTheme.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(langBloc.getString(Strings.timeSlot), style: textTheme.caption),
                const SizedBox(height: 4),
                for (var timeslot in timeslots)
                  Text(
                    "${timeslot.startAt} - ${timeslot.endAt}",
                    style: textTheme.subtitle1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
