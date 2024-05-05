import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier() : super(0) {
    _timerController.stream.listen((event) {
      state = event;
    });
  }

  final _timerController = StreamController<int>();
  Timer? _timer;
  Duration _duration = Duration.zero;

  void startTimer(Duration duration) {
    _timer?.cancel();
    _duration = duration;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration = _duration - Duration(seconds: 1);
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
