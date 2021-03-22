import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:provider/provider.dart';

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

  Stream<QuerySnapshot> myChats() {
    return firestore
        .collection('chats')
        .where('users', arrayContains: firebaseAuth.currentUser.uid)
        .snapshots();
  }

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

  Stream<QuerySnapshot> joinedTopics() {
    return firestore
        .collection('topics')
        .where('peoples', arrayContains: firebaseAuth.currentUser.uid)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> topicJoinRequests(List<dynamic> reqs) {
    return firestore
        .collection('users')
        .where('uid', whereIn: reqs)
        .snapshots();
  }

  Stream<QuerySnapshot> toAddPeoplesInPrivateChannel(
      BuildContext context, List<dynamic> peoples) {
    return firestore
        .collection('topics')
        .doc(Provider.of<UiNotifier>(context, listen: false).leftNavIndex)
        .collection('peoples')
        .where('uid', whereNotIn: peoples)
        .snapshots();
  }

  Stream<QuerySnapshot> channels(BuildContext context, String channel) {
    if (channel == 'privateChannels') {
      return firestore
          .collection('topics')
          .doc(Provider.of<UiNotifier>(context, listen: true).leftNavIndex)
          .collection(channel)
          .where('peoples', arrayContains: firebaseAuth.currentUser.uid)
          .snapshots();
    } else
      return firestore
          .collection('topics')
          .doc(Provider.of<UiNotifier>(context, listen: true).leftNavIndex)
          .collection(channel)
          .snapshots();
  }

  Future<void> addUserToDatabase(DateTime dob, String college) async {
    User currentUser = firebaseAuth.currentUser;
    String myColor = titleColors[Random().nextInt(7)];
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
        'color': myColor,
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
    }).then((value) async {
      value.collection('peoples').add({
        'access': 'creator',
        'color': myColor,
        'push notification': true,
        'uid': firebaseAuth.currentUser.uid,
        'rating': -1.0
      });
      String link = await _createDynamicLink(value.id, dp, title);
      value.update({'link': link});
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

  Future<String> _createDynamicLink(String id, String dp, String title) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://sensei7.page.link',
        link:
            Uri.parse('https://github.com/team-o7/solution-challenge/?id=$id'),
        androidParameters: AndroidParameters(
          packageName: 'com.prakash.sensei',
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            imageUrl: Uri.parse(dp),
            title: 'Hey! Join this topic: $title on sensei App',
            description:
                'Sensei is a communication platform which enables anyone to share their knowledge from anywhere'));

    Uri url;

    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    url = shortLink.shortUrl;

    return url.toString();
  }
}
