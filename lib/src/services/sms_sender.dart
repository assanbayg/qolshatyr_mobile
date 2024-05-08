import 'package:flutter/services.dart';

// NOT USED
// long story short: i didn't know how to message directly without phone dialer therefore i wrote this code
// but it doesn't work the way i expected therefore it's not used for know (huh?)

// This class provides a way to send SMS messages without user interaction
// when user has no access to their phone in emergency sitations
// It uses a platform channel to communicate with native code on the device.
class SmsSender {
  // The platform channel name. This should match the channel name
  // registered on the native side (e.g., Android and iOS).
  static const platform = MethodChannel('com.example.sms_sender');

  // Sends an SMS message to the specified phone number with the given message.
  // This method uses platform channels to communicate with native code
  // which can then send the SMS message.
  static Future<void> sendSms(String phoneNumber, String message) async {
    try {
      // Calls the 'sendSms' method on the platform channel, passing the phone number and message as arguments.
      await platform.invokeMethod('sendSms', <String, dynamic>{
        'phoneNumber': phoneNumber,
        'message': message,
      });
    } on PlatformException {
      // Catches platform exceptions and prints an error message if sending fails.
    }
  }
}
