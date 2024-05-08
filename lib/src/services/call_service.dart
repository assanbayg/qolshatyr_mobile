import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CallService {
  static void callNumber(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}
