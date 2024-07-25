// Package imports:
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/twilio_service.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';

class CallService {
  static void callNumber(String phoneNumber) async {
    LocationData location =
        await SharedPreferencesManager.getLastLocation() as LocationData;
    TwilioService.sendMessage(phoneNumber.trim(),
        'Help me lat:${location.latitude} long:${location.longitude}!');
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}
