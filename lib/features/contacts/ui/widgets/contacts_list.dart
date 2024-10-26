// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/telegram_service.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';
import 'package:qolshatyr_mobile/features/contacts/ui/widgets/contact_card.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;
  final AppLocalizations localization;
  const ContactsList({
    super.key,
    required this.contacts,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60),
        child: Text(
          localization.noEmergencyContacts,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              await _updateAllChatIds(context);
            },
            child: const Text('Update Chat Ids'),
          ),
        ),
        SizedBox(
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              children: contacts
                  .map((contact) => ContactCard(contact: contact))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // update all chat IDs
  Future<void> _updateAllChatIds(BuildContext context) async {
    final telegramService = TelegramService();
    for (var contact in contacts) {
      if (contact.tgUsername.isNotEmpty) {
        final chatId = await telegramService.getChatId(contact.tgUsername);
        if (chatId != null) {
          await SharedPreferencesManager.updateContactChatId(
            contact.phoneNumber,
            chatId,
          );
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat Ids updated')),
    );
  }
}
