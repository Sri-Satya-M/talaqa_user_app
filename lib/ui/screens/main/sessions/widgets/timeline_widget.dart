import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../../../../../model/timeline_model.dart';
import '../../../../../resources/images.dart';
import '../../../../widgets/details_tile.dart';

class TimelineWidget extends StatefulWidget {
  const TimelineWidget({
    super.key,
    required this.statuses,
  });

  final List<SessionStatus> statuses;

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  Map<String, Event> eventsMap = {
    "PENDING": Event("Session Pending"),
    "APPROVED": Event("Session Approved"),
    "PAID": Event("Payment completed"),
    "STARTED": Event("Session Started"),
    "COMPLETED": Event("Session Completed"),
    "SENT": Event("Report Sent"),
  };

  Widget getConnector(String? time) {
    if (time == null) {
      return const DashedLineConnector(color: Colors.grey);
    } else {
      return const SolidLineConnector(color: MyColors.primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    for (var status in widget.statuses) {
      var formateDate = DateFormat("dd MMM, yyyy a HH:Hm");
      eventsMap[status.status]?.time = formateDate.format(status.updatedAt!);
    }

    var eventsList = eventsMap.values.toList();

    return FixedTimeline.tileBuilder(
      theme: TimelineTheme.of(context).copyWith(
        nodePosition: 0,
        connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
              thickness: 2.0,
            ),
        indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
              size: 20.0,
            ),
      ),
      builder: TimelineTileBuilder(
        itemCount: eventsList.length,
        indicatorBuilder: (_, index) => SizedBox(
          height: 80.0,
          child: TimelineNode(
            indicator: Card(
              margin: EdgeInsets.zero,
              child: Image.asset(
                (eventsList[index].time == null)
                    ? Images.notDoneIcon
                    : Images.doneIcon,
                height: 50,
                width: 50,
              ),
            ),
            startConnector: getConnector(eventsList[index].time),
            endConnector: (index == eventsList.length - 1)
                ? null
                : getConnector(eventsList[index].time),
          ),
        ),
        itemExtentBuilder: (_, index) => 80,
        nodeItemOverlapBuilder: (_, index) =>
            (index != 0 || index != 5) ? true : null,
        contentsBuilder: (_, index) {
          return DetailsTile(
            padding: const EdgeInsets.only(left: 16, top: 16),
            title: Text(eventsList[index].title),
            value: Text(
              eventsList[index].time?.toString() ?? "",
              style: textTheme.caption,
            ),
          );
        },
      ),
    );
  }
}
