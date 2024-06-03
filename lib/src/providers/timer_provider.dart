import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qolshatyr_mobile/src/utils/shared_preferences.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});

final checkInProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier() : super(0) {
    _timerController.stream.listen((event) {
      state = event;
    });
  }

  final StreamController<int> _timerController = StreamController<int>();
  Timer? _timer;
  Duration _duration = Duration.zero;

  void startTimer(Duration duration) {
    _timer?.cancel();
    _duration = duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration -= const Duration(seconds: 1);
        _timerController.add(_duration.inSeconds);
      } else {
        _timer?.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerController.close();
    super.dispose();
  }
}

class CheckinTimerNotifier extends StateNotifier<int> {
  CheckinTimerNotifier() : super(0) {
    _timerController.stream.listen((event) {
      state = event;
    });
  }

  final StreamController<int> _timerController = StreamController<int>();
  Timer? _timer;
  Duration _duration = Duration.zero;

  void startTimer() async {
    _timer?.cancel();
    _duration = Duration(minutes: SharedPreferencesManager.getTimerDuration()!);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration -= const Duration(seconds: 1);
        _timerController.add(_duration.inSeconds);
      } else {
        _timer?.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerController.close();
    super.dispose();
  }
}