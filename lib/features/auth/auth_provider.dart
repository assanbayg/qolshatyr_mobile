// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/auth/auth_service.dart';
import 'package:qolshatyr_mobile/features/common/services/firestore_service.dart';

// Provides AuthService instance with methods for signing in and out (firebase_auth).
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Provides a stream of the currently logged-in user or null (firebase_auth).
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChange;
});

// Provides an instance of FirebaseAuth (firebase_auth).
final fireBaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Provides a Future that completes when the Firebase app is initialized (firebase_core).
final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});

// Provides an instance of FirestoreService (custom service class).
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});
