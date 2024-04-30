import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:qolshatyr_mobile/src/models/trip.dart';
import 'package:qolshatyr_mobile/src/services/firestore_service.dart';

final currentPositionProvider =
    StateProvider<LatLng?>((ref) => const LatLng(0, 0));
final tripProvider = StateNotifierProvider((ref) => TripNotifier());

class TripNotifier extends StateNotifier<Trip> {
  final FirestoreService _firestoreService = FirestoreService();

  TripNotifier() : super(Trip.empty());

  void addTrip(LocationData startLocation, Duration estimateDuration) async {
    final newTrip = Trip(
      startLocation: startLocation,
      endLocation: state.endLocation,
      estimateDuration: estimateDuration,
      startTime: DateTime.now(),
    );
    await _firestoreService.addTrip(newTrip.toJson());
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
