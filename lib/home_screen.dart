import 'package:flutter/material.dart';
import 'package:flutter_project/book_court.dart';
import 'search_court.dart'; // Ensure this import is correct

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'PLAYTOMIC',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.menu, color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[800],
            child: const Text(
              'GET ONE STEP AHEAD\nGet notified for available courts, grant your matches more visibility and discover your advanced statistics',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Find your perfect match',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: <Widget>[
                _buildCard(context, 'Book a court', Icons.search,
                    'If you already know who you are playing with'),
                _buildCard(context, 'Play an open match', Icons.sports_tennis,
                    'If you are looking for players at your level'),
                _buildCard(context, 'Classes', Icons.class_, ''),
                _buildCard(context, 'Competitions', Icons.emoji_events, ''),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'Play'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discovery'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, String subtitle) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          if (title == 'Book a court') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchCourtScreen()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
