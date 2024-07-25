class LoginFormValidation {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Invalid email!';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 8) {
      return 'Password is too short!';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value != password) {
      return 'Passwords do not match!';
    }
    return null;
  }
}
