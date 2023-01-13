import 'package:flutter/material.dart';

class TimeSlot extends StatefulWidget {
  @override
  _TimeSlotState createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Text("21"),
                Text(
                  "Dec",
                  style: textTheme.caption,
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Time Slot", style: textTheme.caption),
              SizedBox(height: 4),
              Text("4:30 PM - 06:00 PM", style: textTheme.subtitle1),
            ],
          )
        ],
      ),
    );
  }
}
