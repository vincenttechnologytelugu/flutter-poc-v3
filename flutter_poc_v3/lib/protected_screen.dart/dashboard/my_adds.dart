import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_poc_v3/protected_screen.dart/dashboard/sell_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/deactivate_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/edit_my_ad_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/favourite_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/offer_package_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/package_screen.dart';
import 'package:flutter_poc_v3/services/my_ads_sevice.dart';

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
              leading: Icon(Icons.edit,
               color: ad['action_flags']['edit'] ? Colors.blue : Colors.grey,
              
              ),
              title: Text('Edit',
              style: TextStyle(
                  color: ad['action_flags']['edit'] ? Colors.black : Colors.grey,
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
              leading: Icon(Icons.delete_outline,
               color: ad['action_flags']['remove'] ? Colors.red : Colors.grey,
              ),
              title: Text('Remove',
               style: TextStyle(
                  color: ad['action_flags']['remove'] ? Colors.black : Colors.grey,
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

  // Future<void> _markAsSold(String adId) async {
  //   try {
  //     final result = await _myAdsService.markAsSold(adId);
  //     if (result['data'] != null) {
  //       await _loadMyAds();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Ad marked as sold successfully')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to mark ad as sold: $e')),
  //     );
  //   }
  // }

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
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Opacity(
                                opacity: ad['action_flags']['mark_as_sold'] ? 1.0 : 0.5, // Dim thumb if sold
                              child: Image.network(
                                ad['thumb'] ?? '',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.image_not_supported),
                              ),
                            ),
                              title: Text(
              ad['title'] ?? '',
              style: TextStyle(
                color: ad['action_flags']['mark_as_sold'] ? Colors.black : Colors.grey,
              ),
            ),
                            // title: Text(ad['title'] ?? ''),
                            subtitle: Text('\$${ad['price'] ?? ''
                           
                            
                            }',
                             style: TextStyle(
                              color: ad['action_flags']['mark_as_sold'] ? Colors.black : Colors.grey,
                            ),
                            
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color:
                                      ad['isActive'] ? Colors.red : Colors.grey,
                                ),
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
                                //   onPressed: () => _showSoldConfirmation(ad['_id']),
                                //   child: Text('MARK AS SOLD'),
                                // ),
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
      // body: TabBarView(controller: tabController, children: [

      //   SingleChildScrollView(
      //     padding: const EdgeInsets.all(16),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         // Promotion Card
      //         Container(
      //           padding: const EdgeInsets.all(20),
      //           decoration: BoxDecoration(
      //             color: Theme.of(context).colorScheme.primaryContainer,
      //             borderRadius: BorderRadius.circular(16),
      //           ),
      //           child: Column(
      //             children: [
      //               Text(
      //                 "Want to reach more buyers?",
      //                 style:
      //                     Theme.of(context).textTheme.headlineSmall?.copyWith(
      //                           fontWeight: FontWeight.bold,
      //                           color: Theme.of(context)
      //                               .colorScheme
      //                               .onPrimaryContainer,
      //                         ),
      //               ),
      //               const SizedBox(height: 8),
      //               Text(
      //                 "Post more ads for less. Affordable packages to boost your sales.",
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                   color: Theme.of(context)
      //                       .colorScheme
      //                       .onPrimaryContainer
      //                         .withAlpha((0.9 * 255).round()),
      //                 ),
      //               ),
      //               const SizedBox(height: 16),
      //               ElevatedButton(
      //                 onPressed: () {
      //                   Navigator.of(context).push(
      //                     MaterialPageRoute(
      //                         builder: (context) => const PackageScreen()),
      //                   );
      //                 },
      //                 style: FilledButton.styleFrom(
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(20),
      //                   ),
      //                 ),
      //                 child: Text(
      //                   "Check out our packages",
      //                   style: TextStyle(
      //                       color: Colors.red,
      //                       fontWeight: FontWeight.w900,
      //                       fontSize: 20),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),

      //         const SizedBox(height: 32),

      //         // Empty State
      //         Column(
      //           children: [
      //             Stack(
      //               children: [

      //                 Image.asset(
      //                   "assets/images/alltypes.jpg",
      //                   width: double.infinity,
      //                   height: 200,
      //                   fit: BoxFit.cover,
      //                   errorBuilder: (context, error, stackTrace) {
      //                     log(
      //                         'Error details: $error'); // This will print the error in debug console
      //                     return Container(
      //                       width: double.infinity,
      //                       height: 200,
      //                       color: Colors.grey[200],
      //                       child: const Center(
      //                         child: Column(
      //                           mainAxisSize: MainAxisSize.min,
      //                           children: [
      //                             Icon(Icons.broken_image, size: 50),
      //                             SizedBox(height: 8),
      //                             Text('Image not found: alltypes.jpg'),
      //                           ],
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               ],
      //             ),

      //             // Icon(
      //             //   Icons.inventory_2_outlined,
      //             //   size: 64,
      //             //   color: Theme.of(context).colorScheme.outline,
      //             // ),
      //             const SizedBox(height: 16),
      //             Text(
      //               "No listings yet?",
      //               style: Theme.of(context).textTheme.titleLarge,
      //             ),
      //             const SizedBox(height: 8),
      //             Text(
      //               "Turn your unused items into cash!",
      //               style: TextStyle(
      //                 color: Theme.of(context).colorScheme.outline,
      //               ),
      //             ),
      //             const SizedBox(height: 24),
      //             FilledButton(
      //               onPressed: () {
      //                 Navigator.of(context).push(
      //                   MaterialPageRoute(
      //                       builder: (context) => const SellScreen()),
      //                 );
      //               },
      //               style: FilledButton.styleFrom(
      //                 padding: const EdgeInsets.symmetric(
      //                     vertical: 16, horizontal: 32),
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(24),
      //                 ),
      //               ),
      //               child: const Row(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Icon(Icons.add),
      //                   SizedBox(width: 8),
      //                   Text("Post a New Ad",
      //                       style: TextStyle(
      //                           fontSize: 16,
      //                           fontWeight: FontWeight.w900,
      //                           color: Colors.white70)),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      //   // Center(child: Text('My Adds')), // First tab content
      //   FavouriteScreen(),
      //   // Center(child: Text('Content 2')), // Second tab content
      // ]),
    );
  }
}
