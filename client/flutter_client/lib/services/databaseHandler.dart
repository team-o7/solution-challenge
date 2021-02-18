import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_client/services/authProvider.dart';

class DatabaseHandler {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthProvider authProvider = new AuthProvider();

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

  Future<void> addUserToDatabase(
      String userName, String firstName, String lastName) async {
    User currentUser = await authProvider.currentUser();
    if (currentUser != null) {
      firestore.collection('users').add({
        'userName': userName,
        'uid': currentUser.uid,
        'dp': currentUser.photoURL,
        'firstName': firstName,
        'lastName': lastName,
        'email': currentUser.email
      });
    } else
      throw 'No signed in user';
  }
}
