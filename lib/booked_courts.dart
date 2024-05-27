import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookedCourtsScreen extends StatefulWidget {
  const BookedCourtsScreen({super.key});

  @override
  _BookedCourtsScreenState createState() => _BookedCourtsScreenState();
}

class _BookedCourtsScreenState extends State<BookedCourtsScreen> {
  Future<List<Map<String, dynamic>>> _getUserBookings() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw 'You need to be logged in to view your bookings.';
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('userEmail', isEqualTo: user.email)
        .where('isMatch', isEqualTo: false)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['bookingId'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> _cancelBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking canceled')),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          } else {
            List<Map<String, dynamic>> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(booking['courtName']),
                    subtitle: Text(
                      'Date: ${DateFormat('dd/MM/yyyy').format((booking['date'] as Timestamp).toDate())}\n'
                      'Time: ${booking['startTime']} - ${booking['endTime']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () async {
                        await _cancelBooking(booking['bookingId']);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
