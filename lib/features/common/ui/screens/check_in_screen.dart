// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/check_in_service.dart';
import 'package:qolshatyr_mobile/features/common/services/geocoding_service.dart';
import 'package:qolshatyr_mobile/features/common/ui/widgets/image_picker_widget.dart';
import 'package:qolshatyr_mobile/features/trip/trip_provider.dart';

class CheckInScreen extends ConsumerWidget {
  static const routeName = '/check-in';
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final CheckInService checkInService = CheckInService();
    final trip = ref.read(tripProvider.notifier);

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
              body: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const ImagePickerWidget(),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Start time ${trip.latestTrip.startTime.hour}:${trip.latestTrip.startTime.minute}   -   "),
                            Text(
                                "End time ${DateTime.now().hour}:${DateTime.now().minute}"),
                          ],
                        ),
                        Text("Location A - ${streets['startStreet']}"),
                        Text("Location B - ${streets['endStreet']}"),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkInService.saveCheckIn();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Checked in!')));
                      },
                      child: Text(localization.checkIn),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
