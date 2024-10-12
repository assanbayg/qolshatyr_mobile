// // Flutter imports:
// import 'package:flutter/material.dart';

// // Package imports:
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';

// // Project imports:
// import 'package:qolshatyr_mobile/features/common/services/firestore_service.dart';
// import 'package:qolshatyr_mobile/features/common/services/geocoding_service.dart';
// import 'package:qolshatyr_mobile/features/trip/models/trip.dart';

// class TripsHistoryScreen extends StatelessWidget {
//   static const routeName = '/trips-history';

//   TripsHistoryScreen({super.key});

//   final FirestoreService _firestoreService = FirestoreService();

//   Future<String> getStreetName(LocationData location) async {
//     final placemark = await GeocodingService.translateFromLatLng(location);
//     return placemark.street ?? 'Unknown Street';
//   }

//   Future<Map<String, String>> getTripStreets(Trip trip) async {
//     final startStreet = await getStreetName(trip.startLocation);
//     final endStreet = await getStreetName(trip.endLocation);
//     return {
//       'startStreet': startStreet,
//       'endStreet': endStreet,
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trips History'),
//       ),
//       body: FutureBuilder<List<Trip>>(
//         future: _firestoreService.getUserTrips(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List<Trip> trips = snapshot.data!;

//             if (trips.isEmpty) {
//               return const Center(
//                 child: Text('No trips found.'),
//               );
//             }

//             return ListView.builder(
//               itemCount: trips.length,
//               itemBuilder: (context, index) {
//                 Trip trip = trips[index];
//                 return FutureBuilder<Map<String, String>>(
//                   future: getTripStreets(trip),
//                   builder: (context, streetSnapshot) {
//                     if (streetSnapshot.hasData) {
//                       final streets = streetSnapshot.data!;
//                       return ListTile(
//                         title: Text(DateFormat('d MMM').format(trip.startTime)),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("A: ${streets['startStreet']!}"),
//                             Text("B: ${streets['endStreet']!}"),
//                           ],
//                         ),
//                         trailing:
//                             Text('${trip.estimateDuration.inMinutes} mins'),
//                       );
//                     } else if (streetSnapshot.hasError) {
//                       return const ListTile(
//                         title: Text('Error'),
//                         subtitle: Text('Failed to load street names'),
//                       );
//                     } else {
//                       return const ListTile(
//                         title: CircularProgressIndicator(),
//                         subtitle: Text('Loading...'),
//                       );
//                     }
//                   },
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
