import 'package:alsan_app/ui/screens/main/home/booking/widgets/consultation_dialog.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../model/clinicians.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/image_from_net.dart';

class SlotBooking extends StatefulWidget {
  final Clinician clinician;
  final Function onTap;

  const SlotBooking({super.key, required this.clinician, required this.onTap});

  @override
  _SlotBookingState createState() => _SlotBookingState();
}

class _SlotBookingState extends State<SlotBooking> {
  String? selectDate;
  String? modeOfConsultation;
  var currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
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
                imageUrl: widget.clinician.image,
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
                        widget.clinician.user?.fullName ?? ' NA',
                        style: textTheme.bodyText2,
                      ),
                      value: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.clinician.designation ?? 'NA',
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
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                '${widget.clinician.experience} years Exp.',
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
          child: DetailsTile(
            gap: 6,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (modeOfConsultation == null)
                    ? Text('Select Consultation Mode',style: textTheme.caption,)
                    : Text(
                        'Video Call Consultation',
                        style: textTheme.bodyText2,
                      ),
                GestureDetector(
                  onTap: () async {
                    modeOfConsultation = await ConsultationDialog.open(context);
                    widget.onTap(modeOfConsultation);
                  },
                  child: Image.asset(Images.editIcon, width: 15, height: 15),
                ),
              ],
            ),
            value: (modeOfConsultation == null)
                ? SizedBox()
                : Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                        color: MyColors.paleBlue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '${widget.clinician.experience} years Exp.',
                      style: textTheme.subtitle2,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Select Date',
          style: textTheme.caption?.copyWith(color: Colors.black),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            itemCount: 7,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var date = DateFormat('dd MMM')
                  .format(currentDate.add(Duration(days: index)));
              var day = DateFormat('E')
                  .format(currentDate.add(Duration(days: index)));
              var dateString = DateFormat('yyyy-MM-dd')
                  .format(currentDate.add(Duration(days: index)));
              var textColor = getTextColor(day, dateString);
              return GestureDetector(
                onTap: () {
                  if (day == "Sun") return;
                  selectedDate = currentDate.add(Duration(days: index));
                  setState(() {});
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
                      Text(
                        'Available',
                        style: textTheme.caption?.copyWith(
                          fontSize: 10,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Available Time Slots',
          style: textTheme.caption?.copyWith(color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          'Morning',
          style: textTheme.caption?.copyWith(
            color: Colors.black.withOpacity(0.5),
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 30,
          child: ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return ChoiceChip(
                labelStyle: textTheme.caption?.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('10:00 AM - 11:00 AM'),
                    SizedBox(height: 8),
                    Icon(
                      Icons.check,
                      size: 15,
                      color: Colors.white,
                    )
                  ],
                ),
                selected: false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            },
          ),
        ),
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
        ),
        const SizedBox(height: 32),
      ],
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
}
