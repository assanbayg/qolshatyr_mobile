// Dart imports:
import 'dart:developer';
import 'dart:typed_data';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  // Reference to Firebase Storage
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // Reference to Firebase Authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Method to upload image to Firebase Storage.
  ///
  /// The image is stored in a folder specific to each user, determined by their UID.
  ///
  /// Parameters:
  /// - [Uint8List?] imageData: The image data to upload.
  /// - [String] imageName: The name to give to the image file in Firebase Storage.
  ///
  /// Returns: A [String] representing the download URL of the uploaded image.
  Future<String?> uploadUserImage(
      Uint8List? imageData, String imageName) async {
    if (imageData == null) {
      throw Exception('Image data cannot be null');
    }

    try {
      // Get the current authenticated user
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      // Define the storage reference for the user
      Reference storageRef = _firebaseStorage.ref().child(
          'user_images/${user.uid}/$imageName'); // Each user's images are stored in a separate folder

      // Upload the image data to Firebase Storage
      UploadTask uploadTask = storageRef.putData(imageData);

      // Wait for the upload to complete and get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl; // Return the download URL of the uploaded image
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }
}
