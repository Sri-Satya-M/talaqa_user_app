import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/patient_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/review_time_slot_widget.dart';
import 'package:alsan_app/ui/screens/main/sessions/feedback_screen.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/address_card.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/sesssion_bloc.dart';
import '../../../../resources/images.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/reverse_details_tile.dart';
import '../home/booking/payment_screen.dart';
import '../home/booking/widgets/bill_details_widget.dart';
import '../menu/profile/patient_profile_screen.dart';
import 'agora/agora_meet_call.dart';
import 'timeline/timeline_screen.dart';

class SessionDetailsScreen extends StatefulWidget {
  final String id;

  const SessionDetailsScreen({super.key, required this.id});

  static Future open(BuildContext context, {required String id}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SessionDetailsScreen(id: id)),
    );
  }

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  bool enablePay = false;
  var date = DateTime.now();
  Session? session;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              onPopupSelected.call(value: value, session: session!);
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Cancel'),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text('Timeline'),
                ),
              ];
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder<Session>(
          future: sessionBloc.getSessionById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return CustomErrorWidget(error: snapshot.error);
            }
            if (!snapshot.hasData) return const LoadingWidget();
            session = snapshot.data;
            if (session == null) return const EmptyWidget();

            return ListView(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5BFF9F),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('${session!.sessionId}'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Speech Therapy', style: textTheme.headline4),
                    if (session!.consultationMode == 'HOME') ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.home,
                            color: Colors.blue,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'At Home',
                            style: textTheme.bodyText1?.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      )
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                ReviewTimeSlotWidget(
                  dateTime: session!.date!,
                  timeslots: session!.clinicianTimeSlots!,
                ),
                const SizedBox(height: 16),
                ReverseDetailsTile(
                  title: const Text('Clinician Details'),
                  value: Container(
                    decoration: BoxDecoration(
                      color: MyColors.paleLightGreen,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClinicianDetailsWidget(
                      clinician: session!.clinician!,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ReverseDetailsTile(
                  title: const Text('Patient Details'),
                  value: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: const BoxDecoration(
                      color: MyColors.paleLightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: PatientDetailsWidget(
                      patient: session!.patientProfile!,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (session!.consultationMode == "HOME") ...[
                  AddressCard(
                    address: session!.patientAddress!,
                    onTap: () async {
                      await Helper.openMap(
                        latitude: double.parse(
                          session!.patientAddress!.latitude!,
                        ),
                        longitude: double.parse(
                          session!.patientAddress!.latitude!,
                        ),
                        name: session!.patientProfile!.fullName!,
                        address: Helper.formatAddress(
                          address: session!.patientAddress,
                        ),
                      );
                    },
                    suffixIcon: Icons.directions,
                    suffixIconColor: MyColors.primaryColor,
                  ),
                ],
                const SizedBox(height: 16),
                ReverseDetailsTile(
                  title: const Text('Symptoms'),
                  value: Text('${session!.type}', style: textTheme.headline2),
                ),
                const SizedBox(height: 16),
                ReverseDetailsTile(
                  title: const Text('Description'),
                  value: Text(
                    '${session!.description}',
                    style: textTheme.headline2,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    PatientDetailsScreen.open(
                      context,
                      id: session!.patientProfile!.id.toString(),
                    );
                  },
                  child: Container(
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
                        const Text('Medical Records'),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BillDetailsWidget(
                  noOfTimeslots: session!.clinicianTimeSlots!.length,
                  totalAmount: (session!.consultationFee)!.toDouble(),
                  consultationMode: Helper.textCapitalization(
                    text: session!.consultationMode,
                  ),
                ),
                const SizedBox(height: 16),
                if (session!.status == "APPROVED") ...[
                  ProgressButton(
                    onPressed: () {
                      PaymentScreen.open(context, session: session!);
                    },
                    child: const Text('Pay Now'),
                  ),
                ],
                if (session!.status == "STARTED" &&
                        session!.consultationMode != 'HOME' &&
                        Helper.formatDate(date: date) ==
                            Helper.formatDate(date: session!.date) ||
                    true) ...[
                  ProgressButton(
                    onPressed: () async {
                      var token = await sessionBloc.generateToken(
                        session!.sessionId!,
                        session!.patientProfile!.id!,
                      ) as Map<String, dynamic>;
                      AgoraMeetScreen.open(
                        context: context,
                        session: session!,
                        token: token['token'],
                      ).then((value) async {
                        FeedbackScreen.open(context, session: session!);
                      });
                    },
                    child: const Text("Join Session"),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  onPopupSelected({required int value, required Session session}) {
    switch (value) {
      case 0:
        break;
      case 1:
        TimelineScreen.open(context, session: session);
        break;
      default:
        return;
    }
  }
}
