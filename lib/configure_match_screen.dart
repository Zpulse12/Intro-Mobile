import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'match_details_screen.dart';

class ConfigureMatchScreen extends StatefulWidget {
  final String place;
  final String date;
  final String time;
  final VoidCallback onMatchCreated;

  ConfigureMatchScreen({
    required this.place,
    required this.date,
    required this.time,
    required this.onMatchCreated,
  });

  @override
  _ConfigureMatchScreenState createState() => _ConfigureMatchScreenState();
}

class _ConfigureMatchScreenState extends State<ConfigureMatchScreen> {
  String matchType = 'Competitive';
  String gender = 'All players';

  void _createMatch() {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? "Unknown";
    FirebaseFirestore.instance.collection('matches').add({
      'place': widget.place,
      'date': widget.date,
      'time': widget.time,
      'matchType': matchType,
      'gender': gender,
      'creatorEmail': userEmail,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MatchDetailsScreen(
            place: widget.place,
            date: widget.date,
            time: widget.time,
            matchType: matchType,
            gender: gender,
            creatorEmail: userEmail,
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create match: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configure Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match Details:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8),
            Text('Place: ${widget.place}',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('Date: ${widget.date}',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('Time: ${widget.time}',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 16),
            Text(
              'Choose your type of match',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8),
            ListTile(
              title: const Text('Competitive Match'),
              subtitle:
                  const Text('The result will affect your level and rankings.'),
              leading: Radio<String>(
                value: 'Competitive',
                groupValue: matchType,
                onChanged: (value) {
                  setState(() {
                    matchType = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Friendly Match'),
              subtitle: const Text(
                  'The result will not affect your level or rankings.'),
              leading: Radio<String>(
                value: 'Friendly',
                groupValue: matchType,
                onChanged: (value) {
                  setState(() {
                    matchType = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Select the gender you want to play with',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8),
            ListTile(
              title: const Text('All players'),
              subtitle: const Text('All players can join'),
              leading: Radio<String>(
                value: 'All players',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Men only'),
              subtitle: const Text('Men-only match'),
              leading: Radio<String>(
                value: 'Men only',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Women only'),
              subtitle: const Text('Women-only match'),
              leading: Radio<String>(
                value: 'Women only',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Mixed'),
              subtitle: const Text('A man and a woman on each team'),
              leading: Radio<String>(
                value: 'Mixed',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: _createMatch,
              child: Text(
                'Create Match',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
