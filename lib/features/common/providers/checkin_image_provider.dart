// Dart imports:
import 'dart:developer';
import 'dart:typed_data';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckinImageStateNotifier extends StateNotifier<Uint8List?> {
  CheckinImageStateNotifier() : super(null);

  void setImage(Uint8List? imageBytes) {
    state = imageBytes;
    log('Success');
  }

  void clearImage() {
    state = null;
  }
}

final checkinImageProvider =
    StateNotifierProvider<CheckinImageStateNotifier, Uint8List?>(
  (ref) => CheckinImageStateNotifier(),
);
