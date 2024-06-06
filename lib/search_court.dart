// search_court.dart
import 'package:flutter/material.dart';
import 'package:flutter_project/book_court.dart';
import 'package:flutter_project/booked_courts.dart';
import 'location_data.dart';

class SearchCourtScreen extends StatefulWidget {
  const SearchCourtScreen({super.key});

  @override
  _SearchCourtScreenState createState() => _SearchCourtScreenState();
}

class _SearchCourtScreenState extends State<SearchCourtScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Padel Courts'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookedCourtsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(location: location),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8),
              elevation: 4,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      location.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: Text(location.name),
                    subtitle: Text(location.address),
                    trailing: Text('${location.price} €'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
