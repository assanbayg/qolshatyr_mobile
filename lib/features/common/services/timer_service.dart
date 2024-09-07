// Dart imports:
import 'dart:async';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/check_in_service.dart';

class TimerService {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;

  final CheckInService _tripCheckInService = CheckInService();
  Timer? _timer;

  TimerService._internal();

  void startTimer() {
    const duration = Duration(days: 3);
    _timer = Timer(duration, _deleteAllTrips);
  }

  Future<void> _deleteAllTrips() async {
    await _tripCheckInService.deleteAllTrips();
    print('All trips deleted after 3 days');
  }

  void cancelTimer() {
    _timer?.cancel();
    print('Timer cancelled');
  }
}
