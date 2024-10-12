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
    if (mounted) {}
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All trips deleted successfully')),
    );
    setState(() {
      _tripsData = _fetchTripsData(); // Refresh data
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
                if (!mounted) return;
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
    return Column(
      children: [
        if (tripsData.lastTrip != null) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Last Trip:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            title: Text(tripsData.lastTrip!.startLocation.toString()),
            subtitle: Text(tripsData.lastTrip!.endLocation.toString()),
            trailing:
                Text('${tripsData.lastTrip!.estimateDuration.inMinutes} mins'),
          ),
          const Divider(),
        ],
        Expanded(
          child: ListView.builder(
            itemCount: tripsData.allTrips.length,
            itemBuilder: (context, index) {
              final trip = tripsData.allTrips[index];
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
  }
}

class TripsData {
  final Trip? lastTrip;
  final List<Trip> allTrips;

  TripsData({required this.lastTrip, required this.allTrips});
}
