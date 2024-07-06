// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/services/firestore_service.dart';
import 'package:qolshatyr_mobile/src/utils/shared_preferences.dart';

// This Provider holds a list of Contact objects and provides functions to manage them.
final contactListProvider =
    StateNotifierProvider<ContactNotifier, List<Contact>>(
  (ref) => ContactNotifier(),
);

class ContactNotifier extends StateNotifier<List<Contact>> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Initial state is set to an empty list.
  ContactNotifier() : super([]) {
    _loadContactsFromSharedPreferences();
  }

  // Adds a new contact to the state and Firestore database.
  // Checks for duplicates before adding.
  Future<void> addContact(String name, String phoneNumber) async {
    if (state.any((contact) => contact.phoneNumber == phoneNumber)) {
      return;
    }
    // Updates the state with the new list including the added contact.
    state = [...state, Contact(name, phoneNumber)];

    SharedPreferencesManager.saveContacts(state);
    await _firestoreService.addEmergencyContact(
      _firebaseAuth.currentUser!.uid,
      name,
      phoneNumber,
    );
  }

  // Updates the state with a new list of contacts.
  void updateContacts(List<Contact> contacts) async {
    state = contacts;
  }

  // Removes a contact from the state and Firestore database based on phone number.
  void removeContact(String number) async {
    // Updates the state with the filtered list after removing the contact.
    state.removeWhere((contact) => contact.phoneNumber == number);

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
