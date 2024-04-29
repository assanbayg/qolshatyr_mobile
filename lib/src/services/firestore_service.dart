import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirecloudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'name': user.displayName,
    });
  }

  Future<void> addEmergencyContact(
      String userId, String contactName, String contactNumber) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .add({'name': contactName, 'number': contactNumber});
  }
}
