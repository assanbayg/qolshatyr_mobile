import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/providers/contact_provider.dart';

class ContactCard extends ConsumerWidget {
  final Contact contact;

  const ContactCard({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactList = ref.watch(contactListProvider);

    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text(contact.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ToDo: add visibility support for riverpod
            IconButton(onPressed: () {}, icon: Icon(Icons.visibility)),
            IconButton(
              onPressed: () {
                ref
                    .read(contactListProvider.notifier)
                    .removeContact(contact.id);
              },
              icon: Icon(Icons.remove),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.phoneNumber),
                Text(contact.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
