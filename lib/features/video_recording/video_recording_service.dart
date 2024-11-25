// Dart imports:
import 'dart:async';
import 'dart:developer';
import 'dart:io';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart'; // Новый импорт

class VideoRecordingService {
  final FlutterBackgroundVideoRecorder _videoRecorder =
      FlutterBackgroundVideoRecorder();
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

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      log("Не удалось получить необходимые разрешения.");
    }
    return allGranted;
  }

  Future<String> _getStorageDirectory(String folderName) async {
    // Получаем базовую директорию
    final Directory baseDir = await getApplicationDocumentsDirectory();
    final Directory targetDir = Directory('${baseDir.path}/$folderName');

    // Проверяем, существует ли директория, если нет — создаем её
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
      log("Папка ${targetDir.path} создана.");
    } else {
      log("Папка ${targetDir.path} уже существует.");
    }

    return targetDir.path; // Возвращаем полный путь
  }

  Future<String?> pickDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      return selectedDirectory;
    } else {
      return null;
    }
  }

  Future<void> startRecording(
      String folderName, CameraFacing cameraFacing) async {
    if (!_isRecording && !_recorderBusy) {
      if (await _requestPermissions()) {
        try {
          // Получаем директорию для хранения файлов
          // final String directoryPath = await _getStorageDirectory(folderName);

          String directoryPath = await pickDirectory() as String;

          // Начинаем запись
          final res = await _videoRecorder.startVideoRecording(
            folderName: directoryPath, // Полный путь
            cameraFacing: cameraFacing,
            notificationTitle: "Recording in progress",
            notificationText: "Tap to return to app",
            showToast: true,
          );
          log(res.toString());
          log("Началась запись видео.");
        } catch (e) {
          log("Ошибка при запуске записи: $e");
        }
      } else {
        log("Запись не может быть начата без разрешений.");
      }
    }
  }

  Future<String?> stopRecording() async {
    if (_isRecording) {
      try {
        String? filePath = await _videoRecorder.stopVideoRecording();
        log("Видео сохранено в: $filePath");
        return filePath;
      } catch (e) {
        log("Ошибка при остановке записи: $e");
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

  void test() async {
    final storagePermission = await Permission.storage.request();
    if (storagePermission.isGranted) {
      log("Доступ к хранилищу предоставлен.");
    } else if (storagePermission.isDenied) {
      log("Доступ к хранилищу отклонен.");
    } else if (storagePermission.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}



// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_background_video_recorder/flutter_bvr.dart';
// import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // Recorder variables to keep track of recording status
//   // _isRecording when set to true indicates that the video is being recorded
//   // _recorderBusy when set to true indicated that the recorder is doing some job
//   //    - It can be that the recorder is initializing resources
//   //    - And/or recorder is recording the video.
//   // In any case, when the _recorderBusy is set to true, start/stop recording should not be called.
//   bool _isRecording = false;
//   bool _recorderBusy = false;

//   // StreamSubscription to get realtime recorder events from native platform
//   //  - 1: Recording in progress
//   //  - 2: Recording has been stopped
//   //  - 3: Recorder is being initialized and about to start recording
//   //  - -1: Recorder encountered an error
//   StreamSubscription<int?>? _streamSubscription;
//   final _flutterBackgroundVideoRecorderPlugin =
//       FlutterBackgroundVideoRecorder();

//   // Indicates which camera to use for recording
//   // Can take values:
//   //  - Rear camera
//   //  - Front camera
//   String cameraFacing = "Rear camera";

//   @override
//   void initState() {
//     super.initState();
//     getInitialRecordingStatus();
//     listenRecordingState();
//   }

//   @override
//   void dispose() {
//     _streamSubscription?.cancel();
//     super.dispose();
//   }

//   // Check if the recorder is already recording when returning to the app after it was closed.
//   Future<void> getInitialRecordingStatus() async {
//     _isRecording =
//         await _flutterBackgroundVideoRecorderPlugin.getVideoRecordingStatus() ==
//             1;
//   }

//   // Listen to recorder events to update UI accordingly
//   // Switch values are according to the StreamSubscription documentation above
//   void listenRecordingState() {
//     _streamSubscription =
//         _flutterBackgroundVideoRecorderPlugin.recorderState.listen((event) {
//       switch (event) {
//         case 1:
//           _isRecording = true;
//           _recorderBusy = true;
//           setState(() {});
//           break;
//         case 2:
//           _isRecording = false;
//           _recorderBusy = false;
//           setState(() {});
//           break;
//         case 3:
//           _recorderBusy = true;
//           setState(() {});
//           break;
//         case -1:
//           _isRecording = false;
//           setState(() {});
//           break;
//         default:
//           return;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Background video recorder'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20.0),
//                 child: Text(
//                   "Camera: $cameraFacing",
//                   style: const TextStyle(
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButtonTheme.of(context).style?.copyWith(
//                     backgroundColor: MaterialStateProperty.resolveWith(
//                         (states) => (!_isRecording && !_recorderBusy)
//                             ? null
//                             : Colors.grey)),
//                 onPressed: () {
//                   if (!_isRecording && !_recorderBusy) {
//                     if (cameraFacing == "Rear camera") {
//                       cameraFacing = "Front camera";
//                     } else {
//                       cameraFacing = "Rear camera";
//                     }
//                     setState(() {});
//                   }
//                 },
//                 child: const Text("Switch camera facing"),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (!_isRecording && !_recorderBusy) {
//                     await _flutterBackgroundVideoRecorderPlugin
//                         .startVideoRecording(
//                             folderName: "Example Recorder",
//                             cameraFacing: CameraFacing.frontCamera,
//                             notificationTitle: "Example Notification Title",
//                             notificationText: "Example Notification Text",
//                             showToast: false
//                     );
//                     setState(() {});
//                   } else if (!_isRecording && _recorderBusy) {
//                     return;
//                   } else {
//                     String filePath =
//                         await _flutterBackgroundVideoRecorderPlugin
//                                 .stopVideoRecording() ??
//                             "None";
//                     setState(() {});
//                     debugPrint(filePath);
//                   }
//                 },
//                 child: Text(
//                   _isRecording ? "Stop Recording" : "Start Recording",
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
