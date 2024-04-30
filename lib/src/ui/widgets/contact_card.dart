import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';

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
              onPressed: () {
                // TODO: add visibility support for riverpod
              },
              icon: const Icon(Icons.visibility),
            ),
            IconButton(
              onPressed: () {
                ref
                    .read(contactListProvider.notifier)
                    .removeContact(contact.phoneNumber);
              },
              icon: const Icon(Icons.remove),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(contact.phoneNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
