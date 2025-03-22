import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_poc_v3/protected_screen.dart/deactivate_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/edit_my_ad_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/favourite_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';

import 'package:flutter_poc_v3/protected_screen.dart/package_screen.dart';
import 'package:flutter_poc_v3/services/my_ads_sevice.dart';
import 'package:cached_network_image/cached_network_image.dart';
class MyAdds extends StatefulWidget {
  const MyAdds({super.key});

  @override
  State<MyAdds> createState() => _MyAddsState();
}

class _MyAddsState extends State<MyAdds> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final MyAdsService _myAdsService = MyAdsService();
  List<dynamic> myAds = [];
  bool isLoading = true;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    _loadMyAds();
  }

  Future<void> _loadMyAds() async {
    try {
      final ads = await _myAdsService.getMyAds();
      setState(() {
        myAds = ads;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ads: $e')),
      );
    }
  }

  // Add these methods for showing confirmation dialogs
  void _showRemoveConfirmation(String adId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Ad'),
          content: Text(
              'You are about to remove your ad. You won\'t be able to undo this.'),
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: Text('REMOVE', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _removeAd(adId); // Call existing remove method
              },
            ),
          ],
        );
      },
    );
  }

  void _showSoldConfirmation(String adId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mark as Sold'),
          content: Text('Did you sell your ad?'),
          actions: [
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: Text('YES', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _markAsSold(adId); // Call existing sold method
              },
            ),
          ],
        );
      },
    );
  }

  // Update the _showOptionsDialog method
  void _showOptionsDialog(Map<String, dynamic> ad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ad['action_flags']['edit'])
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: ad['action_flags']['edit'] ? Colors.blue : Colors.grey,
                ),
                title: Text(
                  'Edit',
                  style: TextStyle(
                    color:
                        ad['action_flags']['edit'] ? Colors.black : Colors.grey,
                  ),
                ),
                onTap: ad['action_flags']['edit']
                    ? () {
                        Navigator.pop(context);
                        _navigateToEditScreen(ad);
                      }
                    : null,
                // onTap: () {
                //   Navigator.pop(context);
                //   _navigateToEditScreen(ad);
                // },
              ),
            if (ad['action_flags']['mark_as_inactive'])
              ListTile(
                leading: Icon(Icons.pause_circle_outline),
                title: Text('Deactivate'),
                onTap: () {
                  Navigator.pop(context);
                  _deactivateAd(ad['_id']);
                },
              ),
            if (ad['action_flags']['remove'])
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color:
                      ad['action_flags']['remove'] ? Colors.red : Colors.grey,
                ),
                title: Text(
                  'Remove',
                  style: TextStyle(
                    color: ad['action_flags']['remove']
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
                onTap: ad['action_flags']['remove']
                    ? () {
                        Navigator.pop(context);
                        _showRemoveConfirmation(ad['_id']);
                      }
                    : null,
                // onTap: () {
                //   Navigator.pop(context);
                //   _showRemoveConfirmation(ad['_id']);
                // },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeAd(String adId) async {
    try {
      final success = await _myAdsService.removeAd(adId);
      if (success) {
        setState(() {
          myAds.removeWhere((ad) => ad['_id'] == adId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ad removed successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove ad: $e')),
      );
    }
  }

  Future<void> _deactivateAd(String adId) async {
    try {
      final updatedAd = await _myAdsService.markAsInactive(adId);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ad marked as inactive successfully')),
        );
        _loadMyAds(); // Reload to update UI with new action flags
        // Navigate to DeactivateScreen
        if (updatedAd != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeactivateScreen(ad: updatedAd),
            ),
          ).then((_) => _loadMyAds());
        }
      }
    } catch (e) {
      log("Deactivate Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to deactivate ad')),
        );
      }
    }
  }

  bool _isFeaturedEnabled(Map<String, dynamic> ad) {
    // Check if all action flags are true
    if (!ad['isActive'] ||
        !ad['action_flags']['edit'] ||
        !ad['action_flags']['remove'] ||
        !ad['action_flags']['mark_as_sold'] ||
        !ad['action_flags']['mark_as_inactive']) {
      return false;
    }

    // Check if ad is still valid
    final validTill = DateTime.parse(ad['valid_till']);
    if (DateTime.now().isAfter(validTill)) {
      return false;
    }

    // Check if manual boost is allowed based on package interval
    final lastFeaturedAt =
        ad['featured_at'] != null ? DateTime.parse(ad['featured_at']) : null;
    final manualBoostInterval =
        ad['manual_boost_interval'] ?? 15; // Default to silver package

    if (lastFeaturedAt == null) return true;

    final nextAllowedDate =
        lastFeaturedAt.add(Duration(days: manualBoostInterval));
    return DateTime.now().isAfter(nextAllowedDate);
  }

  Future<void> _makeFeatured(String adId) async {
    try {
      final success = await _myAdsService.makeFeatured(adId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ad featured successfully')),
        );
        // Reload ads to update the featured status
        await _loadMyAds();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to feature ad')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to feature ad: $e')),
      );
    }
  }

  // Update the _markAsSold method
  Future<void> _markAsSold(String adId) async {
    try {
      await _myAdsService.markAsSold(adId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ad marked as sold successfully')),
        );
        // Reload ads to update UI with new action flags
        _loadMyAds();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark ad as sold')),
        );
      }
    }
  }

  void _navigateToEditScreen(Map<String, dynamic> ad) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMyAdScreen(ad: ad),
      ),
    ).then((_) => _loadMyAds());
  }




  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "My Ads",
            style: TextStyle(fontSize: 30),
          ),
          bottom: TabBar(
              indicatorColor: Colors.red,
              dividerColor: Colors.yellow,
              labelColor: Colors.red,
              labelStyle: TextStyle(fontSize: 28),
              controller: tabController,
              //isScrollable: true,
              labelPadding: EdgeInsets.all(0.8), // Adjust as needed
              tabs: [
                Container(
                  margin: EdgeInsets.only(left: 8.0, right: .0),
                  child: Tab(
                    text: "ADS",
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: .0, right: 40.0),
                  child: Tab(
                    text: "FAVOURITES",
                  ),
                )
              ])),
      body: TabBarView(
        controller: tabController,
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: myAds.length,
                  itemBuilder: (context, index) {
                    final ad = myAds[index];
                    return Card(
                      margin: EdgeInsets.all(2),
                      child: Column(
                        children: [
                          ListTile(
                           leading: Opacity(
  opacity: ad['action_flags']['mark_as_sold'] ? 1.0 : 0.5,
  child: ad['assets']?.isNotEmpty == true 
      ? CachedNetworkImage(
          imageUrl: 'http://13.200.179.78/${ad['assets'][0]['url']}',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: const Color.fromARGB(255, 127, 85, 85),
                ),
             
                Text(
                  'No Image Available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
      :  Column(
        children: [
          Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: const Color.fromARGB(255, 127, 85, 85),
                    ),
                    Text(
                  'No Image Available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        ],
      ),


                                   
                              // child: Image.network(
                              //   ad['thumb'] ?? '',
                              //   width: 80,
                              //   height: 80,
                              //   fit: BoxFit.cover,
                              //   errorBuilder: (context, error, stackTrace) =>
                              //       Icon(
                              //     Icons.image_not_supported,
                              //     size: 110,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                            ),
                            title: Text(
                              ad['title'] ?? '',
                              style: TextStyle(
                                color: ad['action_flags']['mark_as_sold']
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            // title: Text(ad['title'] ?? ''),
                            subtitle: Text(
                              '₹${ad['price'] ?? ''}',
                              style: TextStyle(
                                color: ad['action_flags']['mark_as_sold']
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Active",
                                      style: TextStyle(
                                        color: ad['isActive']
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            4), // Space between text and icon
                                    Icon(
                                      ad['isActive']
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: ad['isActive']
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ],
                                ),

                                // Text("Active",
                                // style: TextStyle(
                                //   color: ad['isActive'] ? Colors.green : Colors.red,
                                // ),
                                // ),

                                IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () => _showOptionsDialog(ad),
                                ),
                              ],
                            ),
                          ),
                          ButtonBar(
                            children: [
                              if (ad['action_flags']['mark_as_sold'])
                                TextButton(
                                  onPressed: ad['action_flags']['mark_as_sold']
                                      ? () => _showSoldConfirmation(ad['_id'])
                                      : null,
                                  child: Text(
                                    'MARK AS SOLD',
                                    style: TextStyle(
                                      color: ad['action_flags']['mark_as_sold']
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              // TextButton(
                              //   onPressed: _isFeaturedEnabled(ad)
                              //       ? () => _makeFeatured(ad['_id'])
                              //       : null,
                              //   child: Text(
                              //     'FEATURED',
                              //     style: TextStyle(
                              //       color: _isFeaturedEnabled(ad)
                              //           ? Colors.blue
                              //           : Colors.red,
                              //     ),
                              //   ),
                              // ),
                              // TextButton(
                              //   onPressed: _isFeaturedEnabled(ad)
                              //       ? () => _makeFeatured(ad['_id'])
                              //       : null,
                              //   child: Text(
                              //     'FEATURED',
                              //     style: TextStyle(
                              //       color: (!ad['isActive'] ||
                              //               !ad['action_flags']['edit'] ||
                              //               !ad['action_flags']['remove'] ||
                              //               !ad['action_flags']
                              //                   ['mark_as_sold'] ||
                              //               !ad['action_flags']
                              //                   ['mark_as_inactive'])
                              //           ? Colors.red
                              //           : _isFeaturedEnabled(ad)
                              //               ? Colors.blue
                              //               : Colors.grey,
                              //     ),
                              //   ),
                              // ),
// TextButton(
//   onPressed: _isFeaturedEnabled(ad) 
//       ? () => _makeFeatured(ad['_id'])
//       : null,
//   child: Text(
//     'FEATURED',
//     style: TextStyle(
//       color: ad['action_flags']['featured']
//           ? Colors.blue
//           : !ad['isActive'] ||
//             !ad['action_flags']['edit'] ||
//             !ad['action_flags']['remove'] ||
//             !ad['action_flags']['mark_as_sold'] ||
//             !ad['action_flags']['mark_as_inactive']
//               ? Colors.red
//               : Colors.grey,
//     ),
//   ),
// ),

TextButton(
  onPressed: ad['action_flags']['featured']
      ? () async {
          try {
            final success = await _myAdsService.makeFeatured(ad['_id']);
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ad featured successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              // Refresh the ads list to show updated status
              await _loadMyAds(); // Make sure you have this method to refresh the ads
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to feature ad'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      : null,  // Disable if not featured
  child: Text(
    'FEATURED',
    style: TextStyle(
      color: ad['action_flags']['featured']
          ? Colors.blue  // Blue when featured is true
          : !ad['isActive'] ||
            !ad['action_flags']['edit'] ||
            !ad['action_flags']['remove'] ||
            !ad['action_flags']['mark_as_sold'] ||
            !ad['action_flags']['mark_as_inactive']
              ? Colors.red
              : Colors.grey,
    ),
  ),
),






                              if (!ad['isActive'] &&
                                  ad['action_flags']['publish'])
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await _myAdsService.publishAd(ad['_id']);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Ad published successfully')),
                                      );
                                      _loadMyAds(); // Reload the ads list
                                       // Add navigation here after successful publish
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Failed to publish ad')),
                                      );
                                    }
                                  },
                                  child: Text('PUBLISH'),
                                ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PackageScreen()
                                        // OfferPackageScreen(adId: ad['_id']),
                                        ),
                                  );
                                },
                                child: Text('SELL FAST'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
          FavouriteScreen(),
        ],
      ),
    );
  }
}
