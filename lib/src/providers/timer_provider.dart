import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// This Provider holds the trip duration timer value (in seconds)
// and provides functions to manage it.
final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});

// Similar to timerProvider, but used for periodic check ins
// to ensure that user is still safe
final checkInProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<int> {
  // Initial state is set to 0 seconds.
  TimerNotifier() : super(0) {
    // Listens to the stream emitted by the _timerController and updates the state with the latest value.
    _timerController.stream.listen((event) {
      state = event;
    });
  }

  // Internal StreamController to emit timer updates.
  final StreamController<int> _timerController = StreamController<int>();

  // Timer object used for periodic updates.
  Timer? _timer;

  // Stores the current timer duration.
  Duration _duration = Duration.zero;

  // Starts a timer with the specified duration (in seconds).
  void startTimer(Duration duration) {
    // Cancels any existing timer before starting a new one.
    _timer?.cancel();
    _duration = duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration = _duration - const Duration(seconds: 1);

        _timerController.add(_duration.inSeconds);
      } else {
        // Cancels the timer if the duration reaches zero.
        _timer?.cancel();
      }
    });
  }

  // Stops the timer.
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Cancels the timer and closes the stream controller when disposing the provider.
  @override
  void dispose() {
    _timer?.cancel();
    _timerController.close();
    super.dispose();
  }
}
