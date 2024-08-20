// отображат поездки локально
import 'package:flutter/material.dart';
import 'package:qolshatyr_mobile/features/trip/models/trip.dart'; // Update this import path as needed
import 'package:qolshatyr_mobile/features/common/services/check_in_service.dart'; // Update this import path as needed

class TripSummaryScreen extends StatelessWidget {
  static const routeName = '/trip-summary';

  TripSummaryScreen({super.key});

  final CheckInService _tripCheckInService = CheckInService();

  Future<List<dynamic>> _fetchTripsData() async {
    final lastTrip = await _tripCheckInService.getLastTrip();
    final allTrips = await _tripCheckInService.getAllTrips();
    return [lastTrip, allTrips];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Summary'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchTripsData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final lastTrip = snapshot.data![0] as Trip?;
            final allTrips = snapshot.data![1] as List<Trip>;

            return Column(
              children: [
                if (lastTrip != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Last Trip:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(lastTrip.startLocation.toString()),
                    subtitle: Text(lastTrip.endLocation.toString()),
                    trailing: Text('${lastTrip.estimateDuration.inMinutes} mins'),
                  ),
                  const Divider(),
                ],
                Expanded(
                  child: ListView.builder(
                    itemCount: allTrips.length,
                    itemBuilder: (context, index) {
                      final trip = allTrips[index];
                      return ListTile(
                        title: Text(trip.startLocation.toString()),
                        subtitle: Text(trip.endLocation.toString()),
                        trailing: Text('${trip.estimateDuration.inMinutes} mins'),
                      );
                    },
                  ),
                ),
              ],
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