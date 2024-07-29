// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/firestore_service.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';

final contactListProvider =
    StateNotifierProvider<ContactNotifier, List<Contact>>(
  (ref) => ContactNotifier(),
);

class ContactNotifier extends StateNotifier<List<Contact>> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ContactNotifier() : super([]) {
    _loadContactsFromSharedPreferences();
  }

  Future<void> addContact(String name, String phoneNumber) async {
    if (state.any((contact) => contact.phoneNumber == phoneNumber)) {
      return;
    }

    state = [...state, Contact(name, phoneNumber)];

    SharedPreferencesManager.saveContacts(state);
    await _firestoreService.addEmergencyContact(
      _firebaseAuth.currentUser!.uid,
      name,
      phoneNumber,
    );
  }

  void updateContacts(List<Contact> contacts) async {
    state = contacts;
    SharedPreferencesManager.saveContacts(contacts);
  }

  void removeContact(String number) async {
    List<Contact> updatedContacts =
        state.where((contact) => contact.phoneNumber != number).toList();

    state = updatedContacts;

    SharedPreferencesManager.saveContacts(updatedContacts);
    await _firestoreService.deleteEmergencyContact(
      _firebaseAuth.currentUser!.uid,
      number,
    );
  }

  Future<void> _loadContactsFromSharedPreferences() async {
    List<Contact> contacts = await SharedPreferencesManager.getContacts();
    state = contacts;
  }
}
