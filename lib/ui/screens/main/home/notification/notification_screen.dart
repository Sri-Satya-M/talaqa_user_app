import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/main_bloc.dart';
import '../../../../../bloc/user_bloc.dart';
import '../../../../../model/notification.dart' as n;
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../../sessions/session_details_screen.dart';
import '../../sessions/tabs/screens/completed_session_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NotificationScreen()),
    );
  }

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<n.Notification>>(
        future: userBloc.getNotifications(query: {
          'id': userBloc.profile!.user!.id,
        }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(error: snapshot.error);
          }
          if (!snapshot.hasData) return const LoadingWidget();
          var notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return const EmptyWidget(message: 'No Recent Notifications');
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  var mainBloc = Provider.of<MainBloc>(context, listen: false);
                  switch (notifications[index].type) {
                    case 'session':
                      (['COMPLETED', 'REPORT_SUBMITTED']
                              .contains(notifications[index].status))
                          ? CompletedSessionScreen.open(
                              context,
                              id: notifications[index].typeId.toString(),
                            )
                          : SessionDetailsScreen.open(
                              context,
                              id: notifications[index].typeId.toString(),
                            );
                      break;
                    case 'resource':
                      mainBloc.changeIndex(3);
                      break;
                    default:
                      return;
                  }
                },
                child: DetailsTile(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  title: Text(notifications[index].title!),
                  value: Text(notifications[index].body!),
                ),
              );
            },
            separatorBuilder: (context, _) => const Divider(),
          );
        },
      ),
    );
  }
}
