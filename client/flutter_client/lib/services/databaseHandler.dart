import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';

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
        'friendRequest': [],
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

  Future<void> createTopic(
      String description, String title, bool isPrivate, String dp) {
    firestore.collection('topics').add({
      'creator': firebaseAuth.currentUser.uid,
      'description': description,
      'dp': dp,
      'avgRating': 0,
      'title': title,
      'requests': [],
      'peoples': [
        {
          'access': 'creator',
          'push notification': true,
          'uid': firebaseAuth.currentUser.uid,
          'rating': 0
        }
      ],
      'private': isPrivate
    }).then((value) {
      value.update({'id': value.id});
      value.collection('adminChannels').add({'title': 'Announcements'});
      value.collection('adminChannels').add({'title': 'Documents'});
      value.collection('privateChannels').add({
        'title': 'Suggestion',
        'peoples': [
          {
            'uid': firebaseAuth.currentUser.uid,
            'access': 'readwrite' //readonly
          }
        ]
      });
      value.collection('publicChannels').add({'title': title});
      value.collection('publicChannels').add({'title': 'General'});
    });
  }
}
