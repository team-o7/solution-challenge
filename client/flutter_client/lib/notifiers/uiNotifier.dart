import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/widgets/dmtile.dart';
import 'package:flutter_client/screens/profile/requests.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiNotifier extends ChangeNotifier {
  String leftNavIndex = '.';
  List _indexHistory = [];
  List _titleHistory = [];
  String selectedTopicTitle = '';
  static String userName, firstName, lastName;
  DateTime dob;
  Map<String, dynamic> userData;
  static Map<String, dynamic> allData = {};
  bool isUserNameOkay = true;
  //todo: replace with notifier in registration1
  int searchFilterOptionIndex = 0;
  DatabaseHandler _databaseHandler = new DatabaseHandler();
  List<RequestsTile> reqTiles = [];
  List<DmTile> dmTiles = [];

  Future<void> _addAllData() async {
    allData = {};
    await _databaseHandler.firestore.collection('users').get().then((value) {
      value.docs.forEach((element) {
        allData[element.data()['uid']] = element.data();
      });
    });
  }

  void saveTiles(List r) {
    for (var e in r) {
      RequestsTile tile = new RequestsTile(
        uid: e,
        index: reqTiles.length,
      );
      reqTiles.add(tile);
    }
  }

  void removeReqTile(int index) {
    reqTiles.removeAt(index);
    notifyListeners();
  }

  void clearReqTiles() {
    reqTiles = [];
  }

  void setAuthCred(String username, fn, ln) {
    userName = username;
    firstName = fn;
    lastName = ln;
  }

  Future<void> setUserData() async {
    userData = await _databaseHandler.getUserData();
    await _addAllData();
    print(allData.length);
    notifyListeners();
  }

  void setLeftNavIndex(Map<String, dynamic> data) {
    leftNavIndex = data['id'];
    selectedTopicTitle = data['title'];
    _indexHistory.add(leftNavIndex);
    _titleHistory.add(selectedTopicTitle);
    _cacheSelectedTopicData(data);
    notifyListeners();
  }

  void onTopicleave() {
    if (_indexHistory.length >= 2) {
      leftNavIndex = _indexHistory[_indexHistory.length - 2];
      selectedTopicTitle = _titleHistory[_titleHistory.length - 2];
      SharedPreferences.getInstance().then((value) {
        value.setString('id', leftNavIndex);
        value.setString('title', selectedTopicTitle);
      });
    } else {
      leftNavIndex = '.';
      selectedTopicTitle = '';
      SharedPreferences.getInstance().then((value) {
        value.setString('id', leftNavIndex);
        value.setString('title', selectedTopicTitle);
      });
    }
    notifyListeners();
  }

  void _cacheSelectedTopicData(Map<String, dynamic> data) {
    SharedPreferences.getInstance().then((value) {
      value.setString('id', data['id']);
      value.setString('title', data['title']);
    });
  }

  Future<void> setSelectedTopicDataFromCache() async {
    try {
      SharedPreferences.getInstance().then((value) {
        leftNavIndex = value.getString('id');
        selectedTopicTitle = value.getString('title');
      });
    } catch (e) {
      print(e);
    }
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
