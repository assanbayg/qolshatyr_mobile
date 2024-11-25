// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/camera_service.dart';

final videoRecordingProvider =
    Provider<CameraService>((ref) => CameraService());
