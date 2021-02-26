import 'package:flutter/cupertino.dart';
import 'package:flutter_client/services/databaseHandler.dart';

class UiNotifier extends ChangeNotifier {
  int leftNavIndex = 0;
  static String userName, firstName, lastName;
  DateTime dob;
  Map<String, dynamic> userData;
  bool isUserNameOkay = true;
  //todo: replace with notifier in registration1
  int searchFilterOptionIndex = 0;
  DatabaseHandler _databaseHandler = new DatabaseHandler();

  void setAuthCred(String username, fn, ln) {
    userName = username;
    firstName = fn;
    lastName = ln;
  }

  Future<void> setUserData() async {
    userData = await _databaseHandler.getUserData();
    notifyListeners();
  }

  void setLeftNavIndex(int index) {
    leftNavIndex = index;
    notifyListeners();
  }

  void setSearchFilterOptionIndex(int index) {
    searchFilterOptionIndex = index;
    notifyListeners();
  }

  Future<bool> getUserNameNotExist(String u) async {
    isUserNameOkay = await _databaseHandler.userNameNotExist(u);
    notifyListeners();
    return isUserNameOkay;
  }

  void setDob(DateTime val) {
    dob = val;
  }
}
