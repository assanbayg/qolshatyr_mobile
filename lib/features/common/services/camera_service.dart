// Dart imports:
import 'dart:async';
import 'dart:developer';
import 'dart:io';

// Package imports:
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';

// this file consists methods for handling background video recording
// TODO: - store the state of recording in riverpod

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

// remove this and store one directory path in shared preferences
// adjust it in settings
  Future<String?> getTemporaryDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      return selectedDirectory;
    } else {
      return null;
    }
  }

  // Start video recording with auto-stop after 10 seconds (for development purposes)
  // TODO: stop video recording on the command instead of automatically
  Future<void> startVideoRecording() async {
    log('VIDEO: Started');
    try {
      if (!_isInitialized) await initializeCamera();

      // use temporary storage
      final directory = await getTemporaryDirectory();
      final filePath =
          '$directory/trip_recording_${DateTime.now().millisecondsSinceEpoch}.mp4';

      log("FILE PATH: $filePath");

      if (_cameraController.value.isInitialized) {
        await _cameraController.startVideoRecording();
        log('Recording started: $filePath');

        // Stop recording automatically after 10 seconds
        Timer(const Duration(seconds: 10), () async {
          await stopVideoRecording();
        });
      }
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> stopVideoRecording() async {
    String? directoryPath = await getTemporaryDirectory();

    if (_cameraController.value.isRecordingVideo) {
      try {
        // get the recorded video file
        final XFile file = await _cameraController.stopVideoRecording();

        if (directoryPath != null) {
          // format the timestamp to avoid invalid characters in the filename
          String timestamp =
              DateTime.now().toIso8601String().replaceAll(':', '-');
          String fileDirectory =
              '/storage/emulated/0/Download/qolshatyrproject';
          String filePath = '$fileDirectory/trip_recording_$timestamp.mp4';

          // Ensure the directory exists
          final dir = Directory(fileDirectory);
          if (!dir.existsSync()) {
            dir.createSync(recursive: true);
          }

          // copy the recorded video to the specified path
          final savedFile = File(filePath);
          await savedFile.writeAsBytes(await file.readAsBytes());

          log('VIDEO: Stopped and saved at $filePath');
        } else {
          log('Error: Directory path is null.');
        }
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
