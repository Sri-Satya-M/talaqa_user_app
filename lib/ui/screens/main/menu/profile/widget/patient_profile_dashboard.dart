import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/model/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/images.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Session Analytics", style: textTheme.subtitle2),
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
                      'No Sessions on this Patient',
                      style: textTheme.caption,
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
                  "Session Details",
                  style: textTheme.subtitle2?.copyWith(
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
                      title: 'Pending Sessions',
                      count: data.sessionDetails!.pending.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: 'Confirmed Sessions',
                      count: data.sessionDetails!.pending.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: 'Completed Sessions',
                      count: data.sessionDetails!.pending.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Mode of Consultation",
                  style: textTheme.subtitle2?.copyWith(
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
                      title: 'Online Consultations',
                      count: onlineConsultations.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: 'Offline Consultations',
                      count: offlineConsultations.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Session Information",
                  style: textTheme.subtitle2?.copyWith(
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
                      title: 'Total Duration',
                      count: data.sessionInfo!.duration.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: 'Total Amount',
                      count: data.sessionInfo!.totalAmount.toString(),
                    ),
                    SessionOverviewCard(
                      icon: Images.sessionsIcon,
                      title: 'School Reports',
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
