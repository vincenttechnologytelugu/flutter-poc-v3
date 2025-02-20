// lib/screens/deactivate_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/package_screen.dart';
import 'package:flutter_poc_v3/services/my_ads_sevice.dart';

class DeactivateScreen extends StatelessWidget {
  final Map<String, dynamic> ad;
  final MyAdsService _myAdsService = MyAdsService();

  DeactivateScreen({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deactivated Ad'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${ad['_id']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        ad['thumb'] ?? '',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Price: \$${ad['price'] ?? ''}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    if (ad['action_flags']['publish'])
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await _myAdsService.publishAd(ad['_id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Ad published successfully')),
                            );
                            Navigator.pop(context,
                                true); // Return true to indicate success
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Failed to publish ad: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'PUBLISH',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PackageScreen()
                              // OfferPackageScreen(adId: ad['_id']),
                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'POST NOW',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
