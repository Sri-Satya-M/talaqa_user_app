import 'package:alsan_app/bloc/main_bloc.dart';
import 'package:alsan_app/bloc/user_bloc.dart';
import 'package:alsan_app/resources/colors.dart';
import 'package:alsan_app/resources/theme.dart';
import 'package:alsan_app/ui/screens/main/browse/browse_screen.dart';
import 'package:alsan_app/ui/screens/main/home/home_screen.dart';

import 'package:alsan_app/ui/screens/main/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );
  }

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String getTitile(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Browse';
      case 2:
        return 'Sessions';
    }
    return 'NA';
  }

  @override
  Widget build(BuildContext context) {
    var mainBloc = Provider.of<MainBloc>(context, listen: false);
    var userBloc = Provider.of<UserBloc>(context, listen: false);
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Text(userBloc.profile?.user?.fullName ?? ''),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_active_outlined,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        type: BottomNavigationBarType.fixed,
        currentIndex: mainBloc.index,
        onTap: (value) {
          setState(() {
            mainBloc.index = value;
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
              return Container();
            case 3:
              return Container();
            case 4:
              return MenuScreen();
            default:
              return Container();
          }
        },
      ),
    );
  }
}
