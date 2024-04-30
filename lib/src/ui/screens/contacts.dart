import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/auth_provider.dart';

import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/contact_card.dart';

class ContactsScreen extends ConsumerWidget {
  static const routeName = '/base/contacts';
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactListProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
            onPressed: () {
              final authService = ref.read(fireBaseAuthProvider);
              final firestoreService = ref.read(firestoreServiceProvider);
              firestoreService
                  .getEmergencyContacts(authService.currentUser!.uid);
            },
            child: Text("BUTTON")),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.account_circle_rounded, size: 80),
                Expanded(
                  child: Text(
                    'Emergency Contacts Call',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (contacts.isNotEmpty)
          ...contacts.map(
            (contact) => ContactCard(contact: contact),
          ),
      ],
    );
  }
}
