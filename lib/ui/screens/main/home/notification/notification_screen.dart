import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/ui/widgets/details_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/user_bloc.dart';
import '../../../../../model/notification.dart' as n;
import '../../../../../resources/images.dart';
import '../../../../../resources/strings.dart';
import '../../../../widgets/empty_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';

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
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(langBloc.getString(Strings.notifications))),
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
            return EmptyWidget(
              message: langBloc.getString(Strings.noRecentNotifications),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Image.asset(
                  //   getNotificationIcon(type: notifications[index].type!),
                  // ),
                  Image.asset(
                    getNotificationIcon(type: 'session'),
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DetailsTile(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      title: Text(notifications[index].title!),
                      value: Text(notifications[index].body!),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, _) => const Divider(),
          );
        },
      ),
    );
  }

  getNotificationIcon({required String type}) {
    switch (type) {
      case 'session':
        return Images.sessionNotify;
      case 'clinician':
        return Images.clinicianNotify;
      case 'session_start':
        return Images.sessionStart;
      case 'twelveHrWindow':
        return Images.twelveHrWindowNotify;
      case 'payment':
        return Images.paymentNotify;
      case 'clinician_signup':
        return Images.clinicianSignupNotify;
      case 'user_signup':
        return Images.userSignupNotify;
      case 'resource':
        return Images.resourceNotify;
    }
  }
}
