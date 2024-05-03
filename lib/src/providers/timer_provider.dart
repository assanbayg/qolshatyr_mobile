import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier() : super(0);

  Timer? _timer;

  void startTimer(Duration duration) {
    print('STARTED');
    _timer?.cancel();
    _timer = Timer.periodic(duration, (timer) {
      state++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
