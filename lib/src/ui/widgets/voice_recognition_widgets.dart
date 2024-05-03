import 'package:flutter/material.dart';

class RecognizedText extends StatelessWidget {
  final String text;

  const RecognizedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20),
    );
  }
}

class ListeningButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onPressed;

  const ListeningButton({super.key, required this.isListening, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(isListening ? 'Stop trip' : 'Start trip'),
    );
  }
}
