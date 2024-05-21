import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookedCourtsScreen extends StatefulWidget {
  @override
  _BookedCourtsScreenState createState() => _BookedCourtsScreenState();
}

class _BookedCourtsScreenState extends State<BookedCourtsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> _getUserBookings() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return [];
    }
    QuerySnapshot querySnapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'courtName': doc['courtName'],
        'date': (doc['date'] as Timestamp).toDate(),
        'startTime': doc['startTime'],
        'endTime': doc['endTime'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Booked Courts'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No bookings found."));
          }
          List<Map<String, dynamic>> bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(booking['courtName']),
                  subtitle: Text(
                      'Date: ${DateFormat('dd/MM/yyyy').format(booking['date'])}\n'
                      'Time: ${booking['startTime']} - ${booking['endTime']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
