import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  bool get isAuthenticated => true;
  dynamic get currentUser => null;
  
  Future<bool> signIn(String email, String password) async => true;
  Future<bool> signInAnonymously() async => true;
  Future<void> signOut() async {}
}
