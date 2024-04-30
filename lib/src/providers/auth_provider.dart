import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qolshatyr_mobile/src/services/auth_service.dart';
import 'package:qolshatyr_mobile/src/services/firestore_service.dart';

final authServiceProvider = Provider<AuthServive>((ref) {
  return AuthServive();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChange;
});

final fireBaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});
