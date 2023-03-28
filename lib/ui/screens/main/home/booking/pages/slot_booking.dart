import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/mode_of_consultation.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/consultation_dialog.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/time_slots_widget.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/image_from_net.dart';
import '../../../../../widgets/loading_widget.dart';

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
            'Clinician Details',
            style: textTheme.caption?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageFromNet(
                  imageUrl: sessionBloc.selectedClinician?.imageUrl,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  height: 70,
                  width: 75,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DetailsTile(
                        title: Text(
                          sessionBloc.selectedClinician?.user?.fullName ??
                              ' NA',
                          style: textTheme.bodyText2,
                        ),
                        value: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sessionBloc.selectedClinician?.designation ??
                                    'NA',
                                style: textTheme.caption?.copyWith(
                                  color: MyColors.cerulean,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.paleBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${sessionBloc.selectedClinician?.experience} years Exp.',
                                  style: textTheme.subtitle2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mode of Consultation',
            style: textTheme.caption?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: (modeOfConsultation == null)
                ? DottedDecoration(
                    shape: Shape.box,
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: MyColors.divider),
                  ),
            child: GestureDetector(
              onTap: () async {
                modeOfConsultation = await ConsultationDialog.open(context);
                sessionBloc.setModeOfConsultation(
                  modeOfConsultation: modeOfConsultation,
                );
                widget.onTap(modeOfConsultation);
              },
              child: DetailsTile(
                gap: 6,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (modeOfConsultation == null)
                        ? Text(
                            'Select Consultation Mode',
                            style: textTheme.caption,
                          )
                        : Row(
                            children: [
                              ImageFromNet(
                                imageUrl: modeOfConsultation!.imageUrl,
                                height: 12,
                                width: 12,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${modeOfConsultation?.title}',
                                style: textTheme.bodyText2,
                              ),
                            ],
                          ),
                    Image.asset(Images.editIcon, width: 15, height: 15),
                  ],
                ),
                value: (modeOfConsultation == null)
                    ? const SizedBox()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: MyColors.paleBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${sessionBloc.selectedClinician?.experience} years Exp.',
                          style: textTheme.subtitle2,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<String>>(
            future: sessionBloc.getPatientSymptoms(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return CustomErrorWidget(error: snapshot.error);
              }

              if (!snapshot.hasData) return const LoadingWidget();

              var symptoms = snapshot.data ?? [];

              if (symptoms.isEmpty) return const EmptyWidget();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField(
                  hint: const Text("Select a Type"),
                  items: [
                    for (String symptom in symptoms)
                      DropdownMenuItem<String>(
                        value: symptom,
                        child: Text(Helper.textCapitalization(text: symptom)),
                      ),
                  ],
                  onChanged: (value) {
                    sessionBloc.type = value;
                    setState(() {});
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Select Date',
            style: textTheme.caption?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 8),
          buildCalendar(),
          const SizedBox(height: 16),
          Text(
            'Available Time Slots',
            style: textTheme.caption?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 16),
          const TimeSlotsWidget(),
          const SizedBox(height: 16),
          Text(
            'Description',
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
          var date = DateFormat('dd MMM')
              .format(currentDate.add(Duration(days: index)));
          var day =
              DateFormat('E').format(currentDate.add(Duration(days: index)));
          var dateString = DateFormat('yyyy-MM-dd')
              .format(currentDate.add(Duration(days: index)));
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
                        : MyColors.primaryColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: textTheme.caption?.copyWith(
                      color: textColor,
                    ),
                  ),
                  Text(
                    date,
                    style: textTheme.caption?.copyWith(
                      color: textColor,
                    ),
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
