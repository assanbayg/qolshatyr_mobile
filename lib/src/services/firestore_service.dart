import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';
import 'package:qolshatyr_mobile/src/models/trip.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Adds a new user to the Firestore database.
  Future<void> addUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'name': user.displayName,
    });
  }

  // Adds a new trip to the Firestore database.
  Future<void> addTrip(Map<String, dynamic> tripJson) async {
    // Gets the current user's ID from Firebase Auth.
    String userId = FirebaseAuth.instance.currentUser!.uid;
    tripJson['userId'] = userId;

    await _firestore.collection('trips').add(tripJson);
  }

  // Gets a list of trips for the current user.
  Future<List<Trip>> getUserTrips() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Queries the 'trips' collection to get documents where the 'userId' field matches the current user's ID.
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('trips')
        .where('userId', isEqualTo: userId)
        .get();

    // Converts the query snapshot results to a list of Trip objects.
    List<Trip> trips = querySnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
      return Trip.fromJson(document.data());
    }).toList();

    return trips;
  }

  // Adds an emergency contact for the specified user.
  Future<void> addEmergencyContact(
      String userId, String contactName, String contactNumber) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .add({'name': contactName, 'number': contactNumber});
  }

  // Gets a list of emergency contacts for the specified user.
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

  // Deletes an emergency contact for the specified user.
  Future<void> deleteEmergencyContact(String userId, String phoneNumber) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .where('number', isEqualTo: phoneNumber)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      for (var document in querySnapshot.docs) {
        document.reference.delete();
      }
    });
  }
}
