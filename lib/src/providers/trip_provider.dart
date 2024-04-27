import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:qolshatyr_mobile/src/models/trip.dart';

final currentPositionProvider = StateProvider<LocationData>((ref) {
  return LocationData.fromMap({
    'latitude': 0.0,
    'longitude': 0.0,
  });
});

final endPositionProvider = StateProvider<LocationData?>((ref) {
  return null;
});

final tripProvider = StateNotifierProvider((ref) => TripNotifier());

class TripNotifier extends StateNotifier<Trip> {
  TripNotifier() : super(Trip.empty());

  void addTrip(Trip trip) {
    print('ADD TRIP 2');
    state = trip;
  }
}
