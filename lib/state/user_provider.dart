import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUser(String key, dynamic user) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonUser = jsonEncode(user);
  await prefs.setString(key, jsonUser);
}

Future<dynamic> getUser(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final userJson = prefs.getString(key);
  if (userJson == null) {
    final defaultUser = <String, dynamic>{
      "userId": "",
      "name": "",
      "email": "",
      "imageUrl": "",
      "bio": "",
      "username": "",
    };
    return defaultUser; // No user data found
  }
  return jsonDecode(userJson);
}

class UserProvider with ChangeNotifier {
  User? _user;
  dynamic curUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user;
  String? get currentUserId => curUser?['userId'];
  get currentUser => curUser;

  UserProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    curUser = {
      "userId": "",
      "name": "",
      "email": "",
      "imageUrl": "",
      "bio": "",
      "username": "",
    };
    _user = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('myMapKey');
    notifyListeners();
  }

  Future<void> signIn() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _onAuthStateChanged(userCredential.user);

      if (_user?.emailVerified ?? false) {
        var newUser = <String, dynamic>{
          "userId": "",
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
          DocumentReference docRef = await db.collection("users").add(newUser);
          newUser['userId'] = docRef.id;
        } else {
          final checkEmail = _user?.email;
          final snapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: checkEmail)
              .get();
          var userData = snapshot.docs.first.data();
          newUser['userId'] = snapshot.docs.first.id;
          newUser['name'] = userData['name'];
          newUser['email'] = userData['email'];
          newUser['imageUrl'] = userData['imageUrl'];
          newUser['bio'] = userData['bio'];
          newUser['username'] = userData['username'];
        }
        curUser = newUser;
        await storeUser('curUser', newUser);
        notifyListeners();
      } else {
        print('User email is not verified.');
      }
    } catch (error) {
      print("error: $error");
    }
  }

  Future<String> generateUsername(String? name) async {
    if (name != null) {
      String sanitized = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
      if (sanitized.isEmpty) {
        throw ArgumentError(
            "Name must contain at least one alphanumeric character or underscore.");
      }

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

  Future<void> setUserInfo() async {
    curUser = await getUser('curUser');
    notifyListeners();
  }
}
