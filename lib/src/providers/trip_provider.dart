import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:qolshatyr_mobile/src/models/trip.dart';
import 'package:qolshatyr_mobile/src/services/firestore_service.dart';

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
    final newTrip = Trip(
      startLocation: startLocation,
      endLocation: state.endLocation,
      estimateDuration: estimateDuration,
      startTime: DateTime.now(),
      isOngoing: true,
    );
    await _firestoreService.addTrip(newTrip.toJson());
    state = newTrip;
  }

  // Updates final location when user taps on map
  void updateEndLocation(LocationData newEndLocation) {
    final updatedTrip = Trip(
      startLocation: state.startLocation,
      endLocation: newEndLocation,
      estimateDuration: state.estimateDuration,
      startTime: state.startTime,
      isOngoing: state.isOngoing,
    );
    state = updatedTrip;
  }

  // Updates trip status if estimated arrival duration ticks
  void updateStatus(bool newStatus) {
    state.isOngoing = newStatus;
  }

  bool get isOngoing => state.isOngoing;
}
