// Dart imports:
import 'dart:async';
import 'dart:developer';
import 'dart:io';

// Package imports:
import 'package:camera/camera.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';

// this file consists methods for handling background video recording

class CameraService {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool _isInitialized = false;

// initializing the camera
// we call this when creating an instance - typically when the trip starts
  Future<void> initializeCamera() async {
    if (_isInitialized) return;
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      // storing in low resolution for storage space purposes
      ResolutionPreset.low,
    );

    // Initialize the camera
    await _cameraController.initialize();
    log('VIDEO: initialized');
    _isInitialized = true;
  }

  // Start video recording with auto-stop after 10 seconds (for development purposes)
  Future<void> startVideoRecording() async {
    log('VIDEO: Started');
    try {
      if (!_isInitialized) await initializeCamera();

      // use temporary storage
      final directory = SharedPreferencesManager.directory;
      final filePath =
          '$directory/trip_recording_${DateTime.now().millisecondsSinceEpoch}.mp4';

      log("FILE PATH: $filePath");

      if (_cameraController.value.isInitialized) {
        await _cameraController.startVideoRecording();
        log('Recording started: $filePath');
      }
    } catch (e) {
      log('Error starting video recording: $e');
    }
  }

  Future<void> stopVideoRecording() async {
    String? directory = SharedPreferencesManager.directory;

    if (_cameraController.value.isRecordingVideo) {
      try {
        // get the recorded video file
        final XFile file = await _cameraController.stopVideoRecording();

        // format the timestamp to avoid invalid characters in the filename
        String timestamp =
            DateTime.now().toIso8601String().replaceAll(':', '-');
        String filePath = '$directory/trip_recording_$timestamp.mp4';

        // Ensure the directory exists
        final dir = Directory(directory!);
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }

        // copy the recorded video to the specified path
        final savedFile = File(filePath);
        await savedFile.writeAsBytes(await file.readAsBytes());

        log('VIDEO: Stopped and saved at $filePath');
      } catch (e) {
        log('Error stopping video recording: $e');
      }
    }
  }

  // Dispose camera resources
  Future<void> disposeCamera() async {
    if (_isInitialized) {
      await _cameraController.dispose();
      _isInitialized = false;
    }
  }
}
