import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/sesssion_bloc.dart';
import 'package:alsan_app/model/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/user_bloc.dart';
import '../../../../../resources/strings.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../session_details_screen.dart';
import '../widgets/session_card.dart';

class UpcomingTab extends StatefulWidget {
  const UpcomingTab({super.key});

  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab> {
  bool isFinished = false;
  bool isLoading = false;
  bool isEmpty = false;
  List<Session> sessions = [];

  Future<void> fetchMore() async {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);

    if (isFinished || isLoading) return;
    isLoading = true;
    try {
      var limit = 20;
      var query = {
        "status": [
          "PENDING",
          "APPROVED",
          "PAID",
          'STARTED',
          "NEW_CLINICIAN_ASSIGNED",
          'CLINICIAN_ACCEPTED',
          'CLINICIAN_REJECTED'
        ],
        "patientId": userBloc.profile!.id,
        'offset': sessions.length.toString(),
        'limit': limit.toString(),
      };

      var list = await sessionBloc.getSessions(query: query);
      sessions.addAll(list);

      if (list.length < limit) isFinished = true;
    } catch (e) {
      isFinished = true;
    }
    isLoading = false;
    isEmpty = sessions.isEmpty;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return (isEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyWidget(
                message: langBloc.getString(Strings.noUpcomingSessions),
              ),
            ],
          )
        : CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == sessions.length) {
                      fetchMore();
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const LoadingWidget(),
                              const SizedBox(height: 8),
                              Text(
                                langBloc.getString(Strings.fetchingSessions),
                                style: textTheme.caption!.copyWith(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }

                    return SessionCard(
                      session: sessions[index],
                      onTap: () => SessionDetailsScreen.open(
                        context,
                        id: sessions[index].id.toString(),
                      ),
                    );
                  },
                  childCount: sessions.length + (isFinished ? 0 : 1),
                ),
              ),
            ],
          );
  }
}
