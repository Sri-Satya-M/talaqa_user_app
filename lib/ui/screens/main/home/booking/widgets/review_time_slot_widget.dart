import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:flutter/material.dart';

import '../../../../../../model/time_of_day.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../utils/helper.dart';

class ReviewTimeSlotWidget extends StatelessWidget {
  final DateTime dateTime;
  final List<TimeSlot> timeslots;
  final String? duration;

  const ReviewTimeSlotWidget({
    super.key,
    required this.dateTime,
    required this.timeslots,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100 + (timeslots.length * 18),
      child: Row(
        children: [
          getCalendar(context),
          const SizedBox(width: 16),
          getDuration(context: context, time: timeslots.length),
        ],
      ),
    );
  }

  Widget getCalendar(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: MyColors.cementShade1,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: MyColors.deepBlue,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    Helper.formatDate(date: dateTime, pattern: 'dd E'),
                    style: textTheme.bodyText1?.copyWith(
                      color: MyColors.deepBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ReverseDetailsTile(
              title: const Text('TimeSlot'),
              value: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
      ),
    );
  }

  Widget getDuration({required BuildContext context, required int time}) {
    var textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: MyColors.divider,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
              child: Icon(Icons.timer_outlined, color: MyColors.deepBlue),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ReverseDetailsTile(
                    title: const Text('Duration'),
                    value: Text(
                      formatTime(),
                      style: textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  formatTime() {
    if (duration != null) return duration;
    var time = timeslots.length;
    return '$time ${time > 1 ? 'hrs' : 'hr'}';
  }
}
