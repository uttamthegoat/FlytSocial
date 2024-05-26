import 'package:flutter/material.dart';

class AuthStateProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void authenticate() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void signOut() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
