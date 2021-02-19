import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';

class DatabaseHandler {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> userNameNotExist(String userName) async {
    bool isOkay = false;
    await firestore
        .collection('users')
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
          .then((value) => {
                if (value.docs.isNotEmpty) {isOkay = true}
              })
          .catchError((e) => throw e);
    }
    return isOkay;
  }

  Future<void> addUserToDatabase(DateTime dob, String college) async {
    User currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      firestore.collection('users').add({
        'userName': UiNotifier.userName,
        'uid': currentUser.uid,
        'dp': currentUser.photoURL,
        'firstName': UiNotifier.firstName,
        'lastName': UiNotifier.lastName,
        'email': currentUser.email,
        'dateOfBirth': dob,
        'college': college
      });
    } else
      throw 'No signed in user';
  }

  Future<void> updateUserDatabase({Map<String, dynamic> data}) async {
    QuerySnapshot snapshot = await firestore
        .collection('users')
        .where('uid', isEqualTo: firebaseAuth.currentUser.uid)
        .get()
        .catchError(() {
      throw 'Error finding user';
    });
    String id = snapshot.docs[0].id;
    await firestore.collection('users').doc(id).update(data).catchError(() {
      throw 'Error updating data';
    });
  }
}
