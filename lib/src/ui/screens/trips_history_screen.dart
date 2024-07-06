// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/models/trip.dart';
import 'package:qolshatyr_mobile/src/services/firestore_service.dart';

// TODO: make it user-friendly screen
class TripsHistoryScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  TripsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips History'),
      ),
      body: FutureBuilder<List<Trip>>(
        future: _firestoreService.getUserTrips(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Trip> trips = snapshot.data!;
            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                Trip trip = trips[index];
                return ListTile(
                  title: Text(trip.startLocation.toString()),
                  subtitle: Text(trip.endLocation.toString()),
                  trailing: Text('${trip.estimateDuration.inMinutes} mins'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
