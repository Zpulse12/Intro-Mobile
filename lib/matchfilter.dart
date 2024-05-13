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
  DateTimeRange? selectedDateRange;
  List<String> times = ["All day", "Morning", "Afternoon", "Evening"];
  String? selectedTime;

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          selectedPlaces: selectedPlaces,
          selectedDateRange: selectedDateRange,
          selectedTime: selectedTime,
          onApply: (places, dateRange, time) {
            setState(() {
              selectedPlaces = places;
              selectedDateRange = dateRange;
              selectedTime = time;
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
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
            child: Center(
              child: Text(
                'No matches available.\nApply filters to see available matches.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
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
}

class FilterDialog extends StatefulWidget {
  final List<String> selectedPlaces;
  final DateTimeRange? selectedDateRange;
  final String? selectedTime;
  final Function(List<String>, DateTimeRange?, String?) onApply;

  FilterDialog({
    required this.selectedPlaces,
    required this.selectedDateRange,
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
    'Antwerp Padelclub (Berchem)'
  ];
  List<String> selectedPlaces = [];
  DateTimeRange? selectedDateRange;
  List<String> times = ["All day", "Morning", "Afternoon", "Evening"];
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedPlaces = widget.selectedPlaces;
    selectedDateRange = widget.selectedDateRange;
    selectedTime = widget.selectedTime;
  }

  void _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
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
                Text('Choose your days (max. 7)',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _selectDateRange,
                        child: Text(selectedDateRange == null
                            ? 'Select Date Range'
                            : '${selectedDateRange!.start.toLocal()} - ${selectedDateRange!.end.toLocal()}'),
                      ),
                    ),
                  ],
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
                widget.onApply(selectedPlaces, selectedDateRange, selectedTime);
              },
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
