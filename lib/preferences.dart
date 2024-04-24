import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playtonic Preferences',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  bool isTimeFrame = true;
  String preferredTime = 'Morning';
  List<String> days = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Preferences'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(title: Text('Best Hand')),
          ToggleButtons(
            children: <Widget>[
              Text('Right-Handed'),
              Text('Left-Handed'),
              Text('Both Hands'),
            ],
            isSelected: [
              bestHand == 'Right-Handed',
              bestHand == 'Left-Handed',
              bestHand == 'Both Hands',
            ],
            onPressed: (int index) {
              setState(() {
                bestHand = ['Right-Handed', 'Left-Handed', 'Both Hands'][index];
              });
            },
          ),
          ListTile(title: Text('Court Side')),
          ToggleButtons(
            children: <Widget>[
              Text('Backhand'),
              Text('Forehand'),
              Text('Both Sides'),
            ],
            isSelected: [
              courtSide == 'Backhand',
              courtSide == 'Forehand',
              courtSide == 'Both Sides',
            ],
            onPressed: (int index) {
              setState(() {
                courtSide = ['Backhand', 'Forehand', 'Both Sides'][index];
              });
            },
          ),
          ListTile(title: Text('Match Type')),
          ToggleButtons(
            children: <Widget>[
              Text('Competitive'),
              Text('Friendly'),
              Text('Both'),
            ],
            isSelected: [
              matchType == 'Competitive',
              matchType == 'Friendly',
              matchType == 'Both',
            ],
            onPressed: (int index) {
              setState(() {
                matchType = ['Competitive', 'Friendly', 'Both'][index];
              });
            },
          ),
          ListTile(title: Text('My preferred time to play')),
          SwitchListTile(
            title: Text('Set by time frame'),
            value: isTimeFrame,
            onChanged: (bool value) {
              setState(() {
                isTimeFrame = value;
              });
            },
          ),
          if (isTimeFrame)
            ToggleButtons(
              children: <Widget>[
                Text('Morning'),
                Text('Afternoon'),
                Text('Evening'),
                Text('All day'),
              ],
              isSelected: [
                preferredTime == 'Morning',
                preferredTime == 'Afternoon',
                preferredTime == 'Evening',
                preferredTime == 'All day',
              ],
              onPressed: (int index) {
                setState(() {
                  preferredTime =
                      ['Morning', 'Afternoon', 'Evening', 'All day'][index];
                });
              },
            ),
          SwitchListTile(
            title: Text('Set by days'),
            value: !isTimeFrame,
            onChanged: (bool value) {
              setState(() {
                isTimeFrame = !value;
              });
            },
          ),
          if (!isTimeFrame)
            Wrap(
              children: List<Widget>.generate(
                7,
                (int index) {
                  return ChoiceChip(
                    label: Text(
                      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index],
                    ),
                    selected: days.contains([
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun'
                    ][index]),
                    onSelected: (bool selected) {
                      setState(() {
                        String day = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ][index];
                        if (selected) {
                          days.add(day);
                        } else {
                          days.remove(day);
                        }
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
