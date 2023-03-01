import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/sesssion_bloc.dart';
import '../../../../../model/session.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../../sessions/widgets/session_card.dart';

class UpcomingSessions extends StatefulWidget {
  const UpcomingSessions({super.key});

  @override
  _UpcomingSessionsState createState() => _UpcomingSessionsState();
}

class _UpcomingSessionsState extends State<UpcomingSessions> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var mainBloc = Provider.of<MainBloc>(context, listen: false);
    return FutureBuilder<List<Session>>(
      future: sessionBloc.getSessions(query: {
        "status": ["APPROVED", "PAID", 'STARTED']
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }
        if (!snapshot.hasData) {
          return const LoadingWidget();
        }
        var sessions = snapshot.data ?? [];
        if (sessions.isEmpty) return const EmptyWidget();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upcoming Sessions",
                  style: textTheme.bodyText1,
                ),
                TextButton(
                  onPressed: () {
                    mainBloc.changeIndex(2);
                  },
                  child: Text(
                    "See all",
                    style: textTheme.headline2?.copyWith(
                      color: MyColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 380,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: sessions.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SessionCard(session: sessions[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
