import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<List<Map<String, String>>> getBookedSlots(
    DateTime selectedDate, String courtName) async {
  QuerySnapshot courtBookings = await _firestore
      .collection('bookings')
      .where('date', isEqualTo: selectedDate)
      .where('courtName', isEqualTo: courtName)
      .get();

  QuerySnapshot matches = await _firestore
      .collection('matches')
      .where('date', isEqualTo: selectedDate)
      .where('place', isEqualTo: courtName)
      .get();

  List<Map<String, String>> bookedSlots = [];

  for (var doc in courtBookings.docs) {
    bookedSlots.add({
      'startTime': doc['startTime'],
      'endTime': _calculateEndTime(doc['startTime'])
    });
  }

  for (var doc in matches.docs) {
    bookedSlots.add(
        {'startTime': doc['time'], 'endTime': _calculateEndTime(doc['time'])});
  }

  return bookedSlots;
}

String _calculateEndTime(String startTime) {
  final DateFormat format = DateFormat.Hm();
  DateTime start = format.parse(startTime);
  DateTime end = start.add(Duration(minutes: 89));
  return format.format(end);
}

bool _isOverlapping(
    String startTime, String endTime, List<Map<String, String>> bookedSlots) {
  final DateFormat format = DateFormat.Hm();
  DateTime start = format.parse(startTime);
  DateTime end = format.parse(endTime);

  for (var slot in bookedSlots) {
    DateTime bookedStart = format.parse(slot['startTime']!);
    DateTime bookedEnd = format.parse(slot['endTime']!);
    if (start.isBefore(bookedEnd) && end.isAfter(bookedStart)) {
      return true;
    }
  }
  return false;
}

Future<void> bookCourt(
    DateTime selectedDate, String startTime, String courtName,
    {bool isMatch = false}) async {
  User? user = _auth.currentUser;
  if (user != null) {
    try {
      String endTime = _calculateEndTime(startTime);
      List<Map<String, String>> bookedSlots =
          await getBookedSlots(selectedDate, courtName);

      if (_isOverlapping(startTime, endTime, bookedSlots)) {
        throw 'Selected time slot overlaps with an existing booking.';
      }

      await _firestore.collection('bookings').add({
        'userId': user.uid,
        'userEmail': user.email ?? 'unknown',
        'date': selectedDate,
        'startTime': startTime,
        'endTime': endTime,
        'courtName': courtName,
        'isMatch': isMatch,
        'createdAt': FieldValue.serverTimestamp(),
      });
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

Future<void> cancelAndBookNew(String bookingId, DateTime selectedDate,
    String newStartTime, String courtName,
    {bool isMatch = false}) async {
  try {
    await cancelBooking(bookingId);
    await bookCourt(selectedDate, newStartTime, courtName, isMatch: isMatch);
  } catch (e) {
    throw 'Failed to update booking: $e';
  }
}
