import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/mode_of_consultation.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/booking/pages/booking_details.dart';
import 'package:alsan_app/ui/screens/main/home/booking/pages/select_clinician.dart';
import 'package:alsan_app/ui/screens/main/home/booking/pages/select_profiles.dart';
import 'package:alsan_app/ui/screens/main/home/booking/pages/slot_booking.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/add_address.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/symptom_mode_of_consultation.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:alsan_app/ui/widgets/error_snackbar.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/user_bloc.dart';
import '../../../../../model/clinicians.dart';
import '../../../../../model/profile.dart';
import '../../../../../resources/strings.dart';
import '../../../../../utils/helper.dart';
import '../../../../widgets/success_screen.dart';

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
  int steps = 5;
  List<String> titles = [];

  late PageController controller;

  initializeTitles() {
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    titles = [
      langBloc.getString(Strings.symptomAndModeOfConsultation),
      langBloc.getString(Strings.selectProfile),
      langBloc.getString(Strings.slotBooking),
      langBloc.getString(Strings.clinician),
      langBloc.getString(Strings.review),
    ];
  }

  addExtraStep() {
    if (titles.length == 6) return;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    setState(() {
      steps += 1;
      titles.insert(4, langBloc.getString(Strings.selectAddress));
    });
  }

  removeExtraStep() {
    if (titles.length <= 5) return;
    setState(() {
      steps -= 1;
      titles.removeAt(3);
    });
  }

  @override
  void initState() {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    sessionBloc.clear();
    sessionBloc.selectedClinician = widget.clinician;
    sessionBloc.selectedDate = DateTime.now();
    sessionBloc.selectedPatient = Profile();
    controller = PageController(initialPage: pageIndex - 1);
    initializeTitles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      backgroundColor: MyColors.bookingBgColor,
      appBar: AppBar(title: Text(langBloc.getString(Strings.bookSession))),
      body: Column(
        children: [
          const SizedBox(height: 16),
          buildSteps(),
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
                SymptomModeOfConsultation(
                  onTap: (ModeOfConsultation mode) {
                    if (mode != null) {
                      if (mode.type == 'HOME') {
                        addExtraStep();
                      } else {
                        removeExtraStep();
                      }
                      setState(() {});
                    }
                  },
                ),
                SelectPatientProfile(
                  onTap: (Profile profile) {
                    sessionBloc.selectedPatient = profile;
                  },
                ),
                SlotBooking(
                  onTap: (ModeOfConsultation value) {
                    if (value != null) {
                      if (value.type == 'HOME') {
                        addExtraStep();
                      } else {
                        removeExtraStep();
                      }
                      setState(() {});
                    }
                  },
                ),
                SelectClinician(
                  onTap: (clinician) {
                    sessionBloc.selectedClinician = clinician;
                    animateToNextPage();
                  },
                ),
                if (sessionBloc.selectedModeOfConsultation?.type == 'HOME') ...[
                  const AddAddress(),
                ],
                const BookingDetailsScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 75,
        color: MyColors.cement,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (sessionBloc.selectedModeOfConsultation != null &&
                sessionBloc.timeslots.length > 0)
              ReverseDetailsTile(
                title: Text(langBloc.getString(Strings.totalCharges)),
                value: Text(
                    ' د.إ  ${sessionBloc.selectedModeOfConsultation!.price! * sessionBloc.timeslots.length}'),
              ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                maximumSize: const Size(150, 50),
              ),
              onPressed: (pageIndex == titles.length) ? bookNow : validateStep,
              child: Text((pageIndex == titles.length)
                  ? langBloc.getString(Strings.bookNow)
                  : langBloc.getString(Strings.next)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSteps() {
    var textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 100,
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
                border: Border.all(color: MyColors.primaryColor),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$value',
                style: textTheme.button?.copyWith(
                  color: MyColors.primaryColor,
                ),
              ),
            ),
      value: Container(
        height: 4,
        width: (size.width / steps) - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color:
              (pageIndex >= value) ? MyColors.primaryColor : Colors.grey[300],
        ),
      ),
    );
  }

  animateToNextPage() {
    pageIndex += 1;
    controller.animateToPage(
      pageIndex - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    setState(() {});
  }

  validateStep() {
    var msg = 'Please select all the fields';
    var flag = false;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    switch (pageIndex) {
      case 1:
        if (sessionBloc.symptom == null ||
            sessionBloc.selectedModeOfConsultation == null) {
          flag = true;
          msg = 'Please select a Symptom & Mode of Consultation';
        }
        break;

      case 2:
        if (sessionBloc.selectedPatient?.id == null) {
          flag = true;
          msg = 'Please select a patient';
        }
        break;
      case 3:
        if (sessionBloc.selectedDate == null ||
            sessionBloc.selectedTimeSlotIds == null ||
            sessionBloc.selectedTimeSlotIds!.isEmpty) {
          flag = true;
          msg = 'Please select Date & Time slot';
        }
        break;
      case 4:
        if (sessionBloc.selectedClinician?.id == null) {
          flag = true;
          msg = 'Please select a clinician';
        }
        break;

      case 5:
        if (sessionBloc.selectedAddressId == null) {
          flag = true;
          msg = 'Please select an address';
        }
        break;
      default:
        return;
    }

    if (flag == true) {
      return ErrorSnackBar.show(context, msg);
    }

    if (pageIndex < steps) {
      animateToNextPage();
    }
  }

  bookNow() async {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var description =
        sessionBloc.description == null || sessionBloc.description!.isEmpty
            ? 'NA'
            : sessionBloc.description;

    var body = {
      'timeslotIds': sessionBloc.selectedTimeSlotIds,
      'date': Helper.formatDate(date: sessionBloc.selectedDate),
      'description': description,
      'consultationMode': sessionBloc.selectedModeOfConsultation!.type,
      'patientId': userBloc.profile!.id,
      'patientProfileId': sessionBloc.selectedPatient!.id,
      'clinicianId': sessionBloc.selectedClinician!.id,
      'type': sessionBloc.symptom
    };

    if (sessionBloc.selectedAddressId != null) {
      body['patientAddressId'] = sessionBloc.selectedAddressId!;
    }

    print(body);

    var response =
        await sessionBloc.createSessions(body: body) as Map<String, dynamic>;
    if (response.containsKey('status') && response['status'] != null) {
      SuccessScreen.open(
        context,
        type: '',
        message: response['message'],
      );
    }
  }
}
