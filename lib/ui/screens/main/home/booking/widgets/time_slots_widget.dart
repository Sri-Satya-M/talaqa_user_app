import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/time_of_day.dart' as t;
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';

class TimeSlotsWidget extends StatefulWidget {
  const TimeSlotsWidget({super.key});

  @override
  _TimeSlotsWidgetState createState() => _TimeSlotsWidgetState();
}

class _TimeSlotsWidgetState extends State<TimeSlotsWidget> {
  List<int> timeSlotIds = [];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);
    return FutureBuilder<t.TimeOfDay>(
      future: sessionBloc.getTimeSlots(
        id: sessionBloc.selectedClinician!.id.toString(),
        query: {
          'date': Helper.formatDate(date: sessionBloc.selectedDate),
          'day': Helper.formatDate(date: sessionBloc.selectedDate, pattern: 'EEEE'),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }
        if (!snapshot.hasData) return const LoadingWidget();

        var timeOfDay = snapshot.data;
        var list = [
          timeOfDay?.morning,
          timeOfDay?.afternoon,
          timeOfDay?.evening,
          timeOfDay?.night
        ];
        list = list.where((element) => element != null).toList();
        if (list.isEmpty) return const EmptyWidget();
        // return Container();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var timeDay in list) ...[
              if (timeDay != null && timeDay.isNotEmpty) ...[
                Text(
                  timeDay.first.label!,
                  style: textTheme.caption?.copyWith(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  runSpacing: 4,
                  spacing: 4,
                  children: [
                    for (var timeSlot in timeDay) ...[
                      ChoiceChip(
                        labelStyle: textTheme.caption?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        label: Text('${timeSlot.startAt} - ${timeSlot.endAt}'),
                        selected: timeSlotIds.contains(timeSlot.id),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onSelected: (value) {
                          timeSlotIds.contains(timeSlot.id)
                              ? timeSlotIds.remove(timeSlot.id)
                              : timeSlotIds.add(timeSlot.id!);
                          sessionBloc.selectedTimeSlotIds = timeSlotIds;
                          setState(() {});
                        },
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],
          ],
        );
      },
    );
  }
}
