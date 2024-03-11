import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/time_of_day.dart' as t;
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';

class TimeSlotsWidget extends StatefulWidget {
  final String clinicianId;

  const TimeSlotsWidget({super.key, required this.clinicianId});

  @override
  _TimeSlotsWidgetState createState() => _TimeSlotsWidgetState();
}

class _TimeSlotsWidgetState extends State<TimeSlotsWidget> {
  List<int> timeSlotIds = [];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);
    return FutureBuilder<List<t.TimeOfDay>>(
      future: sessionBloc.getClinicianAvailableTimeSlots(
        id: widget.clinicianId,
        query: {
          'date': Helper.formatDate(date: sessionBloc.selectedDate),
          'time': DateTime.now(),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }
        if (!snapshot.hasData) return const LoadingWidget();
        var timeOfDay = snapshot.data ?? [];
        if (timeOfDay.isEmpty) return const EmptyWidget();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var timeDay in timeOfDay) ...[
              if (timeDay.slots != null && timeDay.slots!.isNotEmpty) ...[
                Text(
                  timeDay.label!,
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
                    for (var timeSlot in timeDay.slots!) ...[
                      FilterChip(
                        label: Text('${timeSlot.startAt} - ${timeSlot.endAt}'),
                        labelStyle: textTheme.caption?.copyWith(
                          fontSize: 10,
                          color: timeSlotIds.contains(timeSlot.id)
                              ? Colors.white
                              : Colors.black,
                        ),
                        shape: const StadiumBorder(
                          side: BorderSide(color: MyColors.primaryColor),
                        ),
                        backgroundColor: Colors.white,
                        selected: timeSlotIds.contains(timeSlot.id),
                        selectedColor: MyColors.primaryColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onSelected: (value) {
                          if (timeSlotIds.contains(timeSlot.id)) {
                            timeSlotIds.remove(timeSlot.id);
                            sessionBloc.timeslots.remove(timeSlot.id);
                          } else {
                            timeSlotIds.add(timeSlot.id!);
                            sessionBloc.timeslots[timeSlot.id!] = timeSlot;
                          }

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
