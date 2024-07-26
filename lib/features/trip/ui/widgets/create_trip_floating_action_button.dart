// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/trip/trip_dialog.dart';

class CreateTripFloatingActionButton extends StatelessWidget {
  const CreateTripFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if (context.mounted) {
          TripDialog().showCreateTrip(context);
        }
      },
      child: const Icon(Icons.local_taxi_rounded),
    );
  }
}
