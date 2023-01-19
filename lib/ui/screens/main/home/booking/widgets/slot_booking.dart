import 'package:alsan_app/ui/screens/main/home/booking/widgets/consultation_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../../../model/clinicians.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../widgets/details_tile.dart';
import '../../../../../widgets/image_from_net.dart';

class SlotBooking extends StatefulWidget {
  final Clinician clinician;

  const SlotBooking({super.key, required this.clinician});

  @override
  _SlotBookingState createState() => _SlotBookingState();
}

class _SlotBookingState extends State<SlotBooking> {
  String? selectDate;

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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColors.divider),
          ),
          child: DetailsTile(
            gap: 6,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Video Call Consultation',
                  style: textTheme.bodyText2,
                ),
                GestureDetector(
                  onTap: () async{
                    var result = await ConsultationDialog.open(context);
                  },
                  child: Image.asset(
                    Images.editIcon,
                    width: 15,
                    height: 15,
                  ),
                ),
              ],
            ),
            value: Container(
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
            itemCount: 10,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                height: 80,
                width: 70,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Today',
                      style: textTheme.caption?.copyWith(color: Colors.white),
                    ),
                    Text(
                      '16 Dec',
                      style: textTheme.caption?.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Avaiable',
                      style: textTheme.caption
                          ?.copyWith(fontSize: 10, color: Colors.white),
                    ),
                  ],
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
        SizedBox(height: 8),
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
              borderSide: BorderSide(
                color: MyColors.divider,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: MyColors.divider,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: MyColors.cerulean,
              ),
            ),
          ),
          minLines: 3,
          maxLines: 10,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
