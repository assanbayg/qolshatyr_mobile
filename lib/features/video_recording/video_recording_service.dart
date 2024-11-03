import 'dart:async';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

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

  bool get isRecording => _isRecording;
  bool get recorderBusy => _recorderBusy;

  // Запрашиваем необходимые разрешения
  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      print("Не удалось получить необходимые разрешения.");
    }
    return allGranted;
  }

  Future<void> startRecording(String folderName, CameraFacing cameraFacing) async {
    if (!_isRecording && !_recorderBusy) {
      if (await _requestPermissions()) {
        try {
          await _videoRecorder.startVideoRecording(
            folderName: folderName,
            cameraFacing: cameraFacing,
            notificationTitle: "Recording in progress",
            notificationText: "Tap to return to app",
            showToast: false,
          );
          print("Началась запись видео.");
        } catch (e) {
          print("Ошибка при запуске записи: $e");
        }
      } else {
        print("Запись не может быть начата без разрешений.");
      }
    }
  }

  Future<String?> stopRecording() async {
    if (_isRecording) {
      try {
        String? filePath = await _videoRecorder.stopVideoRecording();
        print("Видео сохранено в: $filePath");
        return filePath;
      } catch (e) {
        print("Ошибка при остановке записи: $e");
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
