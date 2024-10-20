// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:location/location.dart';

class Trip {
  final LocationData startLocation;
  final LocationData endLocation;
  final Duration estimateDuration;
  final DateTime startTime;
  final DateTime endTime;
  bool isOngoing;
  final Uint8List? image;
  final List<Uint8List?> checkInImages; // Изображения чек-инов

  Trip({
    required this.startLocation,
    required this.endLocation,
    required this.estimateDuration,
    required this.startTime,
    required this.endTime,
    required this.isOngoing,
    this.image,
    this.checkInImages = const [], // добавляем параметр
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
      endTime: DateTime.now(),
      isOngoing: false,
      image: null, //empty image
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
      'is_ongoing': isOngoing,
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
      endTime: DateTime.fromMillisecondsSinceEpoch(json['end_time']),
      isOngoing: json['is_ongoing'],
    );
  }

  Trip copyWith({
    LocationData? startLocation,
    LocationData? endLocation,
    Duration? estimateDuration,
    DateTime? startTime,
    DateTime? endTime,
    bool? isOngoing,
    Uint8List? image,
  }) {
    return Trip(
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      estimateDuration: estimateDuration ?? this.estimateDuration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isOngoing: isOngoing ?? this.isOngoing,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'Trip(startLocation: $startLocation, endLocation: $endLocation, estimateDuration: $estimateDuration, startTime: $startTime, endTime: $endTime, isOngoing: $isOngoing)';
  }
}
