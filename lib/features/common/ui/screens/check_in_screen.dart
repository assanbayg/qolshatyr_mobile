// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/providers/checkin_image_provider.dart';
import 'package:qolshatyr_mobile/features/common/services/check_in_service.dart';
import 'package:qolshatyr_mobile/features/common/services/geocoding_service.dart';
import 'package:qolshatyr_mobile/features/common/ui/widgets/image_picker_widget.dart';
import 'package:qolshatyr_mobile/features/trip/trip_provider.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  static const routeName = '/check-in';
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final CheckInService checkInService = CheckInService();
    final trip = ref.read(tripProvider.notifier);
    final imageBytes = ref.watch(checkinImageProvider);

    Future<String> getPlacemarkStreet(LocationData location) async {
      try {
        Placemark placemark = await GeocodingService.translateFromLatLng(
          LocationData.fromMap(
            {
              'latitude': location.latitude,
              'longitude': location.longitude,
            },
          ),
        );
        return placemark.street.toString();
      } catch (e) {
        return 'Unknown Street';
      }
    }

    Future<Map<String, String>> getStreets() async {
      String startStreet =
          await getPlacemarkStreet(trip.latestTrip.startLocation);
      String endStreet = await getPlacemarkStreet(trip.latestTrip.endLocation);
      return {
        'startStreet': startStreet,
        'endStreet': endStreet,
      };
    }

    return FutureBuilder<Map<String, String>>(
      future: getStreets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final streets = snapshot.data!;
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Display checkin image if available
                      if (imageBytes != null)
                        Image.memory(
                          imageBytes,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.all(75),
                          child: Icon(Icons.person_rounded, size: 100),
                        ),

                      const ImagePickerWidget(),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.access_time, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Start time: ${trip.latestTrip.startTime.hour}:${trip.latestTrip.startTime.minute}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.arrow_forward, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    "End time: ${DateTime.now().hour}:${DateTime.now().minute}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Location A: ${streets['startStreet']}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Location B: ${streets['endStreet']}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkInService.saveTrip(trip.latestTrip, imageBytes);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Checked in!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          localization.checkIn,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
