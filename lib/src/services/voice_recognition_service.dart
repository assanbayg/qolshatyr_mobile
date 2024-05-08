import 'dart:async';
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
            print('Initialization error: $val');
            if (val.errorMsg == 'error_no_match' ||
                val.errorMsg == 'error_time_out') {
              // Если возникли ошибки error_no_match или error_time_out,
              // продолжаем прослушивание без остановки
              _startListening();
            } else {
              // В случае других ошибок останавливаем прослушивание
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
      onResult: (result) {
        _recognizedText = result.recognizedWords.toLowerCase();
        if (result.finalResult) {
          print(_recognizedText);
          _startListening();
        }
      },
    );
  }
}
