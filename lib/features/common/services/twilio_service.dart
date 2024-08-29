// Package imports:
import 'package:twilio_flutter/twilio_flutter.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/twilio_options.dart';

class TwilioService {
  static TwilioFlutter twilio = TwilioFlutter(
    accountSid: TwilioOptions.accounntSid,
    authToken: TwilioOptions.authToken,
    twilioNumber: TwilioOptions.twilioNumber,
  );

  static void sendMessage(String phoneNumber, messageBody) async {
    twilio.sendSMS(toNumber: phoneNumber, messageBody: messageBody);
  }

  static void sendWhatsApp(String phoneNumber, messageBody) async {
    twilio.sendWhatsApp(toNumber: phoneNumber, messageBody: messageBody);
  }
}
