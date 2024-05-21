import 'package:flutter/material.dart';
import 'configure_match_screen.dart';
import 'filter_dialog.dart';
import 'extensions.dart';
import 'all_matches_screen.dart';
import 'book_helper.dart';
import 'package:intl/intl.dart';

void main() => runApp(MatchScreenApp());

class MatchScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MatchScreen(),
    );
  }
}

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<String> selectedPlaces = [];
  List<DateTime> selectedDates = [];
  String? selectedTime;
  List<String> selectedHours = [];

  Map<String, List<String>> matchTimes = {
    "All day": [
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
    ],
    "Morning": ["09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00"],
    "Afternoon": [
      "12:30",
      "13:00",
      "13:30",
      "14:00",
      "14:30",
      "15:00",
      "15:30",
      "16:00",
      "16:30",
      "17:00"
    ],
    "Evening": ["17:30", "18:00", "18:30", "19:00", "19:30", "20:00"]
  };

  Map<String, String> placeImages = {
    'Padel 2000 (Antwerpen)': 'assets/padel2000.jpeg',
    'Pacma (Maaseik)': 'assets/pacma.jpg',
    'Ter Eiken (Edegem)': 'assets/ter_eiken.jpg',
    'Garrincha (Hoboken)': 'assets/garincha.jpg',
    'Antwerp Padelclub (Berchem)': 'assets/berchem.jpg'
  };

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          matchTimes: matchTimes,
          selectedPlaces: selectedPlaces,
          selectedDates: selectedDates,
          selectedTime: selectedTime,
          selectedHours: selectedHours,
          onApply: (places, dates, time, hours) {
            setState(() {
              selectedPlaces = places;
              selectedDates = dates;
              selectedTime = time;
              selectedHours = hours;
              selectedDates.sort();
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _onTimeSlotSelected(String place, String date, String time) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfigureMatchScreen(
          place: place,
          date: date,
          time: time,
          onMatchCreated: _onMatchCreated,
        ),
      ),
    );
  }

  void _onMatchCreated() {
    print("Match Created!");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AllMatchesScreen()),
    );
  }

  Future<List<String>> _getAvailableMatchTimes(
      DateTime date, String place) async {
    List<String> times = matchTimes[selectedTime] ?? [];
    List<Map<String, String>> bookedSlots = await getBookedSlots(date, place);

    if (date.isSameDate(DateTime.now())) {
      final now = TimeOfDay.now();
      times = times.where((time) {
        final split = time.split(":");
        final hour = int.parse(split[0]);
        final minute = int.parse(split[1]);
        final timeOfDay = TimeOfDay(hour: hour, minute: minute);
        return timeOfDay.isAfter(now);
      }).toList();
    }

    return times.where((time) {
      String endTime = _calculateEndTime(time);
      return !_isOverlapping(time, endTime, bookedSlots);
    }).toList();
  }

  String _calculateEndTime(String startTime) {
    final DateFormat format = DateFormat.Hm();
    DateTime start = format.parse(startTime);
    DateTime end = start.add(Duration(minutes: 90));
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

  @override
  Widget build(BuildContext context) {
    bool allFiltersApplied = selectedPlaces.isNotEmpty &&
        selectedDates.isNotEmpty &&
        selectedTime != null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              allFiltersApplied ? 'Here are all the available matches:' : '',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Expanded(
            child: allFiltersApplied
                ? ListView.builder(
                    itemCount: selectedPlaces.length,
                    itemBuilder: (context, placeIndex) {
                      final place = selectedPlaces[placeIndex];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  place,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              placeImages.containsKey(place)
                                  ? Image.asset(
                                      placeImages[place]!,
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: selectedDates.map((date) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date: ${date.toShortString()}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 8),
                                        FutureBuilder<List<String>>(
                                          future: _getAvailableMatchTimes(
                                              date, place),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return Text('No available times');
                                            }
                                            return Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children:
                                                  snapshot.data!.map((time) {
                                                return ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () =>
                                                      _onTimeSlotSelected(
                                                          place,
                                                          date.toShortString(),
                                                          time),
                                                  child: Text(time),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No matches available.\nApply filters to see available matches.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: _openFilterDialog,
              child: Text(
                'Start a match',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
