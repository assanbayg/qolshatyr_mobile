// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';

final contactListProvider =
    StateNotifierProvider<ContactNotifier, List<Contact>>(
  (ref) => ContactNotifier(),
);

class ContactNotifier extends StateNotifier<List<Contact>> {
  ContactNotifier() : super([]) {
    _loadContactsFromSharedPreferences();
  }

  Future<void> _loadContactsFromSharedPreferences() async {
    List<Contact> contacts = await SharedPreferencesManager.getContacts();
    state = contacts;
  }

  Future<void> addContact(
    String name,
    String phoneNumber,
    String tgUsername,
  ) async {
    if (state.any((contact) => contact.phoneNumber == phoneNumber)) {
      return;
    }

    state = [
      ...state,
      Contact(
        name: name,
        phoneNumber: phoneNumber,
        tgUsername: tgUsername,
      )
    ];
    SharedPreferencesManager.saveContacts(state);
  }

  void updateContacts(List<Contact> contacts) async {
    state = contacts;
    SharedPreferencesManager.saveContacts(contacts);
  }

  void updateContact(Contact updatedContact) {
    state = [
      for (var contact in state)
        if (contact.phoneNumber == updatedContact.phoneNumber)
          updatedContact
        else
          contact,
    ];
  }

  void removeContact(String number) async {
    List<Contact> updatedContacts =
        state.where((contact) => contact.phoneNumber != number).toList();

    state = updatedContacts;
    SharedPreferencesManager.saveContacts(updatedContacts);
  }
}
