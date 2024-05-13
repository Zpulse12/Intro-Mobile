import 'package:flutter/material.dart';
import 'configure_match_screen.dart';
import 'filter_dialog.dart';
import 'extensions.dart';

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
      "08:00",
      "09:00",
      "09:30",
      "10:00",
      "11:00",
      "12:00",
      "13:00",
      "14:00",
      "15:00",
      "16:00",
      "17:00",
      "18:00",
      "19:00",
      "20:00",
      "21:00",
      "22:00"
    ],
    "Morning": ["08:00", "09:00", "09:30", "10:00", "11:00", "12:00"],
    "Afternoon": ["12:30", "13:00", "14:00", "15:00", "16:00", "17:00"],
    "Evening": ["17:30", "18:00", "19:00", "20:00", "21:00", "22:00"]
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
  }

  List<String> _getMatchTimes(DateTime date) {
    if (selectedTime == null || !matchTimes.containsKey(selectedTime)) {
      return [];
    }

    List<String> times = matchTimes[selectedTime]!;
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

    if (selectedHours.isNotEmpty) {
      return times.where((time) => selectedHours.contains(time)).toList();
    }

    return times;
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
                                        Wrap(
                                          spacing: 8.0,
                                          runSpacing: 4.0,
                                          children:
                                              _getMatchTimes(date).map((time) {
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                foregroundColor: Colors.white,
                                              ),
                                              onPressed: () =>
                                                  _onTimeSlotSelected(
                                                      place,
                                                      date.toShortString(),
                                                      time),
                                              child: Text(time),
                                            );
                                          }).toList(),
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
