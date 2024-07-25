// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:location/location.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/dialog_service.dart';
import 'package:qolshatyr_mobile/features/trip/services/location_service.dart';

class CreateTripFloatingActionButton extends StatelessWidget {
  const CreateTripFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final LocationService locationService = LocationService();
        final DialogService dialogService = DialogService();
        final LocationData? currentPosition =
            await locationService.getCurrentLocation(context);
        if (context.mounted) {
          dialogService.showCreateTrip(context, currentPosition!);
        }
      },
      child: const Icon(Icons.local_taxi_rounded),
    );
  }
}
