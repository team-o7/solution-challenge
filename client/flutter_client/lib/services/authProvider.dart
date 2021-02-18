import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserCredential signedInUserCredential;

  Future<User> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  void signOut() async {
    await _firebaseAuth.signOut().then((value) {
      GoogleSignIn().signOut();
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    signedInUserCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return signedInUserCredential;
  }
}
