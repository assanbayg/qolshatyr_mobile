// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/telegram_options.dart';

class TelegramService {
  final botToken = telegramBotToken;

// retrieve the chat id based on emergency contact telegram username
  Future<String?> getChatId(String tgUsername) async {
    final url = Uri.parse('https://api.telegram.org/bot$botToken/getUpdates');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final updates = json.decode(response.body);

      if (updates['result'].isNotEmpty) {
        // loop through each update to find the message from the username
        for (var update in updates['result']) {
          final message = update['message'];
          if (message != null && message['from']['username'] == tgUsername) {
            return message['chat']['id'].toString();
          }
        }
      }
    }
    return null;
  }

Future<void> sendMessage(String chatId, String message) async {
    final url = Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'chat_id': chatId, 'text': message}),
    );
    if (response.statusCode == 200) {
      log('Message sent successfully');
    } else {
      log('Failed to send message: ${response.statusCode}');
    }
  }
}
