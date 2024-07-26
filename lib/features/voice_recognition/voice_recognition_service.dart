// Dart imports:
import 'dart:async';

// Package imports:
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/check_in_service.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';

class VoiceRecognitionService {
  final _speech = stt.SpeechToText();
  final CheckInService checkInService = CheckInService();

  final String? sosPhrase = SharedPreferencesManager.sosPhrase;

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
        if (_recognizedText.contains(sosPhrase!)) {
          checkInService.triggerSos();
        }
        if (result.finalResult) {
          _startListening();
        }
      },
    );
  }
}
