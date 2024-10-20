// TODO: localize this thing later

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/check_in_service.dart';
import 'package:qolshatyr_mobile/features/trip/models/trip.dart';

class TripsLocalHistoryScreen extends StatefulWidget {
  static const routeName = '/trips-local-history';

  const TripsLocalHistoryScreen({super.key});

  @override
  State<TripsLocalHistoryScreen> createState() =>
      _TripsLocalHistoryScreenState();
}

class _TripsLocalHistoryScreenState extends State<TripsLocalHistoryScreen> {
  final CheckInService _tripCheckInService = CheckInService();
  late Future<TripsData> _tripsData;

  @override
  void initState() {
    super.initState();
    _tripsData = _fetchTripsData();
  }

  Future<TripsData> _fetchTripsData() async {
    final lastTrip = await _tripCheckInService.getLastTrip();
    final allTrips = await _tripCheckInService.getAllTrips();
    return TripsData(lastTrip: lastTrip, allTrips: allTrips);
  }

  Future<void> _deleteAllTrips(BuildContext context) async {
    await _tripCheckInService.deleteAllTrips();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All trips deleted successfully')),
    );
    setState(() {
      // refresh data
      _tripsData = _fetchTripsData();
    });
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
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
              final confirm = await _confirmDelete(context);
              if (confirm == true) {
                await _deleteAllTrips(context);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<TripsData>(
        future: _tripsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final tripsData = snapshot.data!;
            return _buildTripsContent(context, tripsData);
          } else {
            return const Center(child: Text('No trips available'));
          }
        },
      ),
    );
  }

  Widget _buildTripsContent(BuildContext context, TripsData tripsData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tripsData.lastTrip != null) ...[
            Text(
              'Last Trip',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTripCard(tripsData.lastTrip!),
            const Divider(),
          ],
          Text(
            'All Trips',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: tripsData.allTrips.length,
              itemBuilder: (context, index) {
                final trip = tripsData.allTrips[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _buildTripCard(trip),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (trip.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  trip.image!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start: ${trip.startLocation}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'End: ${trip.endLocation}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${trip.estimateDuration.inMinutes} mins',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripsData {
  final Trip? lastTrip;
  final List<Trip> allTrips;

  TripsData({required this.lastTrip, required this.allTrips});
}
