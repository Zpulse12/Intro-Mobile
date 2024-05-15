import 'package:flutter/material.dart';
import 'all_matches_screen.dart';

class MatchDetailsScreen extends StatelessWidget {
  final String place;
  final String date;
  final String time;
  final String matchType;
  final String gender;
  final String creatorEmail;

  MatchDetailsScreen({
    required this.place,
    required this.date,
    required this.time,
    required this.matchType,
    required this.gender,
    required this.creatorEmail,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> placeImages = {
      'Padel 2000 (Antwerpen)': 'assets/padel2000.jpeg',
      'Pacma (Maaseik)': 'assets/pacma.jpg',
      'Ter Eiken (Edegem)': 'assets/ter_eiken.jpg',
      'Garrincha (Hoboken)': 'assets/garincha.jpg',
      'Antwerp Padelclub (Berchem)': 'assets/berchem.jpg'
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Match Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Match Details:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 8),
            Text('Place: $place',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('Date: $date',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('Time: $time',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('Match Type: $matchType',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('Gender: $gender',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('Created by: $creatorEmail',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 16),
            placeImages.containsKey(place)
                ? Image.asset(
                    placeImages[place]!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.0),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AllMatchesScreen()),
            );
          },
          child: Text(
            'Back to All Matches',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
