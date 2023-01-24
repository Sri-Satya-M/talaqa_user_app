import 'package:alsan_app/model/mode_of_consultation.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/add_address.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/booking_details.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/select_profiles.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/slot_booking.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';

import '../../../../../model/clinicians.dart';
import '../../../../../model/profile.dart';
import '../widgets/clinician_list.dart';

class BookingScreen extends StatefulWidget {
  final Clinician clinician;

  const BookingScreen({super.key, required this.clinician});

  static Future open(BuildContext context, {required Clinician clinician}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingScreen(clinician: clinician),
      ),
    );
  }

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int pageIndex = 1;
  int steps = 4;
  List<String> titles = [
    'Clinician',
    'Select Profile',
    'Slot Booking',
    'Booking Details'
  ];

  late PageController controller;

  Clinician? selectedClinician;
  late Profile selectedPatient;

  ModeOfConsultation? selectedModeOfConsultation;
  DateTime? selectedDate;
  List<String>? selectedTimeSlot;
  String description = '';

  addExtraStep() {
    if (titles.length == 5) return;
    setState(() {
      steps += 1;
      titles.insert(3, 'Select Address');
    });
  }

  @override
  void initState() {
    selectedClinician = widget.clinician;
    selectedPatient = Profile();
    if (selectedClinician?.id != null) {
      pageIndex = 2;
    }
    controller = PageController(initialPage: pageIndex - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: MyColors.bookingBgColor,
      appBar: AppBar(
        title: const Text('Book Session'),
        actions: [
          TextButton(
            onPressed: () async {
              if (pageIndex < steps) {
                pageIndex += 1;
                controller.animateToPage(
                  pageIndex - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
                setState(() {});
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Expanded(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 1; i <= steps; i++) getPageIndex(i),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        titles[pageIndex - 1],
                        style: textTheme.headline4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index + 1;
                });
              },
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: ClinicianList(
                    scrollDirection: Axis.vertical,
                    onTap: (clinician) {
                      selectedClinician = clinician;
                      pageIndex += 1;
                      controller.animateToPage(
                        pageIndex - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: SelectPatientProfile(
                    onTap: (Profile profile) {
                      selectedPatient = profile;
                    },
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: SlotBooking(
                    clinician: selectedClinician!,
                    onTap: (value) {
                      selectedModeOfConsultation = value;
                      if (selectedModeOfConsultation != null) {
                        addExtraStep();
                        setState(() {});
                      }
                    },
                  ),
                ),
                if (selectedModeOfConsultation?.type == 'HOME')
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: AddAddress(),
                  ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: BookingDetailsScreen(
                    selectedClinician: selectedClinician!,
                    selectedPatient: selectedPatient,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPageIndex(int value) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return DetailsTile(
      gap: 10,
      title: (pageIndex >= value)
          ? Container(
              height: 26,
              width: (size.width / steps) - 20,
              alignment: Alignment.center,
              child: const Icon(
                Icons.check_circle,
                color: MyColors.primaryColor,
                size: 29,
              ),
            )
          : Container(
              height: 26,
              width: (size.width / steps) - 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.cerulean),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$value',
                style: textTheme.button?.copyWith(
                  color: MyColors.cerulean,
                ),
              ),
            ),
      value: Container(
        height: 4,
        width: (size.width / steps) - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: (pageIndex >= value) ? MyColors.cerulean : Colors.grey[300],
        ),
      ),
    );
  }
}
