import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qolshatyr_mobile/src/services/voice_recognition_service.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/voice_recognition_widgets.dart';

class VoiceRecognitionScreen extends StatefulWidget {
  static const routeName = '/base/sos/';
  const VoiceRecognitionScreen({super.key});

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen> {
  final _timerStreamController = StreamController<DateTime>();
  final _voiceRecognitionService = VoiceRecognitionService();

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _timerStreamController.close();
    super.dispose();
  }

  Future<void> _makeEmergencyCall() async {
    final Uri url = Uri(
        scheme: 'https',
        host: 'dart.dev',
        path: 'guides/libraries/library-tour',
        fragment: 'numbers');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Recognized text:',
          ),
          const SizedBox(height: 10),
          RecognizedText(_voiceRecognitionService.recognizedText),
          const SizedBox(height: 20),
          ListeningButton(
            isListening: _voiceRecognitionService.isListening,
            onPressed: _voiceRecognitionService.toggleListening,
          ),
        ],
      ),
    );
  }
}
