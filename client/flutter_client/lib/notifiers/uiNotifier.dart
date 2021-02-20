import 'package:flutter/cupertino.dart';
import 'package:flutter_client/services/databaseHandler.dart';

class UiNotifier extends ChangeNotifier {
  int leftNavIndex = 0;
  static String userName, firstName, lastName;
  DateTime dob;
  Map<String, dynamic> userData;
  bool isUserNameOkay = true;
  //todo: replace with notifier in registration1

  void setAuthCred(String username, fn, ln) {
    userName = username;
    firstName = fn;
    lastName = ln;
  }

  Future<void> setUserData() async {
    userData = await DatabaseHandler().getUserData();
    notifyListeners();
  }

  void setLeftNavIndex(int index) {
    leftNavIndex = index;
    notifyListeners();
  }

  Future<bool> getUserNameNotExist(String u) async {
    isUserNameOkay = await DatabaseHandler().userNameNotExist(u);
    notifyListeners();
    return isUserNameOkay;
  }

  void setDob(DateTime val) {
    dob = val;
  }
}
