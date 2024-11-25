// FOR TESTING PURPOSES ONLY

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/telegram_service.dart';

class DeveloperScreen extends StatelessWidget {
  static const routeName = '/dev';
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void getChatId() async {
      final telegramService = TelegramService();
      final String res =
          await telegramService.getChatId('assanbayg') ?? 'NOT FOUND';

      if (res == 'NOT FOUND') {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Telegram contact is not found'),
              content: const Text(
                  'Make sure that username is correct or that the contact interacted with the bot'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      }

      telegramService.sendMessage(res, 'Hi');
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: getChatId,
                child: const Text('Telegram TEST'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
