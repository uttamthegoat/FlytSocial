import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user;

  UserProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(googleProvider);

      // Ensure the user's authentication state is updated
      await _auth.currentUser!.reload();

      if (_auth.currentUser?.emailVerified ?? false) {
        notifyListeners();
      } else {
        print('User email is not verified.');
        // Optionally handle the case where the email is not verified
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
  }

// this is in use
  Future<void> signIn() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      // _user = (await FirebaseAuth.instance.signInWithCredential(credential)) as User;
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _onAuthStateChanged(userCredential.user);

      if (_user?.emailVerified ?? false) {
        notifyListeners();
      } else {
        print('User email is not verified.');
        // Optionally handle the case where the email is not verified
      }
    } catch (error) {
      print("error");
      // toast a message saying error
    }
  }
}
