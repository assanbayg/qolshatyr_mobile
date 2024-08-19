// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';
import 'package:qolshatyr_mobile/features/contacts/providers/contact_provider.dart';

// Project imports:

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
