// Package imports:
import 'package:twilio_flutter/twilio_flutter.dart';

class TwilioService {
  // TODO: use env variables for release
  static TwilioFlutter twilio = TwilioFlutter(
    accountSid: '',
    authToken: '',
    twilioNumber: '+',
  );

  static void sendMessage(String phoneNumber, messageBody) async {
    twilio.sendSMS(toNumber: phoneNumber, messageBody: messageBody);
  }
}
