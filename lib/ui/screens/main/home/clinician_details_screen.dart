import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/language_bloc.dart';
import '../../../../bloc/session_bloc.dart';
import '../../../../bloc/user_bloc.dart';
import '../../../../model/clinicians.dart';
import '../../../../model/service.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/images.dart';
import '../../../../resources/strings.dart';
import '../../../widgets/avatar.dart';
import '../../../widgets/details_tile.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import 'booking/widgets/service_card.dart';

class ClinicianDetailsScreen extends StatefulWidget {
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
  State<ClinicianDetailsScreen> createState() => _ClinicianDetailsScreenState();
}

class _ClinicianDetailsScreenState extends State<ClinicianDetailsScreen> {
  Future<List>? futures;

  @override
  void initState() {
    super.initState();
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    futures = Future.wait([
      sessionBloc.getServices(query: {'clinicianId': widget.clinician.id}),
      // userBloc.getReview(query: {
      //   'offset': 0,
      //   'limit': 10,
      //   'clinicianId': widget.clinician.id.toString()
      // }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.clinicianDetails))),
      body: FutureBuilder<List>(
        future: futures,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }
          if (!snapshot.hasData) return const LoadingWidget();
          var list = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Avatar(
                    url: widget.clinician.imageUrl,
                    name: widget.clinician.user?.fullName,
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
                          widget.clinician.user?.fullName ?? 'NA',
                          style: textTheme.bodyMedium,
                        ),
                        Text(
                          widget.clinician.designation ?? 'NA',
                          style: textTheme.bodySmall?.copyWith(
                            color: MyColors.cerulean,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.clinician.experience} '
                          '${langBloc.getString(Strings.yearsExp)}',
                          style: textTheme.titleSmall,
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
                        widget.clinician.languagesKnown ?? 'NA',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DetailsTile(
                title: Text(langBloc.getString(Strings.bio)),
                value: Text(widget.clinician.bio ?? 'NA'),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  List<Service> services = list[0]?.services ?? [];
                  if (services.isEmpty) {
                    return const EmptyWidget();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(langBloc.getString(Strings.services)),
                        ListView.builder(
                          itemCount: services.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ServiceCard(service: services[index]);
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
              // const SizedBox(height: 30),
              // Builder(builder: (context) {
              //   List<Review> reviews = list[1] ?? [];
              //   if (reviews.isEmpty) {
              //     return const EmptyWidget();
              //   } else {
              //     return Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               langBloc.getString(Strings.reviews),
              //               style: textTheme.bodyLarge,
              //             ),
              //             TextButton(
              //               onPressed: () => ClinicianReviewsScreen.open(
              //                   context,
              //                   id: widget.clinician.id.toString()),
              //               child: Text(
              //                 langBloc.getString(Strings.seeAll),
              //                 style: textTheme.displayMedium?.copyWith(
              //                   color: MyColors.primaryColor,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //         ListView.builder(
              //           itemCount: reviews.length,
              //           shrinkWrap: true,
              //           physics: const NeverScrollableScrollPhysics(),
              //           itemBuilder: (context, index) {
              //             return ReviewCard(review: reviews[index]);
              //           },
              //         ),
              //       ],
              //     );
              //   }
              // }),
            ],
          );
        },
      ),
    );
  }
}
