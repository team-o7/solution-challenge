import 'package:flutter/cupertino.dart';

class UiNotifier extends ChangeNotifier {
  int bottomNavIndex = 0;

  void setBottomNavIndex(int index) {
    bottomNavIndex = index;
    notifyListeners();
  }
}
