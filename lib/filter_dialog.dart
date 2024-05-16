import 'package:flutter/material.dart';
import 'extensions.dart';

class FilterDialog extends StatefulWidget {
  final Map<String, List<String>> matchTimes;
  final List<String> selectedPlaces;
  final List<DateTime> selectedDates;
  final String? selectedTime;
  final List<String> selectedHours;
  final Function(List<String>, List<DateTime>, String?, List<String>) onApply;

  const FilterDialog({super.key, 
    required this.matchTimes,
    required this.selectedPlaces,
    required this.selectedDates,
    required this.selectedTime,
    required this.selectedHours,
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
  List<DateTime> selectedDates = [];
  List<String> times = ["All day", "Morning", "Afternoon", "Evening"];
  String? selectedTime;
  List<String> availableHours = [];
  List<String> selectedHours = [];

  Map<String, String> placeImages = {
    'Padel 2000 (Antwerpen)': 'assets/padel2000.jpeg',
    'Pacma (Maaseik)': 'assets/pacma.jpg',
    'Ter Eiken (Edegem)': 'assets/ter_eiken.jpg',
    'Garrincha (Hoboken)': 'assets/garincha.jpg',
    'Antwerp Padelclub (Berchem)': 'assets/berchem.jpg'
  };

  @override
  void initState() {
    super.initState();
    selectedPlaces = widget.selectedPlaces;
    selectedDates = widget.selectedDates;
    selectedTime = widget.selectedTime;
    selectedHours = widget.selectedHours;
    if (selectedTime != null && widget.matchTimes.containsKey(selectedTime!)) {
      availableHours = widget.matchTimes[selectedTime!]!;
    }
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
        selectedDates.sort();
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

  void _toggleHourSelection(String hour) {
    setState(() {
      if (selectedHours.contains(hour)) {
        selectedHours.remove(hour);
      } else if (selectedHours.length < 6) {
        selectedHours.add(hour);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool allFiltersSelected = selectedPlaces.isNotEmpty &&
        selectedDates.isNotEmpty &&
        selectedTime != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title:
                const Text('Find new matches', style: TextStyle(color: Colors.white)),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Where do you want to play?',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: availablePlaces.map((place) {
                    bool isSelected = selectedPlaces.contains(place);
                    return FilterChip(
                      label: Text(place,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black)),
                      avatar: placeImages.containsKey(place)
                          ? CircleAvatar(
                              backgroundImage: AssetImage(placeImages[place]!),
                            )
                          : null,
                      selected: isSelected,
                      showCheckmark: false,
                      selectedColor: Colors.blue,
                      onSelected: (_) => _togglePlaceSelection(place),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Choose your days',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                        ),
                        onPressed: _selectDate,
                        child: Text(
                          selectedDates.isEmpty
                              ? 'Select Dates'
                              : 'Selected ${selectedDates.length} Dates',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8.0,
                  children: selectedDates.map((date) {
                    return Chip(
                      label: Text(date.toShortString(),
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.blue,
                      onDeleted: () {
                        setState(() {
                          selectedDates.remove(date);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Pick up your time',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: times.map((time) {
                    bool isSelected = time == selectedTime;
                    return ChoiceChip(
                      label: Text(
                        "$time (${widget.matchTimes[time]!.first} - ${widget.matchTimes[time]!.last})",
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 12),
                      ),
                      selected: isSelected,
                      showCheckmark: false,
                      selectedColor: Colors.blue,
                      onSelected: (_) {
                        setState(() {
                          selectedTime = time;
                          availableHours = widget.matchTimes[time]!;
                          selectedHours
                              .clear(); // Clear previous hour selection
                        });
                      },
                    );
                  }).toList(),
                ),
                if (selectedTime != null) ...[
                  const SizedBox(height: 16),
                  const Text('Select Specific Hours (optional, max 6)',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: availableHours.map((hour) {
                      bool isSelected = selectedHours.contains(hour);
                      return FilterChip(
                        label: Text(hour,
                            style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black)),
                        selected: isSelected,
                        showCheckmark: false,
                        selectedColor: Colors.blue,
                        onSelected: (_) => _toggleHourSelection(hour),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: allFiltersSelected ? Colors.blue : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: allFiltersSelected
                  ? () => widget.onApply(selectedPlaces, selectedDates,
                      selectedTime, selectedHours)
                  : null,
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
