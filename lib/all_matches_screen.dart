import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'match_details_screen.dart';
import 'match_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllMatchesScreen extends StatelessWidget {
  final Map<String, String> placeImages = {
    'Padel 2000 (Antwerpen)': 'assets/padel2000.jpeg',
    'Pacma (Maaseik)': 'assets/pacma.jpg',
    'Ter Eiken (Edegem)': 'assets/ter_eiken.jpg',
    'Garrincha (Hoboken)': 'assets/garincha.jpg',
    'Antwerp Padelclub (Berchem)': 'assets/berchem.jpg',
  };

  void _joinMatch(String matchId, List<dynamic> participants) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && participants.length < 4) {
      String? currentUserEmail = currentUser.email;
      String? currentUserName = currentUser.displayName;

      if (currentUserEmail != null && currentUserName != null) {
        bool isAlreadyParticipant = participants.any((participant) =>
            participant is Map<String, dynamic> &&
            participant['email'] == currentUserEmail);

        if (!isAlreadyParticipant) {
          FirebaseFirestore.instance
              .collection('matches')
              .doc(matchId)
              .update({
                'participants': FieldValue.arrayUnion([
                  {'name': currentUserName, 'email': currentUserEmail}
                ])
              })
              .then((_) => print('Joined match successfully!'))
              .catchError((error) => print('Failed to join match: $error'));
        }
      }
    }
  }

  void _leaveMatch(String matchId, List<dynamic> participants) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String? currentUserEmail = currentUser.email;

      if (currentUserEmail != null) {
        var participantToRemove = participants.firstWhere((participant) =>
            participant is Map<String, dynamic> &&
            participant['email'] == currentUserEmail);

        FirebaseFirestore.instance
            .collection('matches')
            .doc(matchId)
            .update({
              'participants': FieldValue.arrayRemove([participantToRemove])
            })
            .then((_) => print('Left match successfully!'))
            .catchError((error) => print('Failed to leave match: $error'));
      }
    }
  }

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
                List<dynamic> participants =
                    match['participants'] as List<dynamic>;
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match['place'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Date: ${match['date']}'),
                        Text('Time: ${match['time']}'),
                        Text('Type: ${match['matchType']}'),
                        Text('Gender: ${match['gender']}'),
                        Text('Created by: ${match['creatorEmail']}'),
                        Text('Participants: ${participants.map((participant) {
                          if (participant is Map<String, dynamic>) {
                            return participant['name'];
                          }
                          return 'Unknown';
                        }).join(', ')}'),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MatchDetailsScreen(
                                    matchId: match.id,
                                    place: match['place'],
                                    date: match['date'],
                                    time: match['time'],
                                    matchType: match['matchType'],
                                    gender: match['gender'],
                                    creatorEmail: match['creatorEmail'],
                                  ),
                                ),
                              ),
                              child: Text('View Details'),
                            ),
                            ElevatedButton(
                              onPressed: participants.length < 4
                                  ? () => _joinMatch(match.id, participants)
                                  : null,
                              child: Text(participants.length < 4
                                  ? 'Join Match'
                                  : 'Full'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                User? currentUser =
                                    FirebaseAuth.instance.currentUser;
                                if (currentUser != null &&
                                    currentUser.email !=
                                        match['creatorEmail']) {
                                  _leaveMatch(match.id, participants);
                                }
                              },
                              child: Text('Leave Match'),
                            ),
                          ],
                        ),
                      ],
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
