import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/bill_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/patient_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/review_time_slot_widget.dart';
import 'package:alsan_app/ui/widgets/reverse_details_tile.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/time_of_day.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/images.dart';
import '../../../../../../resources/strings.dart';
import '../../../sessions/widgets/address_card.dart';
import '../widgets/service_card.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: true);
    var langBloc = Provider.of<LangBloc>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                langBloc.getString(Strings.speechTherapy),
                style: textTheme.headlineMedium,
              ),
              getModeOfConsultation(
                mode: sessionBloc.selectedModeOfConsultation?.type ?? '',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (sessionBloc.selectedDate != null &&
              sessionBloc.timeslots.isNotEmpty)
            ReviewTimeSlotWidget(
              dateTime: sessionBloc.selectedDate!,
              timeslots: sessionBloc.timeslots.values.toList(),
            )
          else
            SizedBox(),
          if (sessionBloc.service != null)
            ServiceCard(service: sessionBloc.service!)
          else
            SizedBox(),
          const SizedBox(height: 16),
          if (sessionBloc.selectedClinician != null)
            Container(
              decoration: BoxDecoration(
                color: MyColors.paleLightGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClinicianDetailsWidget(
                clinician: sessionBloc.selectedClinician!,
              ),
            )
          else
            SizedBox(),
          // const SessionDetailsWidget(),
          const SizedBox(height: 16),
          BillDetailsWidget(
            noOfTimeslots: sessionBloc.timeslots.length,
            totalAmount: (sessionBloc.selectedModeOfConsultation!.price! *
                    sessionBloc.timeslots.length)
                .toDouble(),
            consultationMode: Helper.textCapitalization(
              text: sessionBloc.selectedModeOfConsultation!.title,
            ),
          ),
          const SizedBox(height: 16),
          ReverseDetailsTile(
            title: Text(langBloc.getString(Strings.patientDetails)),
            value: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: const BoxDecoration(
                color: MyColors.paleLightBlue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: PatientDetailsWidget(
                patient: sessionBloc.selectedPatient!,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (sessionBloc.selectedModeOfConsultation?.type == 'HOME') ...[
            AddressCard(
              address: sessionBloc.selectedAddress!,
              onTap: () async {},
              suffixIcon: Icons.directions,
              suffixIconColor: MyColors.primaryColor,
            ),
          ],
          const SizedBox(height: 16),
          if (sessionBloc.symptom != null) ...[
            ReverseDetailsTile(
              title: Text(langBloc.getString(Strings.symptoms)),
              value: Text('${sessionBloc.symptom}', style: textTheme.headlineMedium),
            ),
          ],
          const SizedBox(height: 16),
          ReverseDetailsTile(
            title: Text(langBloc.getString(Strings.description)),
            value: Text(
              'Vivamus eget aliquam dui. Integer eu arcu vel arcu suscipit ultrices quis non mauris. Aenean scelerisque, sem eu dictum commodo.',
              style: textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 16),
          if (sessionBloc.selectedPatient?.medicalRecords != null &&
              sessionBloc.selectedPatient!.medicalRecords!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyColors.divider,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: MyColors.divider),
              ),
              child: Row(
                children: [
                  Image.asset(Images.pdf, width: 24),
                  const SizedBox(width: 16),
                  Text(
                    '(${sessionBloc.selectedPatient!.medicalRecords!.length}) ${langBloc.getString(Strings.medicalRecords)}',
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<TimeSlot> showTimeslots(dynamic collection) {
    return Helper.sortByKey(
      collection: collection.map((c) => c.toJson()).toList(),
      key: 'startAt',
      obj: (json) => TimeSlot.fromJson(json),
    ).map((e) => e as TimeSlot).toList();
  }

  Widget getModeOfConsultation({required String mode}) {
    String icon = '';
    String modeText = '';
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    switch (mode) {
      case 'AUDIO':
        icon = Images.callMode;
        modeText = langBloc.getString(Strings.audio);
        break;
      case 'VIDEO':
        icon = Images.videoMode;
        modeText = langBloc.getString(Strings.video);
        break;
      case 'HOME':
        icon = Images.homeMode;
        modeText = langBloc.getString(Strings.atHome);
        break;
    }
    return Row(
      children: [
        Image.asset(
          icon,
          height: 16,
        ),
        const SizedBox(width: 8),
        Text(
          modeText,
          style: textTheme.bodyLarge
              ?.copyWith(color: Colors.lightBlue, fontSize: 16),
        ),
      ],
    );
  }
}
