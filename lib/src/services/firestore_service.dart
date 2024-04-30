import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/models/trip.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'name': user.displayName,
    });
  }

  Future<void> addTrip(Map<String, dynamic> tripJson) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    tripJson['userId'] = userId;

    await _firestore.collection('trips').add(tripJson);
  }

  Future<List<Trip>> getUserTrips() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('trips')
        .where('userId', isEqualTo: userId)
        .get();

    List<Trip> trips = querySnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
      return Trip.fromJson(document.data());
    }).toList();
    print(trips);

    return trips;
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
      for (var element in querySnapshot.docs) {
        Contact.fromJson(element.data());
      }
      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      return querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
        return Contact.fromJson(document.data());
      }).toList();
    });
  }

  Future<void> deleteEmergencyContact(String userId, String number) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .where('number', isEqualTo: number)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      for (var document in querySnapshot.docs) {
        document.reference.delete();
      }
    });
  }
}
