import 'package:flutter/cupertino.dart';

class UiNotifier extends ChangeNotifier {
  int leftNavIndex = 0;
  static String userName, firstName, lastName;
  DateTime dob;

  void setAuthCred(String username, fn, ln) {
    userName = username;
    firstName = fn;
    lastName = ln;
  }

  void setLeftNavIndex(int index) {
    leftNavIndex = index;
    notifyListeners();
  }

  void setDob(DateTime val) {
    dob = val;
  }
}
