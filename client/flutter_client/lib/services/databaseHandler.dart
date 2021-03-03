import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';

class DatabaseHandler {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  var userData;

  Future<bool> userNameNotExist(String userName) async {
    bool isOkay = false;
    await firestore
        .collection('users')
        .where('uid', isNotEqualTo: firebaseAuth.currentUser.uid)
        .where('userName', isEqualTo: userName)
        .get()
        .then((value) => {
              if (value.docs.isEmpty) {isOkay = true}
            })
        .catchError((e) => print(e));
    return isOkay;
  }

  Future<bool> userHasDataBase() async {
    bool isOkay = false;
    if (firebaseAuth.currentUser != null) {
      await firestore
          .collection('users')
          .where('uid', isEqualTo: firebaseAuth.currentUser.uid)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          isOkay = true;
        }
      }).catchError((e) => throw e);
    }
    return isOkay;
  }

  Future<Map<String, dynamic>> getUserData() async {
    if (firebaseAuth.currentUser != null) {
      var value = await firestore
          .collection('users')
          .where('uid', isEqualTo: firebaseAuth.currentUser.uid)
          .get();
      return value.docs[0].data();
    } else
      throw 'No signed in user';
  }

  Future<Map<String, dynamic>> getUserDataByUid(String uid) async {
    if (firebaseAuth.currentUser != null) {
      var value = await firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();
      return value.docs[0].data();
    } else
      throw 'No signed in user';
  }

  Future<QuerySnapshot> myChats() async {
    return firestore
        .collection('chats')
        .where('users', arrayContains: firebaseAuth.currentUser.uid)
        .get();
  }

  /// currently this returns all signed un users
  /// should update with search query
  Stream<QuerySnapshot> searchedUsers(String key) {
    if (key != null && key != '') {
      return firestore
          .collection('users')
          .where('uid', isNotEqualTo: firebaseAuth.currentUser.uid)
          .where('searchKey', arrayContains: key)
          .snapshots();
    } else
      return firestore
          .collection('users')
          .where('uid', isNotEqualTo: firebaseAuth.currentUser.uid)
          .snapshots();
  }

  Stream<QuerySnapshot> searchedTopics(String key) {
    if (key != null && key != '') {
      return firestore
          .collection('topics')
          .where('creator', isNotEqualTo: firebaseAuth.currentUser.uid)
          .where('searchKey', arrayContains: key)
          .snapshots();
    } else {
      return firestore
          .collection('topics')
          .where('creator', isNotEqualTo: firebaseAuth.currentUser.uid)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> myTopics() {
    return firestore
        .collection('topics')
        .where('creator', isEqualTo: firebaseAuth.currentUser.uid)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Future<void> addUserToDatabase(DateTime dob, String college) async {
    User currentUser = firebaseAuth.currentUser;
    String deviceToken = await firebaseMessaging.getToken();
    if (currentUser != null) {
      firestore.collection('users').add({
        'userName': UiNotifier.userName,
        'deviceToken': deviceToken,
        'uid': currentUser.uid,
        'dp': currentUser.photoURL,
        'firstName': UiNotifier.firstName,
        'lastName': UiNotifier.lastName,
        'email': currentUser.email,
        'dateOfBirth': dob,
        'college': college,
        'bio': '',
        'topics': [],
        'friends': [],
        'friendRequestsReceived': [],
        'friendRequestsSent': []
      });
    } else
      throw 'No signed in user';
  }

  Future<void> updateUserDatabase({Map<String, dynamic> data}) async {
    QuerySnapshot snapshot = await firestore
        .collection('users')
        .where('uid', isEqualTo: firebaseAuth.currentUser.uid)
        .get()
        .catchError((e) {
      throw 'Error finding user';
    });
    String id = snapshot.docs[0].id;
    await firestore.collection('users').doc(id).update(data).catchError((e) {
      throw 'Error updating data';
    });
  }

  ///updating ds on 3 march
  Future<void> createTopic(
      String description, String title, bool isPrivate, String dp) async {
    String myColor = titleColors[Random().nextInt(7)];
    firestore.collection('topics').add({
      'creator': firebaseAuth.currentUser.uid,
      'description': description,
      'dp': dp,
      'timeStamp': DateTime.now(),
      'avgRating': 0.0,
      'title': title,
      'private': isPrivate,
      'requests': [],
      'peoples': [firebaseAuth.currentUser.uid],
    }).then((value) {
      value.collection('peoples').add({
        'access': 'creator',
        'color': myColor,
        'push notification': true,
        'uid': firebaseAuth.currentUser.uid,
        'rating': 0.0
      });
      value.update({'id': value.id});
      value.collection('adminChannels').add({'title': 'Announcements'});
      value.collection('adminChannels').add({'title': 'Documents'});
      value.collection('privateChannels').add({
        'title': 'Suggestion',
        'peoples': [firebaseAuth.currentUser.uid]
      }).then((value) {
        value.collection('peoples').add({
          'uid': firebaseAuth.currentUser.uid,
          'access': 'readwrite' //readonly
        });
      });
      value.collection('publicChannels').add({'title': title});
      value.collection('publicChannels').add({'title': 'General'});
    });
  }
}
