import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/patient_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/review_time_slot_widget.dart';
import 'package:alsan_app/ui/screens/main/sessions/feedback_screen.dart';
import 'package:alsan_app/ui/screens/main/sessions/session_at_home/session_at_home_screen.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/address_card.dart';
import 'package:alsan_app/ui/widgets/dialog_confirm.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/sesssion_bloc.dart';
import '../../../../resources/images.dart';
import '../../../../resources/strings.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/reverse_details_tile.dart';
import '../../../widgets/success_screen.dart';
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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(langBloc.getString(Strings.sessionDetails)),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              onPopupSelected.call(value: value, session: session!);
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(langBloc.getString(Strings.cancel)),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(langBloc.getString(Strings.timeline)),
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
                    Text(
                      langBloc.getString(Strings.speechTherapy),
                      style: textTheme.headline4,
                    ),
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
                            langBloc.getString(Strings.atHome),
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
                  title: Text(langBloc.getString(Strings.clinicianDetails)),
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
                if (session?.sessionClinician?.isNewClinicianAccepted != null &&
                    session!.sessionClinician!.isNewClinicianAccepted! &&
                    (session?.sessionClinician?.isPatientAccepted == null ||
                        session?.sessionClinician?.isPatientAccepted ==
                            false)) ...[
                  const SizedBox(height: 16),
                  ReverseDetailsTile(
                    title: Text(
                      langBloc.getString(Strings.newClinicianDetails),
                    ),
                    value: Container(
                      decoration: BoxDecoration(
                        color: MyColors.paleLightGreen,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          ClinicianDetailsWidget(
                            clinician: session!.sessionClinician!.newClinician!,
                          ),
                          const SizedBox(height: 16),
                          if (session?.sessionClinician
                                      ?.isNewClinicianAccepted ==
                                  true &&
                              (session?.sessionClinician?.isPatientAccepted ==
                                      null ||
                                  session?.sessionClinician
                                          ?.isPatientAccepted ==
                                      false)) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ProgressButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(30, 45),
                                        maximumSize: const Size(30, 45),
                                      ),
                                      onPressed: () async {
                                        changeClinician(
                                          context: this.context,
                                          msg: langBloc.getString(Strings
                                              .confirmToAcceptTheNewClinician),
                                          type: 'Accept',
                                          id: session!.sessionClinician!.id!,
                                        );
                                      },
                                      child: Text(
                                        langBloc.getString(Strings.accept),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          minimumSize: const Size(30, 45),
                                          maximumSize: const Size(30, 45)),
                                      onPressed: () async {
                                        changeClinician(
                                          context: this.context,
                                          msg: langBloc.getString(
                                            Strings.confirmToCancelTheSession,
                                          ),
                                          type: 'Reject',
                                          id: session!.sessionClinician!.id!,
                                        );
                                      },
                                      child: Text(
                                        langBloc.getString(Strings.reject),
                                        style: textTheme.button?.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
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
                      patient: session!.patientProfile!,
                    ),
                  ),
                ),
                if (session!.consultationMode == "HOME") ...[
                  const SizedBox(height: 16),
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
                  title: Text(langBloc.getString(Strings.symptoms)),
                  value: Text('${session!.type}', style: textTheme.headline2),
                ),
                const SizedBox(height: 16),
                ReverseDetailsTile(
                  title: Text(langBloc.getString(Strings.description)),
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
                        Text(langBloc.getString(Strings.medicalRecords)),
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
                payNow(),
                joinOrStartSessionButton(),
                const SizedBox(height: 16),
                finishButton(),
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

  Widget payNow() {
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return (session!.status == "APPROVED")
        ? ProgressButton(
            onPressed: () async {
              // PaymentScreen.open(context, session: session!);
              var response = await sessionBloc.createRazorPayOrder(
                id: int.parse(widget.id),
              ) as Map<String, dynamic>;
              if (response.containsKey('status') &&
                  response['status'] == 'success') {
                SuccessScreen.open(
                  context,
                  type: '',
                  message: response['message'],
                );
              }
            },
            child: Text(langBloc.getString(Strings.payNow)),
          )
        : const SizedBox();
  }

  Widget joinOrStartSessionButton() {
    // bool flag = (true || session!.status == "PAID" || session!.status == "STARTED") &&
    //     Helper.formatDate(date: DateTime.now()) ==
    //         Helper.formatDate(date: session!.date);
    //
    // if (!flag) {
    //   return const SizedBox();
    // }

    var langBloc = Provider.of<LangBloc>(context, listen: false);

    return ProgressButton(
      onPressed: sessionOnTap,
      child: Text(
        "${langBloc.getString(Strings.joinSession)}${session!.consultationMode == 'HOME' ? ' ${langBloc.getString(Strings.atHome)}' : ''}",
      ),
    );
  }

  Widget finishButton() {
    bool flag = (session?.status == "STARTED") &&
        Helper.formatDate(date: DateTime.now()) ==
            Helper.formatDate(date: session?.date);

    if (!flag) {
      return const SizedBox();
    }
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      onPressed: () async {
        ProgressUtils.handleProgress(
          context,
          task: () async {
            FeedbackScreen.open(context, session: session!);
          },
        );
      },
      child: Text(langBloc.getString(Strings.finish)),
    );
  }

  sessionOnTap() async {
    var sessionsBloc = Provider.of<SessionBloc>(context, listen: false);
    String date = DateFormat('yyyy-MM-dd').format(
      session!.date!,
    );
    String time = "${session!.startAt!}:00";
    String timestamp = '$date $time';
    var scheduledTimeStamp = DateTime.parse(timestamp);
    var duration = DateTime.now().toUtc().difference(
          scheduledTimeStamp,
        );

    // if (duration.inMinutes > (session!.clinicianTimeSlots!.length * 60 + 30)) {
    //   return;
    // }

    duration = const Duration(minutes: 60);

    switch (session!.consultationMode) {
      case 'HOME':
        SessionAtHomeScreen.open(
          context,
          session: session!,
          duration: duration,
        ).then((value) => setState(() {}));
        break;
      case 'AUDIO':
      case 'VIDEO':
        var token = await sessionsBloc.generateToken(
          session!.sessionId!,
          session!.patientProfile!.id!,
        ) as Map<String, dynamic>;
        AgoraMeetScreen.open(
          context: context,
          session: session!,
          token: token['token'],
          duration: duration,
        ).then((value) async {
          setState(() {});
        });
        break;
    }
  }

  changeClinician({
    required BuildContext context,
    required String msg,
    required String type,
    required int id,
  }) async {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);

    var flag = await ConfirmDialog.show(context, message: msg);

    if (flag == true) {
      bool? res;
      switch (type) {
        case 'Accept':
          res = true;
          break;
        case 'Reject':
          res = false;
          break;
      }
      ProgressUtils.handleProgress(
        context,
        task: () async {
          await sessionBloc.updateSessionClinician(
            id: id.toString(),
            body: {"isPatientAccepted": res},
          );
          setState(() {});
        },
      );
    }
  }
}
