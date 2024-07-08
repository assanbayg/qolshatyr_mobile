// Package imports:
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/services/twilio_service.dart';
import 'package:qolshatyr_mobile/src/utils/shared_preferences.dart';

class CallService {
  static void callNumber(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);

    LocationData location =
        await SharedPreferencesManager.getLastLocation() as LocationData;
    TwilioService.sendMessage(phoneNumber,
        'Help me lat:${location.latitude} long:${location.longitude}!');
  }
}
