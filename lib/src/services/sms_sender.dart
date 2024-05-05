import 'package:flutter/services.dart';

class SmsSender {
  static const platform = MethodChannel('com.example.sms_sender');

  static Future<void> sendSms(String phoneNumber, String message) async {
    try {
      await platform.invokeMethod('sendSms', <String, dynamic>{
        'phoneNumber': phoneNumber,
        'message': message,
      });
    } on PlatformException catch (e) {
      print("Failed to send SMS: '${e.message}'.");
    }
  }
}
