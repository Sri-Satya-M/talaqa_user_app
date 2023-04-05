import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/theme.dart';
import 'package:alsan_app/ui/screens/main/browse/browse_screen.dart';
import 'package:alsan_app/ui/screens/main/home/home_screen.dart';
import 'package:alsan_app/ui/screens/main/menu/menu_screen.dart';
import 'package:alsan_app/ui/screens/main/resources/resources_screen.dart';
import 'package:alsan_app/ui/screens/main/sessions/session_screen.dart';
import 'package:alsan_app/ui/screens/main/sessions/tabs/screens/completed_session_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_notifications.dart';
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

class _MainScreenState extends State<MainScreen> {
  late TabController tabController;

  int tabLength(int index) {
    switch (index) {
      case 2:
        return 3;
      case 3:
        return 2;
    }
    return 0;
  }

  void _handleMessage(RemoteMessage? message,
      {var localNotificationMessage}) async {
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
  }

  @override
  Widget build(BuildContext context) {
    var mainBloc = Provider.of<MainBloc>(context, listen: true);
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: tabLength(mainBloc.index),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 16,
          title: Text("Hi ${userBloc.profile?.user?.fullName ?? ''}"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_active_outlined,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              tabLength(mainBloc.index) > 0 ? 40 : 0,
            ),
            child: Builder(
              builder: (context) {
                switch (mainBloc.index) {
                  case 2:
                    return TabBar(
                      onTap: (value) {
                        setState(() {
                          mainBloc.changeTab(value);
                        });
                      },
                      tabs: const [
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Completed'),
                        Tab(text: "Cancelled"),
                      ],
                    );
                  case 3:
                    return TabBar(
                      onTap: (value) {
                        setState(() {
                          mainBloc.changeTab(value);
                        });
                      },
                      tabs: const [
                        Tab(text: 'Articles'),
                        Tab(text: 'Videos'),
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
            setState(() {
              mainBloc.changeIndex(value);
              mainBloc.changeTab(0);
              print(mainBloc.tab);
            });
          },
          selectedItemColor: MyColors.cerulean,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          selectedLabelStyle: textTheme.caption?.copyWith(
            color: MyColors.cerulean,
          ),
          unselectedLabelStyle: textTheme.caption?.copyWith(color: Colors.grey),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: "Browse",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.watch_later_outlined),
              label: "Sessions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              label: "Resources",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_rounded),
              label: "Menu",
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            switch (mainBloc.index) {
              case 0:
                return HomeScreen();
              case 1:
                return BrowseScreen();
              case 2:
                return SessionScreen();
              case 3:
                return ResourcesScreen();
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
