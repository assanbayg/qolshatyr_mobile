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
      bool available = await _speech.initialize(
        onError: (error) => print('Initialization error: $error'),
      );
      if (available) {
        _startListening();
        _isListening = true;
      }
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
          // okay now i'm sure that it stil listens to words, huh?
          _startListening();
        }
      },
    );
  }
}
