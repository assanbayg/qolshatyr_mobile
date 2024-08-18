// Package imports:
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/trip/models/trip.dart';

class TripWithPlacemark extends Trip {
  final Placemark startPlacemark;
  final Placemark endPlacemark;

  TripWithPlacemark({
    required super.startLocation,
    required super.endLocation,
    required super.estimateDuration,
    required super.startTime,
    required super.endTime,
    required super.isOngoing,
    required this.startPlacemark,
    required this.endPlacemark,
  });

  factory TripWithPlacemark.empty() {
    return TripWithPlacemark(
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
      isOngoing: true,
      startPlacemark: const Placemark(),
      endPlacemark: const Placemark(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final parentJson = super.toJson();
    parentJson.addAll({
      'start_placemark': {
        'name': startPlacemark.name,
        'street': startPlacemark.street,
        'locality': startPlacemark.locality,
        'postalCode': startPlacemark.postalCode,
        'country': startPlacemark.country,
        'administrativeArea': startPlacemark.administrativeArea,
      },
      'end_placemark': {
        'name': endPlacemark.name,
        'street': endPlacemark.street,
        'locality': endPlacemark.locality,
        'postalCode': endPlacemark.postalCode,
        'country': endPlacemark.country,
        'administrativeArea': endPlacemark.administrativeArea
      },
    });
    return parentJson;
  }

  factory TripWithPlacemark.fromJson(Map<String, dynamic> json) {
    return TripWithPlacemark(
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
      startPlacemark: Placemark(
        name: json['start_placemark']['name'],
        street: json['start_placemark']['street'],
        locality: json['start_placemark']['locality'],
        postalCode: json['start_placemark']['postalCode'],
        country: json['start_placemark']['country'],
        administrativeArea: json['start_placemark']['administrativeArea'],
      ),
      endPlacemark: Placemark(
        name: json['end_placemark']['name'],
        street: json['end_placemark']['street'],
        locality: json['end_placemark']['locality'],
        postalCode: json['end_placemark']['postalCode'],
        country: json['end_placemark']['country'],
        administrativeArea: json['end_placemark']['administrativeArea'],
      ),
    );
  }

  @override
  String toString() {
    return 'TripWithPlacemark(${super.toString()}, startPlacemark: $startPlacemark, endPlacemark: $endPlacemark)';
  }
}
