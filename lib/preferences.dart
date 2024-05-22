import 'package:flutter/material.dart';

class PreferencesDialog extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(String, dynamic) updateUserData;

  const PreferencesDialog({
    required this.userData,
    required this.updateUserData,
  });

  @override
  _PreferencesDialogState createState() => _PreferencesDialogState();
}

class _PreferencesDialogState extends State<PreferencesDialog> {
  late String bestHand;
  late String courtSide;
  late String matchType;
  late String preferredTime;
  bool setTimeFrame = false;
  bool setDays = false;
  List<String> days = [];

  @override
  void initState() {
    super.initState();
    bestHand = widget.userData['bestHand'] ?? 'Right-Handed';
    courtSide = widget.userData['courtSide'] ?? 'Backhand';
    matchType = widget.userData['matchType'] ?? 'Competitive';
    preferredTime = widget.userData['preferredTime'] ?? 'Morning';
    days = List<String>.from(widget.userData['days'] ?? []);
  }

  Widget buildChoiceChip(String label, String value, String groupValue) {
    bool isSelected = groupValue == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            switch (label) {
              case 'Right-Handed':
              case 'Left-Handed':
              case 'Both Hands':
                bestHand = value;
                break;
              case 'Backhand':
              case 'Forehand':
              case 'Both Sides':
                courtSide = value;
                break;
              case 'Competitive':
              case 'Friendly':
              case 'Both':
                matchType = value;
                break;
              case 'Morning':
              case 'Afternoon':
              case 'Evening':
              case 'All day':
                preferredTime = value;
                break;
              default:
            }
          }
        });
      },
      showCheckmark: false,
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Player Preferences'),
      content: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildPreferenceTitle('Best Hand'),
            const SizedBox(height: 8),
            buildToggleGroup(
              ['Right-Handed', 'Left-Handed', 'Both Hands'],
              bestHand,
              (value) => setState(() => bestHand = value),
            ),
            const SizedBox(height: 24),
            buildPreferenceTitle('Court Side'),
            const SizedBox(height: 8),
            buildToggleGroup(
              ['Backhand', 'Forehand', 'Both Sides'],
              courtSide,
              (value) => setState(() => courtSide = value),
            ),
            const SizedBox(height: 24),
            buildPreferenceTitle('Match Type'),
            const SizedBox(height: 8),
            buildToggleGroup(
              ['Competitive', 'Friendly', 'Both'],
              matchType,
              (value) => setState(() => matchType = value),
            ),
            const SizedBox(height: 24),
            buildPreferenceTitle('Preferred Time to Play'),
            const SizedBox(height: 8),
            buildSwitchTile(
              'Set by Time Frame',
              setTimeFrame,
              (bool value) => setState(() => setTimeFrame = value),
            ),
            if (setTimeFrame) ...[
              const SizedBox(height: 8),
              buildToggleGroup(
                ['Morning', 'Afternoon', 'Evening', 'All day'],
                preferredTime,
                (value) => setState(() => preferredTime = value),
              ),
            ],
            const SizedBox(height: 24),
            buildSwitchTile(
              'Set by Days',
              setDays,
              (bool value) => setState(() => setDays = value),
            ),
            if (setDays) ...[
              const SizedBox(height: 8),
              buildPreferenceTitle('Preferred Days'),
              buildDaysSelection(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.updateUserData('bestHand', bestHand);
            widget.updateUserData('courtSide', courtSide);
            widget.updateUserData('matchType', matchType);
            widget.updateUserData('preferredTime', preferredTime);
            widget.updateUserData('days', days);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Padding buildPreferenceTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Wrap buildToggleGroup(
      List<String> labels, String groupValue, Function(String) onChanged) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0, // Additional spacing between rows
      children: labels.map((label) {
        return buildChoiceChip(label, label, groupValue);
      }).toList(),
    );
  }

  Wrap buildDaysSelection() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List<Widget>.generate(
        7,
        (int index) {
          final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index];
          bool isSelected = days.contains(day);
          return FilterChip(
            label: Text(day),
            selected: isSelected,
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  days.add(day);
                } else {
                  days.remove(day);
                }
              });
            },
            showCheckmark: false,
            selectedColor: Colors.blue,
            backgroundColor: Colors.grey[200],
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  SwitchListTile buildSwitchTile(
      String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
    );
  }
}
