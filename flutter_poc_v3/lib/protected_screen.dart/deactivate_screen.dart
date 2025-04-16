// lib/screens/deactivate_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/package_screen.dart';
import 'package:flutter_poc_v3/services/my_ads_sevice.dart';
import 'package:intl/intl.dart';

class DeactivateScreen extends StatefulWidget {
  final Map<String, dynamic> ad;

  const DeactivateScreen({super.key, required this.ad});

  @override
  State<DeactivateScreen> createState() => _DeactivateScreenState();
}

class _DeactivateScreenState extends State<DeactivateScreen> {
  final MyAdsService _myAdsService = MyAdsService();
  String? formatSalary(dynamic salary) {
  if (salary == null) return null;
  try {
    final amount = salary is num ? salary.toDouble() : double.tryParse(salary.toString());
    if (amount == null) return null;
    return '₹${NumberFormat('#,##0', 'en_IN').format(amount)}';
  } catch (e) {
    return null;
  }
}


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
                      'ID: ${widget.ad['_id']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(8),
                    //   child: Image.network(
                    //     widget.ad['thumb'] ?? '',
                    //     height: 200,
                    //     width: double.infinity,
                    //     fit: BoxFit.cover,
                    //     errorBuilder: (context, error, stackTrace) => Center(
                    //       child: Container(
                    //         height: 200,
                    //         color: Colors.grey[300],
                    //         child: Icon(Icons.image_not_supported, size: 200),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'http://13.200.179.78/${widget.ad['assets']?[0]?['url'] ?? widget.ad['thumb'] ?? ''}',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, size: 200),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                    Text(
                      'Title: ${widget.ad['title'] ?? ''}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                   
                    // Text(
                    //   'Price: ₹${widget.ad['price'] ?? ''}',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Text(
  widget.ad['category']?.toString().toLowerCase() == 'jobs'
      ? 'Salary: ${formatSalary(widget.ad['salary']) ?? 'N/A'}'
      : widget.ad['price'] != null && widget.ad['price'] != 0
          ? 'Price: ₹${NumberFormat('#,##0', 'en_IN').format(widget.ad['price'])}'
          : widget.ad['category']?.toString().toLowerCase() == 'jobs'
              ? 'Salary: Negotiable'
              : 'Price: N/A',
  style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 7, 13, 6),
    letterSpacing: 1.2,
    fontStyle: FontStyle.normal,
  ),
  overflow: TextOverflow.ellipsis,
),

                    SizedBox(height: 24),
                    if (widget.ad['action_flags']['publish'])
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Align buttons evenly with space in between
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await _myAdsService.publishAd(
                                    context, widget.ad['_id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Ad published successfully')),
                                );
                                Navigator.pop(context,
                                    true); // Return true to indicate success
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to publish ad: $e')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              elevation:
                                  5, // Adding shadow for a more elevated look
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                              ),
                            ),
                            child: Text(
                              'PUBLISH',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16), // Add space between the buttons
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PackageScreen(), // Update to the correct screen
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              elevation:
                                  5, // Adding shadow for a more elevated look
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                              ),
                            ),
                            child: Text(
                              'POST NOW',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                    //   ElevatedButton(
                    //     onPressed: () async {
                    //       try {
                    //         await _myAdsService.publishAd(ad['_id']);
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(
                    //               content: Text('Ad published successfully')),
                    //         );
                    //         Navigator.pop(context,
                    //             true); // Return true to indicate success
                    //       } catch (e) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(
                    //               content: Text('Failed to publish ad: $e')),
                    //         );
                    //       }
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.green,
                    //       padding: EdgeInsets.symmetric(vertical: 12),
                    //     ),
                    //     child: Text(
                    //       'PUBLISH',
                    //       style: TextStyle(fontSize: 16),
                    //     ),
                    //   ),
                    // SizedBox(height: 16),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => PackageScreen()
                    //           // OfferPackageScreen(adId: ad['_id']),
                    //           ),
                    //     );
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     padding: EdgeInsets.symmetric(vertical: 12),
                    //   ),
                    //   child: Text(
                    //     'POST NOW',
                    //     style: TextStyle(fontSize: 16),
                    //   ),
                    // ),
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
