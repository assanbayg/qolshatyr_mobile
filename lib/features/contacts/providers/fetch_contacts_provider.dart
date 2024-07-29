// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/auth/auth_provider.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';

final fetchContactsProvider = FutureProvider<List<Contact>>((ref) async {
  final firestoreService = ref.read(firestoreServiceProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final userId = firebaseAuth.currentUser?.uid;
  if (userId != null) {
    return firestoreService.getEmergencyContacts(userId);
  } else {
    return [];
  }
});
