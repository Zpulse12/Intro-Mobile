import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<DocumentSnapshot?> checkExistingBooking() async {
  User? user = _auth.currentUser;
  if (user != null) {
    QuerySnapshot querySnapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    }
  }
  return null;
}

Future<List<String>> getBookedSlots(DateTime selectedDate, String courtName) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('bookings')
      .where('date', isEqualTo: selectedDate)
      .where('courtName', isEqualTo: courtName)
      .get();

  List<String> bookedSlots = [];
  for (var doc in querySnapshot.docs) {
    bookedSlots.add(doc['timeSlot']);
  }
  return bookedSlots;
}

Future<void> bookCourt(DateTime selectedDate, String timeSlot, String courtName) async {
  User? user = _auth.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot? existingBooking = await checkExistingBooking();
      if (existingBooking != null) {
        throw 'You already have a booking for this date at ${existingBooking['timeSlot']}.';
      } else {
        await _firestore.collection('bookings').add({
          'userId': user.uid,
          'userName': user.displayName ?? 'Unknown User',
          'date': selectedDate,
          'timeSlot': timeSlot,
          'courtName': courtName,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw 'Failed to book slot: $e';
    }
  } else {
    throw 'You need to be logged in to book a court.';
  }
}

Future<void> cancelBooking(String bookingId) async {
  try {
    await _firestore.collection('bookings').doc(bookingId).delete();
  } catch (e) {
    throw 'Failed to cancel booking: $e';
  }
}

Future<void> cancelAndBookNew(String bookingId, DateTime selectedDate, String newTimeSlot, String courtName) async {
  try {
    await cancelBooking(bookingId);
    await bookCourt(selectedDate, newTimeSlot, courtName);
  } catch (e) {
    throw 'Failed to update booking: $e';
  }
}
