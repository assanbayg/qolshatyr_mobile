/* ARCHIVED
initially i used twilio api for alerting emergency contacts
but it had 2 huge disadvantages: 1. it's hella expensive 2. it doesn't really support media files
therefore 8 months later i decided to migrate to telegram api. hope i won't regret it later

cheers, gauhar. 26/10/2024
*/
/*
// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:twilio_flutter/twilio_flutter.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/twilio_options.dart';

class TwilioService {
  final String accountSid = TwilioOptions.accountSid;
  final String authToken = TwilioOptions.authToken;
  final String twilioNumber = TwilioOptions.twilioNumber;

  static TwilioFlutter twilio = TwilioFlutter(
    accountSid: TwilioOptions.accountSid,
    authToken: TwilioOptions.authToken,
    twilioNumber: TwilioOptions.twilioNumber,
  );

  // static void sendMessage(String phoneNumber, messageBody) async {
  //   twilio.sendSMS(toNumber: phoneNumber, messageBody: messageBody);
  // }

  Future<void> sendMessage(String toPhoneNumber, String message) async {
    final url = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');

    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'From': twilioNumber,
        'To': toPhoneNumber,
        'Body': message,
      },
    );

    if (response.statusCode == 201) {
      log('SMS sent successfully!');
    } else {
      log('Failed to send SMS: ${response.statusCode} - ${response.body}');
    }
  }

  static void sendWhatsApp(String phoneNumber, messageBody) async {
    twilio.sendWhatsApp(toNumber: phoneNumber, messageBody: messageBody);
  }
}
*/