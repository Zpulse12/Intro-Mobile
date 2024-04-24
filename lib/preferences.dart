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
        ],
      ),
    );
  }
}
