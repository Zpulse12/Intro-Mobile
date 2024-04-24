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
    return ChoiceChip(
      label: Text(label),
      selected: groupValue == value,
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
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            buildPreferenceTitle('Best Hand'),
            buildToggleGroup(
              ['Right-Handed', 'Left-Handed', 'Both Hands'],
              bestHand,
              (value) => setState(() => bestHand = value),
            ),
            buildPreferenceTitle('Court Side'),
            buildToggleGroup(
              ['Backhand', 'Forehand', 'Both Sides'],
              courtSide,
              (value) => setState(() => courtSide = value),
            ),
            buildPreferenceTitle('Match Type'),
            buildToggleGroup(
              ['Competitive', 'Friendly', 'Both'],
              matchType,
              (value) => setState(() => matchType = value),
            ),
            buildPreferenceTitle('My Preferred Time to Play'),
            SwitchListTile(
              title: Text('Set by Time Frame'),
              value: setTimeFrame,
              onChanged: (bool value) {
                setState(() {
                  setTimeFrame = value;
                });
              },
            ),
            if (setTimeFrame)
              buildToggleGroup(
                ['Morning', 'Afternoon', 'Evening', 'All day'],
                preferredTime,
                (value) => setState(() => preferredTime = value),
              ),
            SwitchListTile(
              title: Text('Set by Days'),
              value: setDays,
              onChanged: (bool value) {
                setState(() {
                  setDays = value;
                });
              },
            ),
            if (setDays) buildDaysSelection(),
          ],
        ),
      ),
    );
  }

  Padding buildPreferenceTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
      children: labels.map((label) {
        return buildChoiceChip(label, label, groupValue);
      }).toList(),
    );
  }

  Wrap buildDaysSelection() {
    return Wrap(
      spacing: 8.0,
      children: List<Widget>.generate(
        7,
        (int index) {
          final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index];
          return FilterChip(
            label: Text(day),
            selected: days.contains(day),
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
            backgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
