import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/ui/screens/main/home/booking/widgets/clinician_details_widget.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/review.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/strings.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import 'clinician_review_screen.dart';
import 'widgets/review_card.dart';

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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.bookSession))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          ClinicianDetailsWidget(clinician: clinician),
          const SizedBox(height: 16),
          DetailsTile(
            title: Text(langBloc.getString(Strings.bio),
                style: textTheme.bodyText1),
            value: Text(clinician.bio ?? 'NA'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                langBloc.getString(Strings.reviews),
                style: textTheme.bodyText1,
              ),
              TextButton(
                onPressed: () => ClinicianReviewsScreen.open(context,
                    id: clinician.id.toString()),
                child: Text(
                  langBloc.getString(Strings.seeAll),
                  style: textTheme.headline2?.copyWith(
                    color: MyColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder<List<Review>>(
            future: userBloc.getReview(id: clinician.id.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return CustomErrorWidget(error: snapshot.error);
              }
              if (!snapshot.hasData) return const LoadingWidget();
              var reviews = snapshot.data ?? [];
              if (reviews.isEmpty) return const EmptyWidget();
              return ListView.builder(
                itemCount: reviews.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ReviewCard(review: reviews[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
