import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/time_of_day.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../../resources/strings.dart';
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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
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
                  SizedBox(
                    height: 30,
                    child: Image.asset(Images.calenderTime, width: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    Helper.formatDate(date: dateTime, pattern: 'dd E'),
                    style: textTheme.bodyLarge?.copyWith(
                      color: MyColors.deepBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ReverseDetailsTile(
              title: Text(langBloc.getString(Strings.timeSlot)),
              value: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var timeslot in timeslots)
                    Text(
                      "${timeslot.startAt} - ${timeslot.endAt}",
                      style: textTheme.titleMedium,
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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
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
            SizedBox(
              height: 30,
              child: Image.asset(Images.timer, width: 18),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ReverseDetailsTile(
                    title: Text(langBloc.getString(Strings.duration)),
                    value: Text(
                      formatTime(),
                      style: textTheme.bodyLarge,
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
