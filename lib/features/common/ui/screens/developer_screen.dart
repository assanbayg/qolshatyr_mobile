// FOR TESTING PURPOSES ONLY

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/telegram_service.dart';
import 'package:qolshatyr_mobile/features/common/ui/screens/video_recording_screen.dart';

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

    void backgroundVideo() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const VideoRecordingScreen();
      }));
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
              ElevatedButton(
                  onPressed: backgroundVideo,
                  child: const Text('Videorecording TEST'))
            ],
          ),
        ),
      ),
    );
  }
}
