import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'match_details_screen.dart';
import 'match_screen.dart';

class AllMatchesScreen extends StatelessWidget {
  final Map<String, String> placeImages = {
    'Padel 2000 (Antwerpen)': 'assets/padel2000.jpeg',
    'Pacma (Maaseik)': 'assets/pacma.jpg',
    'Ter Eiken (Edegem)': 'assets/ter_eiken.jpg',
    'Garrincha (Hoboken)': 'assets/garincha.jpg',
    'Antwerp Padelclub (Berchem)': 'assets/berchem.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Matches'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('matches')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error fetching matches.'));
            }
            final matches = snapshot.data?.docs ?? [];
            if (matches.isEmpty) {
              return Center(child: Text('No matches available.'));
            }
            return ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(match['place']),
                    subtitle: Text(
                        'Date: ${match['date']} \nTime: ${match['time']} \nType: ${match['matchType']} \nGender: ${match['gender']} \nCreated by: ${match['creatorEmail']}'),
                    trailing: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MatchDetailsScreen(
                                  place: match['place'],
                                  date: match['date'],
                                  time: match['time'],
                                  matchType: match['matchType'],
                                  gender: match['gender'],
                                  creatorEmail: match['creatorEmail'],
                                )),
                      ),
                      child: Text('View Details'),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MatchScreen()),
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
