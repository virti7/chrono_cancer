import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailedMapScreen extends StatelessWidget {
  final dynamic currentPosition;
  final List<Map<String, dynamic>> hospitals;

  const DetailedMapScreen({
    Key? key,
    required this.currentPosition,
    required this.hospitals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🔹 If location is not yet available
    if (currentPosition == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Hospitals"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              // User marker
              Marker(
                point: LatLng(currentPosition.latitude, currentPosition.longitude),
                width: 40,
                height: 40,
                child: const Icon(Icons.my_location, color: Colors.green, size: 30),
              ),
              // Hospitals
              ...hospitals.map((hospital) {
                return Marker(
                  point: LatLng(hospital['lat'], hospital['lng']),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(hospital['name'] ?? "Hospital"),
                          content: Text("Specialty: ${hospital['specialty']}"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text("Close"),
                            )
                          ],
                        ),
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      color: hospital['specialty'] == "Cancer"
                          ? Colors.orange
                          : Colors.blue,
                      size: 30,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}