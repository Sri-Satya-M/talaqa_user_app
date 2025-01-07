import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/theme.dart';
import 'package:alsan_app/ui/screens/main/browse/browse_screen.dart';
import 'package:alsan_app/ui/screens/main/home/home_screen.dart';
import 'package:alsan_app/ui/screens/main/home/notification/notification_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/menu_screen.dart';
import 'package:alsan_app/ui/screens/main/resources/resources_screen.dart';
import 'package:alsan_app/ui/screens/main/sessions/session_screen.dart';
import 'package:alsan_app/ui/screens/main/sessions/tabs/screens/completed_session_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../resources/images.dart';
import '../../../resources/strings.dart';
import '../../../utils/custom_notifications.dart';
import '../language/language_screen.dart';
import 'sessions/session_details_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static Future open(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
        (route) => false);
  }

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  void _handleMessage(
    RemoteMessage? message, {
    var localNotificationMessage,
  }) async {
    var data = message?.data;
    var details = data?['data'];
    MainScreen.open(context);
    var mainBloc = Provider.of<MainBloc>(context, listen: false);
    print(data);
    switch (data?['type']) {
      case 'session':
        (['COMPLETED', 'REPORT_SUBMITTED'].contains(data!['status']))
            ? CompletedSessionScreen.open(context, id: data['typeId'])
            : SessionDetailsScreen.open(context, id: data['typeId']);
        break;
      case 'resource':
        mainBloc.changeIndex(3);
        break;
      default:
        return;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().updateFCMToken();
    FirebaseMessaging.onBackgroundMessage(
      (RemoteMessage message) async => _handleMessage.call(message),
    );
    CustomNotification customNotification = CustomNotification();
    customNotification.initialize();
    customNotification.setupNotifications(
      context: context,
      handleMessage: _handleMessage,
    );
    context.read<MainBloc>().tabController = TabController(
      length: 0,
      vsync: this,
    );
    updateLan();
  }

  updateLan() async {
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: false);

    await userBloc.switchLanguage(
      language: langBloc.currentLanguageText == 'English'
          ? '${langBloc.currentLanguageText}'.toUpperCase()
          : 'ARABIC',
    );
  }

  @override
  Widget build(BuildContext context) {
    var mainBloc = Provider.of<MainBloc>(context, listen: true);
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var langBloc = Provider.of<LangBloc>(context, listen: true);
    var textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: mainBloc.tabLength(mainBloc.index),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 16,
          title: Text(
            "${langBloc.getString(Strings.hi)} "
            "${userBloc.profile?.user?.fullName ?? ''}",
          ),
          actions: [
            IconButton(
              onPressed: () {
                LanguageScreen.open(context: context, isFromLogin: false);
              },
              icon: Image.asset(Images.lan, width: 30, height: 30),
            ),
            IconButton(
              onPressed: () => NotificationScreen.open(context),
              icon: Icon(
                Icons.notifications_active_outlined,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              mainBloc.tabLength(mainBloc.index) > 0 ? 40 : 0,
            ),
            child: Builder(
              builder: (context) {
                switch (mainBloc.index) {
                  case 2:
                    return TabBar(
                      controller: mainBloc.tabController,
                      onTap: (value) {
                        mainBloc.changeTab(value);
                      },
                      tabs: [
                        SizedBox(
                          height: 30,
                          child: Text(langBloc.getString(Strings.upcoming)),
                        ),
                        SizedBox(
                          height: 30,
                          child: Text(langBloc.getString(Strings.completed)),
                        ),
                        SizedBox(
                          height: 30,
                          child: Text(langBloc.getString(Strings.cancelled)),
                        ),
                      ],
                    );
                  case 3:
                    return TabBar(
                      controller: mainBloc.tabController,
                      onTap: (value) {
                        mainBloc.changeTab(value);
                      },
                      tabs: [
                        SizedBox(
                          height: 30,
                          child: Text(langBloc.getString(Strings.articles)),
                        ),
                        SizedBox(
                          height: 30,
                          child: Text(langBloc.getString(Strings.videos)),
                        ),
                      ],
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
          type: BottomNavigationBarType.fixed,
          currentIndex: mainBloc.index,
          onTap: (value) {
            mainBloc.tabController = TabController(
              initialIndex: 0,
              length: mainBloc.tabLength(value),
              vsync: this,
            );
            mainBloc.changeIndex(value);
          },
          selectedItemColor: MyColors.cerulean,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          selectedLabelStyle: textTheme.bodySmall?.copyWith(
            color: MyColors.cerulean,
          ),
          unselectedLabelStyle: textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: langBloc.getString(Strings.home),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search_outlined),
              label: langBloc.getString(Strings.browse),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.watch_later_outlined),
              label: langBloc.getString(Strings.sessions),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.language),
              label: langBloc.getString(Strings.resources),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_rounded),
              label: langBloc.getString(Strings.menu),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            switch (mainBloc.index) {
              case 0:
                return const HomeScreen();
              case 1:
                return const BrowseScreen();
              case 2:
                return const SessionScreen();
              case 3:
                return const ResourcesScreen();
              case 4:
                return const MenuScreen();
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
