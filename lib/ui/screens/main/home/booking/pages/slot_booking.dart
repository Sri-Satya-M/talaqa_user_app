import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/mode_of_consultation.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/time_slots_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';

class SlotBooking extends StatefulWidget {
  final Function onTap;

  const SlotBooking({super.key, required this.onTap});

  @override
  _SlotBookingState createState() => _SlotBookingState();
}

class _SlotBookingState extends State<SlotBooking> {
  String? selectDate;
  ModeOfConsultation? modeOfConsultation;
  var currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        children: [
          Text(
            langBloc.getString(Strings.selectDate),
            style: textTheme.caption?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 8),
          buildCalendar(),
          const SizedBox(height: 16),
          Text(
          langBloc.getString(Strings.availableTimeSlots),
            style: textTheme.caption?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 16),
          const TimeSlotsWidget(),
          const SizedBox(height: 16),
          Text(
            langBloc.getString(Strings.description),
            style: textTheme.caption?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: MyColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: MyColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: MyColors.cerulean),
              ),
            ),
            minLines: 3,
            maxLines: 10,
            onChanged: (value) {
              sessionBloc.description = value;
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  getColor(String day, String dateString) {
    if (day == 'Sun') {
      return Colors.grey.withOpacity(0.4);
    } else if (DateFormat('yyyy-MM-dd').format(selectedDate) == dateString) {
      return MyColors.primaryColor;
    } else {
      return Colors.transparent;
    }
  }

  getTextColor(String day, String dateString) {
    if (DateFormat('yyyy-MM-dd').format(selectedDate) == dateString ||
        day == 'Sun') {
      return Colors.white;
    } else {
      return MyColors.primaryColor;
    }
  }

  Widget buildCalendar() {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var date = DateFormat('dd MMM').format(
            currentDate.add(Duration(days: index)),
          );

          var day = DateFormat('E').format(
            currentDate.add(Duration(days: index)),
          );

          var dateString = DateFormat('yyyy-MM-dd').format(
            currentDate.add(Duration(days: index)),
          );

          var textColor = getTextColor(day, dateString);

          return GestureDetector(
            onTap: () {
              if (day == "Sun") return;
              sessionBloc.setDate(date: currentDate.add(Duration(days: index)));
              selectedDate = currentDate.add(Duration(days: index));
            },
            child: Container(
              height: 80,
              width: 70,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: (day == 'Sun')
                    ? Colors.grey.withOpacity(0.4)
                    : getColor(day, dateString),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (day == 'Sun')
                      ? Colors.grey.withOpacity(0.4)
                      : MyColors.primaryColor,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: textTheme.caption?.copyWith(color: textColor),
                  ),
                  Text(
                    date,
                    style: textTheme.caption?.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
