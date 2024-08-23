// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/check_in_service.dart';
import 'package:qolshatyr_mobile/features/trip/models/trip.dart';

class TripsLocalHistoryScreen extends StatelessWidget {
  static const routeName = '/trips-local-history';

  TripsLocalHistoryScreen({super.key});

  final CheckInService _tripCheckInService = CheckInService();

  Future<List<dynamic>> _fetchTripsData() async {
    final lastTrip = await _tripCheckInService.getLastTrip();
    final allTrips = await _tripCheckInService.getAllTrips();
    return [lastTrip, allTrips];
  }

  Future<void> _deleteAllTrips(BuildContext context) async {
    await _tripCheckInService.deleteAllTrips();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All trips deleted successfully')),
    );
    // Перезагружаем данные после удаления
    (context as Element).reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text('Are you sure you want to delete all trips?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _deleteAllTrips(context);
              }
            },
          ),
        ],
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
                    trailing:
                    Text('${lastTrip.estimateDuration.inMinutes} mins'),
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
                        trailing:
                        Text('${trip.estimateDuration.inMinutes} mins'),
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
