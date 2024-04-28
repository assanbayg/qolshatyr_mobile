import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qolshatyr_mobile/src/models/trip.dart';

final currentPositionProvider = StateProvider<LatLng?>((ref) => LatLng(0, 0));
final tripProvider = StateNotifierProvider((ref) => TripNotifier());

class TripNotifier extends StateNotifier<Trip> {
  TripNotifier() : super(Trip.empty());

  void addTrip(LocationData startLocation, Duration estimateDuration) {
    final newTrip = Trip(
      startLocation: startLocation,
      endLocation: state.endLocation,
      estimateDuration: estimateDuration,
      startTime: DateTime.now(),
    );
    state = newTrip;
  }

  void updateEndLocation(LocationData newEndLocation) {
    final updatedTrip = Trip(
      startLocation: state.startLocation,
      endLocation: newEndLocation,
      estimateDuration: state.estimateDuration,
      startTime: state.startTime,
    );
    state = updatedTrip;
  }
}
