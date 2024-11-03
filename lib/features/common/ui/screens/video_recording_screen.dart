import 'package:flutter/material.dart';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';
import 'package:qolshatyr_mobile/features/video_recording/video_recording_service.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({Key? key}) : super(key: key);

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

  void _toggleCamera() {
    if (!_recordingService.isRecording && !_recordingService.recorderBusy) {
      cameraFacing = cameraFacing == "Rear camera" ? "Front camera" : "Rear camera";
      setState(() {});
    }
  }

  Future<void> _toggleRecording() async {
    if (!_recordingService.isRecording && !_recordingService.recorderBusy) {
      await _recordingService.startRecording(
        "Example Recorder",
        cameraFacing == "Rear camera" ? CameraFacing.rearCamera : CameraFacing.frontCamera,
      );
      setState(() {});
    } else if (_recordingService.isRecording) {
      String filePath = await _recordingService.stopRecording() ?? "None";
      print("Recording saved to $filePath");
      setState(() {});
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
          children: <Widget>[
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
              child: Text(_recordingService.isRecording ? "Stop Recording" : "Start Recording"),
            ),
          ],
        ),
      ),
    );
  }
}



