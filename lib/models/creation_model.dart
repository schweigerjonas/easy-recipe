import 'package:flutter/material.dart';

class CreationModel extends ChangeNotifier {
  int currentPageIndex = 0;



  void setPageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

}