import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';

final contactListProvider =
    StateNotifierProvider<ContactNotifier, List<Contact>>(
(ref) => ContactNotifier(),
);

class ContactNotifier extends StateNotifier<List<Contact>> {
  ContactNotifier() : super([]);

  void addContact(Contact newContact) {
    state = [...state, newContact];
  }

  void removeContact(String id) {
    state.removeWhere((contact) => contact.id == id);
  }
}
