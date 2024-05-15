import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/book_court.dart';
import 'package:flutter_project/book_helper.dart';
import 'location_data.dart';
import 'package:intl/intl.dart';

class SearchCourtScreen extends StatefulWidget {
  const SearchCourtScreen({super.key});

  @override
  _SearchCourtScreenState createState() => _SearchCourtScreenState();
}

class _SearchCourtScreenState extends State<SearchCourtScreen> {
  DocumentSnapshot? existingBooking;

  @override
  void initState() {
    super.initState();
    _checkExistingBooking();
  }

  Future<void> _checkExistingBooking() async {
    try {
      DocumentSnapshot? booking = await checkExistingBooking();
      if (booking != null) {
        setState(() {
          existingBooking = booking;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to check existing booking: $e")),
      );
    }
  }

  Future<void> _cancelBooking() async {
    try {
      if (existingBooking != null) {
        await cancelBooking(existingBooking!.id);
        setState(() {
          existingBooking = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking cancelled successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to cancel booking: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Padel Courts'),
        backgroundColor: Colors.blueAccent,
      ),
      body: existingBooking != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You have an existing booking at ${existingBooking!['courtName']} on ${DateFormat('dd/MM/yyyy').format((existingBooking!['date'] as Timestamp).toDate())} at ${existingBooking!['timeSlot']}.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _cancelBooking,
                    child: const Text('Cancel Booking'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(location: location),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 4,
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            location.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ListTile(
                          title: Text(location.name),
                          subtitle: Text(location.address),
                          trailing: Text('${location.price} €'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8.0,
                            children: location.times
                                .map((time) => Chip(
                                      label: Text(time),
                                      backgroundColor: Colors.blueAccent,
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
