import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  Map<String, List<String>> matchTimes = {
    "All day": [
      "08:00",
      "09:00",
      "09:30",
      "10:00",
      "11:00",
      "12:00",
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

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          selectedPlaces: selectedPlaces,
          selectedDates: selectedDates,
          selectedTime: selectedTime,
          onApply: (places, dates, time) {
            setState(() {
              selectedPlaces = places;
              selectedDates = dates;
              selectedTime = time;
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _onTimeSlotSelected(String place, String date, String time) {
    // Navigate to the next screen (to be implemented later)
    print("Selected Place: $place, Date: $date, Time: $time");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Apply filters to see available matches',
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: selectedPlaces.isEmpty
                ? Center(
                    child: Text(
                      'No matches available.\nApply filters to see available matches.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: selectedPlaces.length,
                    itemBuilder: (context, placeIndex) {
                      final place = selectedPlaces[placeIndex];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ExpansionTile(
                            title: Text(place),
                            children: selectedDates.map((date) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Date: ${date.toShortString()}'),
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: _getMatchTimes().map((time) {
                                        return ElevatedButton(
                                          onPressed: () => _onTimeSlotSelected(
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
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _openFilterDialog,
              child: Text('Start a match'),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getMatchTimes() {
    if (selectedTime == null || !matchTimes.containsKey(selectedTime)) {
      return [];
    }
    return matchTimes[selectedTime]!;
  }
}

class FilterDialog extends StatefulWidget {
  final List<String> selectedPlaces;
  final List<DateTime> selectedDates;
  final String? selectedTime;
  final Function(List<String>, List<DateTime>, String?) onApply;

  FilterDialog({
    required this.selectedPlaces,
    required this.selectedDates,
    required this.selectedTime,
    required this.onApply,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<String> availablePlaces = [
    'Padel 2000 (Antwerpen)',
    'Pacma (Maaseik)',
    'Ter Eiken (Edegem)',
    'Garrincha (Hoboken)',
    'Antwerp Padelclub (Berchem)',
  ];
  List<String> selectedPlaces = [];
  List<DateTime> selectedDates = [];
  List<String> times = ["All day", "Morning", "Afternoon", "Evening"];
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedPlaces = widget.selectedPlaces;
    selectedDates = widget.selectedDates;
    selectedTime = widget.selectedTime;
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && !selectedDates.contains(picked)) {
      setState(() {
        selectedDates.add(picked);
      });
    }
  }

  void _togglePlaceSelection(String place) {
    setState(() {
      if (selectedPlaces.contains(place)) {
        selectedPlaces.remove(place);
      } else {
        selectedPlaces.add(place);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Text('Find new matches'),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text('Where do you want to play?',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Wrap(
                  children: availablePlaces.map((place) {
                    bool isSelected = selectedPlaces.contains(place);
                    return ChoiceChip(
                      label: Text(place),
                      selected: isSelected,
                      onSelected: (_) => _togglePlaceSelection(place),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Text('Choose your days',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _selectDate,
                        child: Text(selectedDates.isEmpty
                            ? 'Select Dates'
                            : 'Selected ${selectedDates.length} Dates'),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8.0,
                  children: selectedDates.map((date) {
                    return Chip(
                      label: Text(date.toShortString()),
                      onDeleted: () {
                        setState(() {
                          selectedDates.remove(date);
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Text('Pick your time',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Wrap(
                  children: times.map((time) {
                    bool isSelected = time == selectedTime;
                    return ChoiceChip(
                      label: Text(time),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedTime = time;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(selectedPlaces, selectedDates, selectedTime);
              },
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}
