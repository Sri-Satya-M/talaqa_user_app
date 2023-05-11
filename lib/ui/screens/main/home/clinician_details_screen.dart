import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/review.dart';
import '../../../../model/service.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/images.dart';
import '../../../../resources/strings.dart';
import '../../../widgets/avatar.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import 'booking/widgets/service_card.dart';
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
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.clinicianDetails))),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        physics: const ScrollPhysics(),
        children: [
          Row(
            children: [
              Avatar(
                url: clinician.imageUrl,
                name: clinician.user?.fullName,
                borderRadius: BorderRadius.circular(10),
                size: 72,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      clinician.user?.fullName ?? 'NA',
                      style: textTheme.bodyText2,
                    ),
                    Text(
                      clinician.designation ?? 'NA',
                      style: textTheme.caption?.copyWith(
                        color: MyColors.cerulean,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${clinician.experience} ${langBloc.getString(Strings.yearsExp)}',
                      style: textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DetailsTile(
            title: const Text('Languages Known'),
            value: Row(
              children: [
                Image.asset(Images.voice, width: 12),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    clinician.languagesKnown ?? 'NA',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DetailsTile(
            title: Text(langBloc.getString(Strings.bio)),
            value: Text(clinician.bio ?? 'NA'),
          ),
          const SizedBox(height: 16),
          Text(langBloc.getString(Strings.services)),
          FutureBuilder<Services>(
            future: sessionBloc.getServices(query: {'clinicianId': clinician.id}),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return CustomErrorWidget(error: snapshot.error);
              }

              if (!snapshot.hasData) return const LoadingWidget();

              var services = snapshot.data?.services ?? [];

              if (services.isEmpty) return const EmptyWidget();

              return ListView.builder(
                itemCount: services.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) => ServiceCard(
                  service: services[index],
                ),
              );
            },
          ),
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
            future: userBloc.getReview(query: {
              'offset':0,
              'limit':10,
              'clinicianId': clinician.id.toString()
            }),
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
