// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/firestore_service.dart';
import 'package:qolshatyr_mobile/features/common/services/geocoding_service.dart';
import 'package:qolshatyr_mobile/features/trip/models/trip.dart';
import 'package:qolshatyr_mobile/features/trip/models/trip_with_placemark.dart';

// Provides user's current position
final currentPositionProvider =
    StateProvider<LatLng?>((ref) => const LatLng(0, 0));
// Provides active trip instance
final tripProvider = StateNotifierProvider((ref) => TripNotifier());

class TripNotifier extends StateNotifier<Trip> {
  final FirestoreService _firestoreService = FirestoreService();

  TripNotifier() : super(Trip.empty());

  // Adds a new trip to cloud firestore
  void addTrip(LocationData startLocation, Duration estimateDuration) async {
    LocationData endLocation = state.endLocation;

    final newTrip = Trip(
      startLocation: startLocation,
      endLocation: endLocation,
      estimateDuration: estimateDuration,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      isOngoing: true,
    );

    Placemark startPlacemark = await GeocodingService.translateFromLatLng(
      LocationData.fromMap({
        'latitude': startLocation.latitude,
        'longitude': startLocation.longitude
      }),
    );

    Placemark endPlacemark = await GeocodingService.translateFromLatLng(
      LocationData.fromMap({
        'latitude': endLocation.latitude,
        'longitude': endLocation.longitude
      }),
    );

    final TripWithPlacemark newTripWithPlacemark = TripWithPlacemark(
        startLocation: startLocation,
        endLocation: state.endLocation,
        estimateDuration: estimateDuration,
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        isOngoing: true,
        startPlacemark: startPlacemark,
        endPlacemark: endPlacemark);
    await _firestoreService.addTrip(newTripWithPlacemark.toJson());
    state = newTrip;
  }

  // Updates final location when user taps on map
  void updateEndLocation(LocationData newEndLocation) {
    final updatedTrip = Trip(
      startLocation: state.startLocation,
      endLocation: newEndLocation,
      estimateDuration: state.estimateDuration,
      startTime: state.startTime,
      endTime: state.endTime,
      isOngoing: state.isOngoing,
    );
    state = updatedTrip;
  }

  // Updates trip status if estimated arrival duration ticks
  void updateStatus(bool newStatus) {
    state.isOngoing = newStatus;
  }

  bool get isOngoing => state.isOngoing;
  Duration get estimateDuration => state.estimateDuration;
  Trip get latestTrip => state;
}
