import 'package:flutter/material.dart';

class MainBloc with ChangeNotifier{
  int index = 0;
  int tab = 0;

  void changeIndex(int value){
    index = value;
    notifyListeners();
  }

  void ChangeTab(int index){
    tab = index;
    notifyListeners();
  }
}