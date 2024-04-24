import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playtonic Preferences',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PreferencesScreen(),
    );
  }
}

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String bestHand = 'Right-Handed';
  String courtSide = 'Backhand';
  String matchType = 'Competitive';
  bool setTimeFrame = false;
  bool setDays = false;
  String preferredTime = 'Morning';
  List<String> days = [];

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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? Colors.blue : Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Preferences'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildPreferenceTitle('Best Hand'),
            SizedBox(height: 8),
            buildToggleGroup(
              ['Right-Handed', 'Left-Handed', 'Both Hands'],
              bestHand,
              (value) => setState(() => bestHand = value),
            ),
            SizedBox(height: 24),
            buildPreferenceTitle('Court Side'),
            SizedBox(height: 8),
            buildToggleGroup(
              ['Backhand', 'Forehand', 'Both Sides'],
              courtSide,
              (value) => setState(() => courtSide = value),
            ),
            SizedBox(height: 24),
            buildPreferenceTitle('Match Type'),
            SizedBox(height: 8),
            buildToggleGroup(
              ['Competitive', 'Friendly', 'Both'],
              matchType,
              (value) => setState(() => matchType = value),
            ),
            SizedBox(height: 24),
            buildPreferenceTitle('My Preferred Time to Play'),
            SizedBox(height: 8),
            buildSwitchTile(
              'Set by Time Frame',
              setTimeFrame,
              (bool value) => setState(() => setTimeFrame = value),
            ),
            if (setTimeFrame) ...[
              SizedBox(height: 8),
              buildToggleGroup(
                ['Morning', 'Afternoon', 'Evening', 'All day'],
                preferredTime,
                (value) => setState(() => preferredTime = value),
              ),
            ],
            SizedBox(height: 24),
            buildSwitchTile(
              'Set by Days',
              setDays,
              (bool value) => setState(() => setDays = value),
            ),
            if (setDays) ...[
              SizedBox(height: 8),
              buildDaysSelection(),
            ],
          ],
        ),
      ),
    );
  }

  Padding buildPreferenceTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isSelected ? Colors.blue : Colors.black),
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
