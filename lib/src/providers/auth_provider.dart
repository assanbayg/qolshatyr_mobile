import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qolshatyr_mobile/src/services/auth_service.dart';

final authService = Provider<AuthServive>((ref) {
  return AuthServive();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authService).authStateChange;
});

final fireBaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});
