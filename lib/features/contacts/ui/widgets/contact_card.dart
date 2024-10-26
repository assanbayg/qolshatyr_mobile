// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';
import 'package:qolshatyr_mobile/features/contacts/providers/contact_provider.dart';

class ContactCard extends ConsumerWidget {
  final Contact contact;

  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text(contact.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                ref
                    .read(contactListProvider.notifier)
                    .removeContact(contact.phoneNumber);
              },
              icon: const Icon(Icons.remove),
            ),
            IconButton(
              onPressed: () {
                _editTelegramUsername(context, ref);
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Number: ${contact.phoneNumber}'),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      'Telegram: ${contact.tgUsername.isEmpty ? "not added" : contact.tgUsername}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editTelegramUsername(BuildContext context, WidgetRef ref) {
    final TextEditingController usernameController = TextEditingController();
    usernameController.text = contact.tgUsername;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Telegram Username'),
          content: TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Telegram Username'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update contact's Telegram username
                ref.read(contactListProvider.notifier).updateContact(
                      contact.copyWith(tgUsername: usernameController.text),
                    );

                await SharedPreferencesManager.updateContactTelegramUsername(
                    contact.phoneNumber, usernameController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
