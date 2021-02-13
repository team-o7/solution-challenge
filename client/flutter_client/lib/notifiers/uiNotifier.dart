import 'package:flutter/cupertino.dart';

class UiNotifier extends ChangeNotifier {
  int leftNavIndex = 0;

  void setLeftNavIndex(int index) {
    leftNavIndex = index;
    notifyListeners();
  }
}
