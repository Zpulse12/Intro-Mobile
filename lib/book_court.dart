import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'book_helper.dart';
import 'location_data.dart';

class BookingScreen extends StatefulWidget {
  final Location location;

  const BookingScreen({super.key, required this.location});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<String> timeSlots = [
    "16:00", "16:30", "17:00", "17:30", "18:00", "18:30",
    "19:00", "19:30", "20:00", "20:30", "21:00", "21:30"
  ];
  DateTime selectedDate = DateTime.now();
  bool showAvailableOnly = false;
  DocumentSnapshot? existingBooking;

  @override
  void initState() {
    super.initState();
    _checkExistingBooking();
  }

  bool _isSlotInPast(String slot) {
    DateTime now = DateTime.now();
    List<String> parts = slot.split(':');
    DateTime slotTime = DateTime(
      selectedDate.year, selectedDate.month, selectedDate.day,
      int.parse(parts[0]), int.parse(parts[1])
    );
    return slotTime.isBefore(now);
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
    }
  }

  Future<void> _handleBooking(String timeSlot) async {
    try {
      await bookCourt(selectedDate, timeSlot, widget.location.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          "Booking successful for $timeSlot on ${DateFormat('dd/MM/yyyy').format(selectedDate)}"
        )),
      );
      setState(() {
        _checkExistingBooking();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _handleCancelAndBookNew(String bookingId, String newTimeSlot) async {
    try {
      await cancelAndBookNew(bookingId, selectedDate, newTimeSlot, widget.location.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          "Booking updated to $newTimeSlot on ${DateFormat('dd/MM/yyyy').format(selectedDate)}"
        )),
      );
      setState(() {
        _checkExistingBooking();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _handleCancelBooking(String bookingId) async {
    try {
      await cancelBooking(bookingId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          "Booking cancelled successfully on ${DateFormat('dd/MM/yyyy').format(selectedDate)}"
        )),
      );
      setState(() {
        existingBooking = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _showCancelDialog(String bookingId, String newTimeSlot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Existing Booking'),
          content: Text(
            'You already have a booking for this date at ${existingBooking!['timeSlot']}. '
            'Do you want to cancel it and book $newTimeSlot instead?'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _handleCancelAndBookNew(bookingId, newTimeSlot);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildTimeSlotButton(String time, bool isPast, bool isBooked) {
    return ElevatedButton(
      onPressed: isPast ? null : () {
        if (existingBooking != null) {
          _showCancelDialog(existingBooking!.id, time);
        } else {
          _handleBooking(time);
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isPast ? Colors.grey : Colors.black,
        backgroundColor: isPast ? Colors.grey[300] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(time),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.location.name,
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: existingBooking != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You already have a booking at ${existingBooking!['courtName']} on "
                    "${DateFormat('dd/MM/yyyy').format((existingBooking!['date'] as Timestamp).toDate())} at ${existingBooking!['timeSlot']}.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _handleCancelBooking(existingBooking!.id),
                    child: const Text('Cancel Booking'),
                  ),
                ],
              ),
            )
          : FutureBuilder<List<String>>(
              future: getBookedSlots(selectedDate, widget.location.name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  List<String> bookedSlots = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            widget.location.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                widget.location.address,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 16),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.home, color: Colors.black),
                                      Text('Home'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.book, color: Colors.black),
                                      Text('Book'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.directions_run,
                                          color: Colors.black),
                                      Text('Activities'),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(selectedDate),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Switch(
                                    value: showAvailableOnly,
                                    onChanged: (value) {
                                      setState(() {
                                        showAvailableOnly = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _pickDate,
                                child: const Text('Change Date'),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 2.0,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: timeSlots.length,
                          itemBuilder: (context, index) {
                            bool isBooked =
                                bookedSlots.contains(timeSlots[index]);
                            return _buildTimeSlotButton(
                                timeSlots[index],
                                _isSlotInPast(timeSlots[index]),
                                isBooked
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
    );
  }
}
