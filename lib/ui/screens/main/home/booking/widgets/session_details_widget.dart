import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/timeslot_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/colors.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: MyColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text('Session Details'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DynamicGridView(
                  count: 2,
                  spacing: 8,
                  children: [
                    ReverseDetailsTile(
                      title: const Text('Specialty'),
                      value: Text(
                        'Lorem',
                        style: textTheme.bodyText1,
                      ),
                    ),
                    ReverseDetailsTile(
                      title: const Text('Mode of consultation'),
                      value: Text(
                        '${sessionBloc.selectedModeOfConsultation?.type}',
                        style: textTheme.bodyText1,
                      ),
                    ),
                    ReverseDetailsTile(
                      title: const Text('Duration'),
                      value: Text(
                        'Lorem',
                        style: textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TimeslotDetailsWidget(
                  dateTime: sessionBloc.selectedDate!,
                  timeslots: sessionBloc.timeslots.values
                      .map((e) => "${e.startAt} - ${e.endAt}")
                      .toList(),
                ),
                const SizedBox(height: 8),
                ReverseDetailsTile(
                  title: const Text('Description'),
                  value: Text(
                    description!,
                    style: textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
