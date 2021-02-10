import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Auth {
  String getExceptionText(Exception e) {
    if (e is FirebaseAuthException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'Email/Password not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'Network error.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        case 'We have blocked all requests from this device due to unusual activity. Try again later.':
          return 'Too many failed login attemps, please try again later.';
          break;
        default:
          return e.message;
      }
    } else {
      return 'Unknown error occured.';
    }
  }
}
