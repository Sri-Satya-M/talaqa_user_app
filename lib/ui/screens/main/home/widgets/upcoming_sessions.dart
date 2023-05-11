import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/sesssion_bloc.dart';
import '../../../../../model/session.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/strings.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../../sessions/session_details_screen.dart';
import '../../sessions/widgets/session_card.dart';

class UpcomingSessions extends StatefulWidget {
  final VoidCallback onTap;

  const UpcomingSessions({super.key, required this.onTap});

  @override
  _UpcomingSessionsState createState() => _UpcomingSessionsState();
}

class _UpcomingSessionsState extends State<UpcomingSessions> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return FutureBuilder<List<Session>>(
      future: sessionBloc.getSessions(query: {
        "status": ["PENDING","APPROVED", "PAID", 'STARTED'],
        "patientId": userBloc.profile!.id,
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(error: snapshot.error);
        }
        if (!snapshot.hasData) {
          return const LoadingWidget();
        }
        var sessions = snapshot.data ?? [];
        
        if (sessions.isEmpty) return const SizedBox();

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  langBloc.getString(Strings.upcomingSessions),
                  style: textTheme.bodyText1,
                ),
                TextButton(
                  onPressed: widget.onTap,
                  child: Text(
                    langBloc.getString(Strings.seeAll),
                    style: textTheme.headline2?.copyWith(
                      color: MyColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 410,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: sessions.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SessionCard(
                    session: sessions[index],
                    onTap: () => SessionDetailsScreen.open(
                      context,
                      id: sessions[index].id.toString(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
