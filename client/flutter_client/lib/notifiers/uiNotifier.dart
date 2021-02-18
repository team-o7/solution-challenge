import 'package:flutter/cupertino.dart';

class UiNotifier extends ChangeNotifier {
  int leftNavIndex = 0;
  DateTime dob;

  void setLeftNavIndex(int index) {
    leftNavIndex = index;
    notifyListeners();
  }

  void setDob(DateTime val) {
    dob = val;
  }
}
