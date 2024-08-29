// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/auth/auth_provider.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';

// I don't remember why i created this provider in the first place
// initially it should had sync local stored contacts with firebase however it seems
// inefficient to me

// it won't be used until i start cleaning whole code base and will use riverpod providers
// according to their purpose

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
