import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../bloc/language_bloc.dart';
import '../../../../../../resources/images.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../widgets/dynamic_grid_view.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/loading_widget.dart';
import 'session_overview_card.dart';

class PatientProfileDashboard extends StatelessWidget {
  final String patientProfileId;

  const PatientProfileDashboard({super.key, required this.patientProfileId});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          langBloc.getString(Strings.sessionAnalytics),
          style: textTheme.titleSmall,
        ),
        const SizedBox(height: 14),
        FutureBuilder<Dashboard>(
          future: userBloc.getDashboard(
            id: patientProfileId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return CustomErrorWidget(error: snapshot.error);
            }
            if (!snapshot.hasData) return const LoadingWidget();
            var data = snapshot.data;

            if (data!.sessionDetails?.total == null) {
              return SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      langBloc.getString(Strings.noSessionsOnThisPatient),
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }

            int onlineConsultations = (data.modeOfConsultation?.audio ?? 0) +
                (data.modeOfConsultation?.video ?? 0);
            int offlineConsultations = (data.modeOfConsultation?.home ?? 0);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  langBloc.getString(Strings.sessionDetails),
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.black.withOpacity(1),
                  ),
                ),
                const SizedBox(height: 10),
                DynamicGridView(
                  spacing: 0,
                  count: 2,
                  children: [
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: langBloc.getString(Strings.pendingSessions),
                      count: data.sessionDetails!.pending.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: langBloc.getString(Strings.completedSessions),
                      count: data.sessionDetails!.pending.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: langBloc.getString(Strings.completedSessions),
                      count: data.sessionDetails!.pending.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  langBloc.getString(Strings.modeOfConsultation),
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.black.withOpacity(1),
                  ),
                ),
                const SizedBox(height: 10),
                DynamicGridView(
                  spacing: 0,
                  count: 2,
                  children: [
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: langBloc.getString(Strings.onlineConsultations),
                      count: onlineConsultations.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: langBloc.getString(Strings.offlineConsultations),
                      count: offlineConsultations.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  langBloc.getString(Strings.sessionInformation),
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.black.withOpacity(1),
                  ),
                ),
                const SizedBox(height: 10),
                DynamicGridView(
                  spacing: 0,
                  count: 2,
                  children: [
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: langBloc.getString(Strings.totalDuration),
                      count: data.sessionInfo!.duration.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: langBloc.getString(Strings.totalAmount),
                      count: data.sessionInfo!.totalAmount.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: langBloc.getString(Strings.schoolReport),
                      count: data.sessionDetails!.reportSubmitted.toString(),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
