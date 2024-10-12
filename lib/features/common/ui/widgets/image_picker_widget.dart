// Dart imports:
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/providers/checkin_image_provider.dart';

class ImagePickerWidget extends ConsumerStatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  ConsumerState<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends ConsumerState<ImagePickerWidget> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 15,
    );
    if (pickedFile != null) {
      final pickedImageFile = File(pickedFile.path);
      setState(() {
        _image = pickedImageFile;
        log(_image.toString());
      });
      Uint8List? imageBytes = await pickedImageFile.readAsBytes();
      ref.read(checkinImageProvider.notifier).setImage(imageBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Take Picture'),
          ),
        ),
      ],
    );
  }
}
