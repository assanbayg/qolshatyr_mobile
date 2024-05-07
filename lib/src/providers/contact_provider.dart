import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/services/firestore_service.dart';

// This Provider holds a list of Contact objects and provides functions to manage them.
final contactListProvider =
    StateNotifierProvider<ContactNotifier, List<Contact>>(
  (ref) => ContactNotifier(),
);

class ContactNotifier extends StateNotifier<List<Contact>> {
  // Injects FirestoreService to interact with Firestore database.
  final FirestoreService _firestoreService = FirestoreService();

  // Gets the current user instance from Firebase Auth.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Initial state is set to an empty list.
  ContactNotifier() : super([]);

  // Adds a new contact to the state and Firestore database.
  // Checks for duplicates before adding.
  Future<void> addContact(String name, String phoneNumber) async {
    if (state.any((contact) => contact.phoneNumber == phoneNumber)) {
      return;
    }

    await _firestoreService.addEmergencyContact(
      _firebaseAuth.currentUser!.uid,
      name,
      phoneNumber,
    );
    // Updates the state with the new list including the added contact.
    state = [...state, Contact(name, phoneNumber)];
  }

  // Updates the state with a new list of contacts.
  void updateContacts(List<Contact> contacts) async {
    state = contacts;
  }

  // Removes a contact from the state and Firestore database based on phone number.
  void removeContact(String number) async {
    await _firestoreService.deleteEmergencyContact(
      _firebaseAuth.currentUser!.uid,
      number,
    );
    // Updates the state with the filtered list after removing the contact.
    state.removeWhere((contact) => contact.phoneNumber == number);
  }
}
