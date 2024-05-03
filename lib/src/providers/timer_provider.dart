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

  void startTimer(Duration duration) {
    _timer?.cancel();
    _timer = Timer.periodic(duration, (timer) {
      _timerController.add(state + 1);
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
