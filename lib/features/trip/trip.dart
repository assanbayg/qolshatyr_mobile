// Package imports:
import 'package:location/location.dart';

class Trip {
  final LocationData startLocation;
  final LocationData endLocation;
  final Duration estimateDuration;
  final DateTime startTime;
  final DateTime endTime = DateTime(2024);
  bool isOngoing;

  Trip({
    required this.startLocation,
    required this.endLocation,
    required this.estimateDuration,
    required this.startTime,
    required this.isOngoing,
  });

  factory Trip.empty() {
    return Trip(
      startLocation: LocationData.fromMap({
        'latitude': 0.0,
        'longitude': 0.0,
      }),
      endLocation: LocationData.fromMap({
        'latitude': 0.0,
        'longitude': 0.0,
      }),
      estimateDuration: const Duration(minutes: 0),
      startTime: DateTime.now(),
      isOngoing: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_location': {
        'latitude': startLocation.latitude,
        'longitude': startLocation.longitude,
      },
      'end_location': {
        'latitude': endLocation.latitude,
        'longitude': endLocation.longitude,
      },
      'estimate_duration': estimateDuration.inMinutes,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime.millisecondsSinceEpoch,
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      startLocation: LocationData.fromMap({
        'latitude': json['start_location']['latitude'],
        'longitude': json['start_location']['longitude'],
      }),
      endLocation: LocationData.fromMap({
        'latitude': json['end_location']['latitude'],
        'longitude': json['end_location']['longitude'],
      }),
      estimateDuration: Duration(minutes: json['estimate_duration']),
      startTime: DateTime.fromMillisecondsSinceEpoch(json['start_time']),
      isOngoing: false,
    );
  }

  @override
  String toString() {
    return 'Trip(startLocation: $startLocation, endLocation: $endLocation, estimateDuration: $estimateDuration, startTime: $startTime, endTime: $endTime)';
  }
}
