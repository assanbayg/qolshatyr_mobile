import 'dart:async';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';

class VideoRecordingService {
  final FlutterBackgroundVideoRecorder _videoRecorder = FlutterBackgroundVideoRecorder();
  bool _isRecording = false;
  bool _recorderBusy = false;
  StreamSubscription<int?>? _streamSubscription;

  VideoRecordingService() {
    _listenRecordingState();
    _initializeRecordingStatus();
  }

  Future<void> _initializeRecordingStatus() async {
    _isRecording = await _videoRecorder.getVideoRecordingStatus() == 1;
  }

  void _listenRecordingState() {
    _streamSubscription = _videoRecorder.recorderState.listen((event) {
      switch (event) {
        case 1:
          _isRecording = true;
          _recorderBusy = true;
          break;
        case 2:
          _isRecording = false;
          _recorderBusy = false;
          break;
        case 3:
          _recorderBusy = true;
          break;
        case -1:
          _isRecording = false;
          break;
      }
    });
  }

  // Добавляем геттеры
  bool get isRecording => _isRecording;
  bool get recorderBusy => _recorderBusy;

  Future<void> startRecording(String folderName, CameraFacing cameraFacing) async {
    if (!_isRecording && !_recorderBusy) {
      try {
        await _videoRecorder.startVideoRecording(
          folderName: folderName,
          cameraFacing: cameraFacing,
          notificationTitle: "Recording in progress",
          notificationText: "Tap to return to app",
          showToast: false,
        );
      } catch (e) {
        print("Error starting recording: $e");
      }
    }
  }

  Future<String?> stopRecording() async {
    if (_isRecording) {
      try {
        return await _videoRecorder.stopVideoRecording();
      } catch (e) {
        print("Error stopping recording: $e");
        return null;
      }
    }
    return null;
  }

  Future<bool> isCurrentlyRecording() async {
    return await _videoRecorder.getVideoRecordingStatus() == 1;
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}

