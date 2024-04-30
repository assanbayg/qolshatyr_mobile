import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';

class FirestoreService {
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

  Future<List<Contact>> getEmergencyContacts(String userId) async {
    return await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((element) {
        Contact.fromJson(element.data());
      });
      return querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
        print(Contact.fromJson(document.data()));
        return Contact.fromJson(document.data());
      }).toList();
    });
  }
}
