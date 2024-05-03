import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/providers/timer_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceRecognitionScreen extends StatefulWidget {
  static const routeName = '/base/sos/';
  const VoiceRecognitionScreen({super.key});

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen> {
  final _timerStreamController = StreamController<DateTime>();
  final _speech = stt.SpeechToText();

  bool _isListening = false;
  String _recognizedText = '';
  int _timerDuration = 1;

  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _timerStreamController.add(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerStreamController.close();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (error) => print('Initialization error: $error'),
      );
      print(available);
      if (available) {
        _startListening();
        setState(() => _isListening = true);
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  void _startListening() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords.toLowerCase();
          if (_recognizedText.contains('help')) {
            print('SOS');
            _makeEmergencyCall();
          }
        });
        if (result.finalResult) {
          _startListening();
        }
      },
    );
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

  // void _startTimer() {
  //   Timer.periodic(const Duration(seconds: 1), (Timer timer) {
  //     _timerStreamController.add(DateTime.now());
  //   });
  // }

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
          Text(
            _recognizedText,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _toggleListening,
            child: Text(_isListening ? 'Stop trip' : 'Start trip'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Set time (min):',
              ),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: _timerDuration,
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      _timerDuration = value;
                    });
                  }
                },
                items: List.generate(10, (index) => index + 1)
                    .map<DropdownMenuItem<int>>(
                      (int value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value min'),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(width: 10),
              StreamBuilder<DateTime>(
                stream: _timerStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int remainingSeconds =
                        _timerDuration * 60 - snapshot.data!.second;
                    int minutes = remainingSeconds ~/ 60;
                    int seconds = remainingSeconds % 60;
                    return Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 20),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
