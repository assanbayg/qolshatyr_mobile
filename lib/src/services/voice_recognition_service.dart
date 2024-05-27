import 'dart:async';
import 'package:location/location.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/services/call_service.dart';
import 'package:qolshatyr_mobile/src/services/twilio_service.dart';
import 'package:qolshatyr_mobile/src/utils/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceRecognitionService {
  final _speech = stt.SpeechToText();

  bool _isListening = false;
  String _recognizedText = '';

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;

  Future<void> toggleListening() async {
    if (!_isListening) {
      bool available = false;
      while (!available) {
        available = await _speech.initialize(
          onError: (val) async {
            if (val.errorMsg == 'error_no_match' ||
                val.errorMsg == 'error_time_out') {
              _startListening();
            } else {
              _speech.stop();
              await Future.delayed(const Duration(seconds: 2));
            }
          },
        );
      }
      _startListening();
      _isListening = true;
    } else {
      _speech.stop();
      _isListening = false;
    }
  }

  void _startListening() {
    _speech.listen(
      onResult: (result) async {
        _recognizedText = result.recognizedWords.toLowerCase();
        if (_recognizedText.contains("help")) {
          List<Contact> contacts = await SharedPreferencesManager.getContacts();
          LocationData location =
              await SharedPreferencesManager.getLastLocation() as LocationData;
          if (contacts.isNotEmpty) {
            TwilioService.sendMessage(
                contacts.first.phoneNumber, 'HELP: $location (testing an app)');
            CallService.callNumber(contacts.first.phoneNumber);
          }
        }
        if (result.finalResult) {
          _startListening();
        }
      },
    );
  }
}
