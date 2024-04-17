import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error Occured'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(_).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(_).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      if (e == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Email is already in use'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(_).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {}
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
