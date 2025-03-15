// accent_cities.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccentCitiesScreen extends StatefulWidget {
  final String selectedState;
  final String selectedCity;

  const AccentCitiesScreen({
    super.key,
    required this.selectedState,
    required this.selectedCity,
  });

  @override
  State<AccentCitiesScreen> createState() => _AccentCitiesScreenState();
}

class _AccentCitiesScreenState extends State<AccentCitiesScreen> {
  List<String> accentCities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAccentCities();
  }

  Future<void> fetchAccentCities() async {
    try {
      final response = await http.get(
        Uri.parse('http://13.200.179.78/location'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          accentCities = data.map((city) => city.toString()).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching accent cities: $e');
    }
  }

  Future<void> updateLocation() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://13.200.179.78/adposts?city=${widget.selectedCity}&state=${widget.selectedState}'),
      );

      if (mounted && response.statusCode == 200) {
        // Return the selected location data back to previous screens
        Navigator.pop(context, {
          'state': widget.selectedState,
          'city': widget.selectedCity,
          'accent_city':
              accentCities[0], // You can modify this based on selection
        });
      }
    } catch (e) {
      debugPrint('Error updating location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Areas in ${widget.selectedCity}'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: accentCities.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            accentCities[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(Icons.location_on, size: 20),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: updateLocation,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirm Location',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
