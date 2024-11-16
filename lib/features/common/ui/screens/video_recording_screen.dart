// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/video_recording/video_recording_service.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  final VideoRecordingService _recordingService = VideoRecordingService();
  String cameraFacing = "Rear camera";

  @override
  void dispose() {
    _recordingService.dispose();
    super.dispose();
  }

  void _test() {
    _recordingService.test();
  }

  void _toggleCamera() {
    if (!_recordingService.isRecording && !_recordingService.recorderBusy) {
      cameraFacing =
          cameraFacing == "Rear camera" ? "Front camera" : "Rear camera";
      setState(() {});
    }
  }

  Future<void> _toggleRecording() async {
    // Check and request permissions if needed
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();

    if (cameraPermission.isGranted && microphonePermission.isGranted) {
      if (!_recordingService.isRecording && !_recordingService.recorderBusy) {
        await _recordingService.startRecording(
          "Example Recorder",
          cameraFacing == "Rear camera"
              ? CameraFacing.rearCamera
              : CameraFacing.frontCamera,
        );
        setState(() {});
      } else if (_recordingService.isRecording) {
        String filePath = await _recordingService.stopRecording() ?? "None";
        log("Recording saved to $filePath");
        setState(() {});
      }
    } else {
      log("Не удалось получить необходимые разрешения.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Video Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Camera: $cameraFacing",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: _toggleCamera,
              child: const Text("Switch camera facing"),
            ),
            ElevatedButton(
              onPressed: _toggleRecording,
              child: Text(_recordingService.isRecording
                  ? "Stop Recording"
                  : "Start Recording"),
            ),
            ElevatedButton(onPressed: _test, child: const Text('TEST')),
          ],
        ),
      ),
    );
  }
}
