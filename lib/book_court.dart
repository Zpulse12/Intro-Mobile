import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'book_helper.dart';
import 'location_data.dart';
import 'booked_courts.dart';

class BookingScreen extends StatefulWidget {
  final Location location;

  const BookingScreen({super.key, required this.location});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<String> timeSlots = [
    "09:00",
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
    "13:00",
    "13:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00",
    "16:30",
    "17:00",
    "17:30",
    "18:00",
    "18:30",
    "19:00",
    "19:30",
    "20:00"
  ];
  DateTime selectedDate = DateTime.now();
  bool showAvailableOnly = false;

  Future<void> _handleBooking(String timeSlot) async {
    try {
      await bookCourt(selectedDate, timeSlot, widget.location.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Booking successful for $timeSlot on ${DateFormat('dd/MM/yyyy').format(selectedDate)}")),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
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

  bool _isSlotInPast(String slot) {
    DateTime now = DateTime.now();
    List<String> parts = slot.split(':');
    DateTime slotTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, int.parse(parts[0]), int.parse(parts[1]));
    return slotTime.isBefore(now);
  }

  bool _isSlotUnavailable(String slot, List<Map<String, String>> bookedSlots) {
    final DateFormat format = DateFormat.Hm();
    DateTime slotTime = format.parse(slot);

    for (var bookedSlot in bookedSlots) {
      DateTime bookedStart = format.parse(bookedSlot['startTime']!);
      DateTime bookedEnd = format.parse(bookedSlot['endTime']!);

      if ((slotTime.isAtSameMomentAs(bookedStart) ||
              slotTime.isAtSameMomentAs(bookedEnd)) ||
          (slotTime.isAfter(bookedStart) && slotTime.isBefore(bookedEnd))) {
        return true;
      }

      if (slot == "09:30" || slot == "10:00") {
        DateTime bookedStartMinus30 =
            bookedStart.subtract(Duration(minutes: 30));
        if ((slotTime.isAtSameMomentAs(bookedStartMinus30)) ||
            (slotTime.isAfter(bookedStartMinus30) &&
                slotTime.isBefore(bookedEnd))) {
          return true;
        }
      }
    }

    return false;
  }

  Widget _buildTimeSlotButton(String time, bool isPast, bool isUnavailable) {
    return ElevatedButton(
      onPressed: isPast || isUnavailable
          ? null
          : () {
              _handleBooking(time);
            },
      style: ElevatedButton.styleFrom(
        foregroundColor: isPast || isUnavailable ? Colors.grey : Colors.black,
        backgroundColor:
            isPast || isUnavailable ? Colors.grey[300] : Colors.white,
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
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookedCourtsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: getBookedSlots(selectedDate, widget.location.name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<Map<String, String>> bookedSlots = snapshot.data!;
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              DateFormat('dd/MM/yyyy').format(selectedDate),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                      bool isUnavailable =
                          _isSlotUnavailable(timeSlots[index], bookedSlots);
                      return _buildTimeSlotButton(timeSlots[index],
                          _isSlotInPast(timeSlots[index]), isUnavailable);
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
