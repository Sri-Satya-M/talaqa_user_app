import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/language_bloc.dart';
import '../../../../../bloc/sesssion_bloc.dart';
import '../../../../../bloc/user_bloc.dart';
import '../../../../../model/session.dart';
import '../../../../../resources/strings.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../widgets/session_card.dart';

class CancelledTab extends StatefulWidget {
  const CancelledTab({super.key});

  @override
  _CancelledTabState createState() => _CancelledTabState();
}

class _CancelledTabState extends State<CancelledTab> {
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
        "status": ['CANCELLED', 'REJECTED'],
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
                message: langBloc.getString(Strings.noCancelledSessions),
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
                                style: textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return SessionCard(session: sessions[index], onTap: () {});
                  },
                  childCount: sessions.length + (isFinished ? 0 : 1),
                ),
              ),
            ],
          );
  }
}
