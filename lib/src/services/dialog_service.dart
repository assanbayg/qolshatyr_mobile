// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:qolshatyr_mobile/src/models/trip.dart';
// import 'package:qolshatyr_mobile/src/providers/trip_provider.dart';
// import 'package:location/location.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DialogService {

//    Future<void> _showInitialDialog(
//     BuildContext context,
//     LatLng currentPosition,
//     LatLng endPosition,
//   ) async {
//     print('DIALOG 1');
//     endPosition = currentPosition;
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         print('DIALOG 2');
//         return AlertDialog(
//           title: const Text('Send your location to your close ones'),
//           content: const Text('This is the initial dialog.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _showBottomSheet(context);
//               },
//               child: const Text('Next'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showBottomSheet(BuildContext context) {
//     TimeOfDay? estimatedArrivalTime;

//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Consumer(
//           builder: (context, ref, _) {
//             final tripNotifier = ref.read(tripProvider.notifier);
//             return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//                 return Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const Text(
//                         'Enter your destination address and estimated arrival time',
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16.0),
//                       TextButton(
//                         onPressed: () async {
//                           final TimeOfDay? picked = await showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.now(),
//                           );
//                           if (picked != null) {
//                             setState(() {
//                               estimatedArrivalTime = picked;
//                             });
//                           }
//                         },
//                         child: Text(
//                           estimatedArrivalTime == null
//                               ? '00:00'
//                               : estimatedArrivalTime!.format(context),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 28,
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           print("TEST !!!");
//                           Trip newTrip = Trip(
//                             startLocation: LocationData.fromMap({
//                               'latitude': currentPosition!.latitude,
//                               'longitude': currentPosition!.longitude,
//                             }),
//                             endLocation: LocationData.fromMap({
//                               'latitude': endPosition!.latitude,
//                               'longitude': endPosition!.longitude,
//                             }),
//                             estimateDuration: const Duration(hours: 1),
//                             startTime: DateTime.now(),
//                           );

//                           // Update trip state using TripProvider
//                           tripNotifier.addTrip(newTrip);

//                           print('New Trip created: $newTrip');
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Start a trip'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//   }