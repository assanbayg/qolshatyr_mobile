import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:qolshatyr_mobile/src/services/dialog_service.dart';
import 'package:qolshatyr_mobile/src/services/firestore_service.dart';

class AuthServive {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firecloudService = FirestoreService();

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        DialogService dialogService = DialogService();
        dialogService.showAuthExceptionsDialog(
          context,
          'Error Occured',
          e.toString(),
        );
      }
    }
  }

  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    DialogService dialogService = DialogService();
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firecloudService.addUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        dialogService.showAuthExceptionsDialog(
          context,
          'Error Occured',
          e.toString(),
        );
      }
    } catch (e) {
      if (e == 'email-already-in-use') {
        if (context.mounted) {
          dialogService.showAuthExceptionsDialog(
            context,
            'Email already in use',
            e.toString(),
          );
        }
      } else {}
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
