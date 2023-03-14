import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/model/feedback.dart' as f;
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/screens/main/home/widgets/review_card.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../resources/colors.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';

class ClinicianDetailsScreen extends StatelessWidget {
  final Clinician clinician;

  const ClinicianDetailsScreen({super.key, required this.clinician});

  static Future open(BuildContext context, {required Clinician clinician}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClinicianDetailsScreen(clinician: clinician),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Book Session')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          ClinicianDetailsWidget(clinician: clinician),
          const SizedBox(height: 16),
          DetailsTile(
            title: Text('Bio', style: textTheme.bodyText1),
            value: Text(clinician.bio ?? 'NA'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Reviews", style: textTheme.bodyText1),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See all",
                  style: textTheme.headline2?.copyWith(
                    color: MyColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder<List<f.Feedback>>(
            future: userBloc.getFeedback(id: clinician.id.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return CustomErrorWidget(error: snapshot.error);
              }
              if (!snapshot.hasData) return const LoadingWidget();
              var feedbackList = snapshot.data ?? [];
              if (feedbackList.isEmpty) return const EmptyWidget();
              return ListView.builder(
                itemCount: feedbackList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return FeedbackCard(feedback: feedbackList[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
