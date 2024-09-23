
import 'dart:typed_data';


import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageToFileService {
  static final ImageToFileService _instance = ImageToFileService._internal();
  factory ImageToFileService() => _instance;

  ImageToFileService._internal();

  // Save image as file and return its file path
  Future<String> saveImageToFile(Uint8List imageBytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = join(directory.path, '$fileName.png');

    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageBytes);

    return imageFile.path; // Return file path
  }

  // Retrieve the image file from the given path
  Future<File> getImageFile(String path) async {
    return File(path); // Return the file itself
  }

  // Delete image file by its path
  Future<void> deleteImageFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Clear all image files in the app directory (optional)
  Future<void> clearAllImageFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(directory.path);

    if (imagesDir.existsSync()) {
      imagesDir.listSync().forEach((file) {
        if (file is File && file.path.endsWith('.png')) {
          file.deleteSync();
        }
      });
    }
  }
}