import 'package:flutter/material.dart';

class MainBloc with ChangeNotifier {
  int index = 0;
  int tab = 0;

  void changeIndex(int value) {
    index = value;
    tab = 0;
    notifyListeners();
  }

  void changeTab(int index) {
    tab = index;
    notifyListeners();
  }
}
