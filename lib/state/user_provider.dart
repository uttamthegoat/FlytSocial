import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  dynamic curUser = <String, dynamic>{
    "name": "",
    "email": "",
    "imageUrl": "",
    "bio": "",
    "username": "",
  };
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user;
  get curentUser => curUser;

  UserProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    curUser = {
    "name": "",
    "email": "",
    "imageUrl": "",
    "bio": "",
    "username": "",
  };
    notifyListeners();
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
        // database code
        final newUser = <String, dynamic>{
          "name": _user?.displayName,
          "email": _user?.email,
          "imageUrl": _user?.photoURL,
          "bio": "",
          "username": _user != null
              ? await generateUsername(_user?.displayName)
              : _user?.email,
        };
        if (!(await emailExists(_user?.email))) {
          final db = FirebaseFirestore.instance;
          db.collection("users").add(newUser).then((DocumentReference doc) =>
              print('DocumentSnapshot added with ID: ${doc.id}'));
        }
        curUser = newUser;
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

  Future<String> generateUsername(String? name) async {
    if (name != null) {
      String sanitized = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
      if (sanitized.isEmpty) {
        throw ArgumentError(
            "Name must contain at least one alphanumeric character or underscore.");
      }

      // Function to check if username exists in Firestore
      Future<bool> usernameExists(String username) async {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .get();
        return snapshot.docs.isNotEmpty;
      }

      String username;
      bool exists;

      do {
        int randomNumber =
            Random().nextInt(10000); // Generates a number between 0 and 9999
        username = "${sanitized}_$randomNumber";
        exists = await usernameExists(username);
      } while (exists);

      return username;
    }
    return "";
  }

  Future<bool> emailExists(String? email) async {
    if (email == null) return false;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
