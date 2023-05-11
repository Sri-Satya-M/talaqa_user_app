import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/ui/screens/main/sessions/widgets/rating_widget.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/ui/widgets/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../resources/colors.dart';
import '../../../../resources/strings.dart';
import '../../../widgets/dynamic_grid_view.dart';
import '../../../widgets/reverse_details_tile.dart';
import '../home/booking/widgets/timeslot_details_widget.dart';

class FeedbackScreen extends StatefulWidget {
  final Session session;

  static Future open(BuildContext context, {required Session session}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FeedbackScreen(session: session),
      ),
    );
  }

  const FeedbackScreen({super.key, required this.session});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double? rating;
  bool isReport = false;
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.feedback))),
      body: ListView(
        physics: const ScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: MyColors.divider.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(langBloc.getString(Strings.sessionDetails)),
                ),
                Divider(color: MyColors.divider.withOpacity(0.1)),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.session.sessionId.toString(),
                        style: textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      DynamicGridView(
                        spacing: 0,
                        count: 2,
                        children: [
                          TimeslotDetailsWidget(
                            dateTime: widget.session.date!,
                            timeslots: widget.session.sessionTimeslots!
                                .map((e) => e.timeslot!)
                                .toList(),
                          ),
                          const SizedBox(),
                          ReverseDetailsTile(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                langBloc.getString(Strings.sessionDuration),
                                style: textTheme.bodySmall,
                              ),
                            ),
                            value: Text(
                              "01:30",
                              style: textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 300,
            child: Text(
              langBloc.getString(
                Strings.yourSessionHasBeenSuccessfullyCompleted,
              ),
              style: textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 18),
          RatingWidget(
            onTap: (rating) => this.rating = rating.toDouble(),
          ),
          const SizedBox(height: 24),
          Text(langBloc.getString(Strings.writeReview)),
          const SizedBox(height: 8),
          TextFormField(
            minLines: 5,
            maxLength: 255,
            maxLines: 10,
            controller: reviewController,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: MyColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: MyColors.divider),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                langBloc.getString(Strings.wantASchoolReport),
                style: textTheme.caption?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text("No"),
                  Switch(
                      value: isReport,
                      onChanged: (value) => setState(() {
                            isReport = value;
                          })),
                  Text(langBloc.getString(Strings.yes)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  SuccessScreen.open(
                    context,
                    type: '',
                    message: 'Session completed Successfully',
                  );
                },
                child: Text(
                  langBloc.getString(Strings.skip),
                  style: textTheme.caption?.copyWith(
                    fontSize: 16,
                    color: MyColors.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ProgressButton(
            onPressed: () async {
              var sessionBloc = Provider.of<SessionBloc>(
                context,
                listen: false,
              );

              if (rating == null) {
                return;
              }

              var body = {};

              body['rating'] = rating!.toInt();
              body['clinicianId'] = widget.session.clinicianId;
              body['patientId'] = widget.session.patientId;

              if (reviewController.text != null &&
                  reviewController.text.isNotEmpty) {
                body['comment'] = reviewController.text;
              }

              var response = await sessionBloc.postSessionFeedback(
                id: widget.session.id!,
                body: body,
              ) as Map<String, dynamic>;

              if (response.containsKey('status') &&
                  response['status'] == 'success') {
                SuccessScreen.open(
                  context,
                  type: 'FEEDBACK',
                  message: response["message"],
                );
              }
            },
            child: Text(langBloc.getString(Strings.submitYourFeedback)),
          )
        ],
      ),
    );
  }
}
