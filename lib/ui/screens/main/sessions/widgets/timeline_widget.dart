import 'package:alsan_app/model/session.dart';
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
  Map<String, Event> events = {
    "PENDING": Event("Session Pending"),
    "APPROVED": Event("Session Approved"),
    "PAYMENT": Event("Payment completed"),
    "STARTED": Event("Session Started"),
    "COMPLETED": Event("Session Completed"),
    "SENT": Event("Report Sent"),
  };
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    for (SessionStatus status in widget.statuses) {
      var newFormat = DateFormat("dd MMM, yyyy at HH:Hm");
      events[status.status]?.time = newFormat.format(status.updatedAt!);
    }
    var values = events.values.toList();
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
        indicatorBuilder: (_, index) => (index == 0 || index == 5)
            ? (index != 5)
                ? SizedBox(
                    height: 100.0,
                    child: TimelineNode(
                      indicator: Card(
                        margin: EdgeInsets.zero,
                        child: (values[index].time == null)
                            ? Image.asset(
                                Images.notDoneIcon,
                                height: 50,
                                width: 50,
                              )
                            : Image.asset(
                                Images.doneIcon,
                                height: 50,
                                width: 50,
                              ),
                      ),
                      endConnector: (values[index].time == null)
                          ? const DashedLineConnector(
                              color: Colors.grey,
                            )
                          : const SolidLineConnector(),
                    ),
                  )
                : SizedBox(
                    height: 100.0,
                    child: TimelineNode(
                        indicator: Card(
                          margin: EdgeInsets.zero,
                          child: (values[index].time == null)
                              ? Image.asset(
                                  Images.notDoneIcon,
                                  height: 50,
                                  width: 50,
                                )
                              : Image.asset(
                                  Images.doneIcon,
                                  height: 50,
                                  width: 50,
                                ),
                        ),
                        startConnector: (values[index].time == null)
                            ? const DashedLineConnector(
                                color: Colors.grey,
                              )
                            : const SolidLineConnector()),
                  )
            : SizedBox(
                height: 100.0,
                child: TimelineNode(
                  indicator: Card(
                    margin: EdgeInsets.zero,
                    child: (values[index].time == null)
                        ? Image.asset(
                            Images.notDoneIcon,
                            height: 50,
                            width: 50,
                          )
                        : Image.asset(
                            Images.doneIcon,
                            height: 50,
                            width: 50,
                          ),
                  ),
                  startConnector: (values[index].time == null)
                      ? const DashedLineConnector(
                          color: Colors.grey,
                        )
                      : const SolidLineConnector(),
                  endConnector: (values[index].time == null)
                      ? const DashedLineConnector(
                          color: Colors.grey,
                        )
                      : const SolidLineConnector(),
                ),
              ),
        contentsBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: DetailsTile(
              title: Text(values[index].title),
              value: (values[index].time != null)
                  ? Text(
                      values[index].time.toString(),
                      style: textTheme.caption,
                    )
                  : Text(""),
            ),
          );
        },
        itemExtentBuilder: (_, index) =>
            100, //isEdgeIndex(index) ? 20.0 : 100.0,
        nodeItemOverlapBuilder: (_, index) =>
            (index != 0 || index != 5) ? true : null,
        itemCount: values.length,
      ),
    );
  }
}
