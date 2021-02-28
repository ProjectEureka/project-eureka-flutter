import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = result.user;
    return user.uid;
  }

  User getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }

  Future<void> forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteUser() async {
    User user = _auth.currentUser;
    await user.delete();
  }

  Future<void> updateEmail(String email) async {
    User user = _auth.currentUser;
    await user.updateEmail(email);
  }

  Future<void> updatePassword(String password) async {
    User user = _auth.currentUser;
    await user.updatePassword(password);
  }
}
