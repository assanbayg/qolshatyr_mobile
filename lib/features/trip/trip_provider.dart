// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/geocoding_service.dart';
import 'package:qolshatyr_mobile/features/trip/models/trip.dart';
import 'package:qolshatyr_mobile/features/trip/models/trip_with_placemark.dart';

// Provides user's current position
final currentPositionProvider =
    StateProvider<LatLng?>((ref) => const LatLng(0, 0));
// Provides active trip instance
final tripProvider = StateNotifierProvider((ref) => TripNotifier());

class TripNotifier extends StateNotifier<Trip> {
  TripNotifier() : super(Trip.empty());

  // Adds a new trip that is stored locally
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

    try {
      final startPlacemark =
          await GeocodingService.translateFromLatLng(startLocation);
      final endPlacemark =
          await GeocodingService.translateFromLatLng(endLocation);

      final newTripWithPlacemark = TripWithPlacemark(
        startLocation: startLocation,
        endLocation: endLocation,
        estimateDuration: estimateDuration,
        startTime: newTrip.startTime,
        endTime: newTrip.endTime,
        isOngoing: newTrip.isOngoing,
        startPlacemark: startPlacemark,
        endPlacemark: endPlacemark,
      );

      state = newTrip;

      // TODO: add new trip to sqflite
    } catch (e) {
      // TODO: handle error and display something to users
    }
  }

  // Updates final location when user taps on map
  void updateEndLocation(LocationData newEndLocation) {
    final updatedTrip = state.copyWith(endLocation: newEndLocation);
    state = updatedTrip;
  }

  // Updates trip status if estimated arrival duration ticks
  void updateStatus(bool newStatus) {
    final updatedTrip = state.copyWith(isOngoing: newStatus);
    state = updatedTrip;
  }

  bool get isOngoing => state.isOngoing;
  Duration get estimateDuration => state.estimateDuration;
  Trip get latestTrip => state;
}
