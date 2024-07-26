// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/firestore_service.dart';
import 'package:qolshatyr_mobile/features/common/ui/widgets/dialogs.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firecloudService = FirestoreService();

  Stream<User?> get authStateChange => _auth.authStateChanges();

  // Signs in a user with email and password.
  // Displays an error dialog if there's an issue.
  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showAuthExceptionsDialog(context, 'Error Occurred', e.toString());
      }
    }
  }

  // Signs up a user with email and password.
  // Adds the user to a Firestore collection after successful signup.
  // Displays an error dialog if there's an issue.
  Future<void> signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firecloudService.addUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showAuthExceptionsDialog(context, 'Error Occurred', e.toString());
      }
    } catch (e) {
      if (e == 'email-already-in-use') {
        if (context.mounted) {
          showAuthExceptionsDialog(
              context, 'Email already in use', e.toString());
        }
      }
    }
  }

  // Signs out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
