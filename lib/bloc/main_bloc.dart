import 'package:flutter/material.dart';

class MainBloc with ChangeNotifier {
  int index = 0;
  int tab = 0;
  TabController? tabController;

  void changeIndex(int value) {
    index = value;
    tab = 0;
    notifyListeners();
  }

  void changeTab(int index) {
    tab = index;
    notifyListeners();
  }

  int tabLength(int index) {
    switch (index) {
      case 2:
        return 3;
      case 3:
        return 2;
    }
    return 0;
  }
}
