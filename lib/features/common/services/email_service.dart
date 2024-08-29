// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/email_options.dart';

Future<void> sendEmail({
  required String senderEmail,
  required String subject,
  required String body,
}) async {
  final url = Uri.parse('$renderUrl/qolshatyr-send-email');

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'sender_email': senderEmail,
        'subject': subject,
        'body': body,
      },
    );

    if (response.statusCode == 200) {
      log('Email sent successfully: ${jsonDecode(response.body)}');
    } else {
      log('Failed to send email: ${response.body}');
    }
  } catch (e) {
    log('Error: $e');
  }
}
