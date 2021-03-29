class FirebaseExceptionHandler {
  String getExceptionText(e) {
    switch (e.message) {
      case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        return 'Your email or password was not found.';
        break;
      case 'The password is invalid or the user does not have a password.':
        return 'The password you entered is invalid.';
        break;
      case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
        return 'Network error.';
        break;
      case 'The email address is already in use by another account.':
        return 'This email address already has an account.';
        break;
      case 'We have blocked all requests from this device due to unusual activity. Try again later.':
        return 'Too many failed login attempts, please try again later.';
        break;
      case 'Given String is empty or null':
        return 'Email required.';
        break;
      default:
        return e.message;
    }
  }
}
