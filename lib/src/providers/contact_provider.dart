import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/services/firestore_service.dart';

final contactListProvider =
    StateNotifierProvider<ContactNotifier, List<Contact>>(
  (ref) => ContactNotifier(),
);

class ContactNotifier extends StateNotifier<List<Contact>> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ContactNotifier() : super([]);

  Future<void> addContact(String name, String phoneNumber) async {
    if (state.any((contact) => contact.phoneNumber == phoneNumber)) {
      return;
    }

    await _firestoreService.addEmergencyContact(
      _firebaseAuth.currentUser!.uid,
      name,
      phoneNumber,
    );
    state = [...state, Contact(name, phoneNumber)];
  }

  void updateContacts(List<Contact> contacts) async {
    state = contacts;
  }

  void removeContact(String number) async {
    await _firestoreService.deleteEmergencyContact(
      _firebaseAuth.currentUser!.uid,
      number,
    );
    state.removeWhere((contact) => contact.phoneNumber == number);
  }
}
