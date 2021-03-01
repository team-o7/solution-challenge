import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/widgets/dmtile.dart';
import 'package:flutter_client/screens/profile/requests.dart';
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
  List<RequestsTile> reqTiles = [];
  List<DmTile> dmTiles = [];

  Future<void> buildChats() async {
    QuerySnapshot snapshot = await _databaseHandler.myChats();
    var docs = snapshot.docs;
    for (var doc in docs) {
      var data = doc.data();
      String otherGuy;
      List users = data['users'];
      if (users[0] == _databaseHandler.firebaseAuth.currentUser.uid)
        otherGuy = users[1];
      else
        otherGuy = users[0];
      var tileData = await _databaseHandler.getUserDataByUid(otherGuy);
      DmTile newTile = new DmTile(
        reference: doc.reference,
        name: tileData['firstName'] + ' ' + tileData['lastName'],
        userName: tileData['userName'],
        dp: tileData['dp'],
      );
      dmTiles.add(newTile);
    }
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
    await buildChats();
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
