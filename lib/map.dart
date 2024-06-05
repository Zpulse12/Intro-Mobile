import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'location_data.dart';
class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.2194, 4.4025),  // Centreren de map rond antwerpen
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: locations.map((location) {
              return Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(location.latitude, location.longitude),
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    _showLocationDetails(context, location);
                  },
                  child: Icon(Icons.location_on, color: Colors.red, size: 40.0),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

void _showLocationDetails(BuildContext context, Location location) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(location.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(location.imageUrl, fit: BoxFit.cover),
              const SizedBox(height: 8),
              Text(location.address),
              const SizedBox(height: 8),
              Text('Price: \$${location.price}'),
              const SizedBox(height: 8),
              Text('Available Times: ${location.times.join(', ')}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}