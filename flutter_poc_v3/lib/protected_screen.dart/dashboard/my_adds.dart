// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:flutter_poc_v3/protected_screen.dart/deactivate_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/edit_my_ad_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/favourite_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';

import 'package:flutter_poc_v3/protected_screen.dart/package_screen.dart';
import 'package:flutter_poc_v3/services/my_ads_sevice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math'; // Import dart:math for sin function

class MyAdds extends StatefulWidget {
  final bool? showDialogAfterSubmit; // Add this parameter

  const MyAdds({super.key, this.showDialogAfterSubmit});

  @override
  State<MyAdds> createState() => _MyAddsState();
}

class _MyAddsState extends State<MyAdds> with TickerProviderStateMixin {
  late TabController tabController;
  final MyAdsService _myAdsService = MyAdsService();
  List<dynamic> myAds = [];
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Show dialog only if coming from upload screen
    if (widget.showDialogAfterSubmit == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInitialDialog(context);
      });
    }
    _loadMyAds();
  }

  @override
  void dispose() {
    tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showInitialDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Icon(
                Icons.notification_important_rounded,
                color: Colors.blue[600],
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                'Action Required',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          content: Text(
            'You Need to Publish your ad click on Publish button or Edit your ad click on Edit button',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadMyAds() async {
    try {
      final ads = await _myAdsService.getMyAds(context);
      setState(() {
        myAds = ads;
        isLoading = false;
      });
    } catch (e) {
      // setState(() => isLoading = false);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to load ads: $e')),
      // );
      setState(() => isLoading = false);
      if (mounted) {
        // Add this check
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to load ads: $e')),
        // );
      }
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
      final success = await _myAdsService.removeAd(context, adId);
      if (success) {
        setState(() {
          myAds.removeWhere((ad) => ad['_id'] == adId);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ad removed successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove ad: $e')),
        );
      }
    }
  }

  Future<void> _deactivateAd(String adId) async {
    try {
      final updatedAd = await _myAdsService.markAsInactive(context, adId);

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
      dev.log("Deactivate Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to deactivate ad')),
        );
      }
    }
  }

  bool isFeaturedEnabled(Map<String, dynamic> ad) {
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

  Future<void> makeFeatured(String adId) async {
    try {
      final success = await _myAdsService.makeFeatured(context, adId);
      if (!mounted) return; // Add this check after async call
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to feature ad: $e')),
      );
    }
  }

  // Update the _markAsSold method
  Future<void> _markAsSold(String adId) async {
    // Store the ScaffoldMessenger context
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _myAdsService.markAsSold(context, adId);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Ad marked as sold successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        // Reload ads to update UI with new action flags
        _loadMyAds();
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Failed to mark ad as sold'),
            backgroundColor: Colors.red,
          ),
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
        backgroundColor: Colors.transparent,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2C5364), Color(0xFF203A43)], // Modern gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "My Ads",
          style: GoogleFonts.tenorSans(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
            ),
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Rounded tab indicator
            color: Colors.white, // Highlight color
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          overlayColor: MaterialStateProperty.resolveWith(
              (states) => Colors.white.withOpacity(0.1)), // Subtle hover effect
          tabs: [
            Tab(text: "PROMOTIONS"),
            Tab(text: "FAVOURITES"),
          ],
        ),
      ),

      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 172, 179, 181),
      //     title: Text(
      //       "My Ads",
      //       style: GoogleFonts.tenorSans(
      //         textStyle: TextStyle(
      //             color: const Color.fromARGB(255, 4, 74, 50),
      //             letterSpacing: .5),
      //         fontWeight: FontWeight.bold,
      //         fontStyle: FontStyle.normal,
      //       ),
      //     ),
      //     bottom: TabBar(
      //         indicatorColor: Colors.red,
      //         dividerColor: Colors.yellow,
      //         labelColor: Colors.red,
      //         labelStyle: TextStyle(fontSize: 28),
      //         controller: tabController,
      //         //isScrollable: true,
      //         labelPadding: EdgeInsets.all(0.8), // Adjust as needed
      //         tabs: [
      //           Container(
      //             margin: EdgeInsets.only(left: 8.0, right: .0),
      //             child: Tab(
      //               child: Text(
      //                 "ADS",
      //                 style: GoogleFonts.montserrat(
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.w600,
      //                   letterSpacing: 1.0,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             margin: EdgeInsets.only(left: .0, right: 40.0),
      //             child: Tab(
      //               child: Text(
      //                 "FAVOURITES",
      //                 style: GoogleFonts.montserrat(
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.w600,
      //                   letterSpacing: 1.0,
      //                 ),
      //               ),
      //             ),
      //           )
      //         ])),
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
                      elevation: 5,
                      color: const Color.fromARGB(255, 175, 180, 179)
                          .withOpacity(0.95),
                      margin: EdgeInsets.all(2),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Opacity(
                              opacity: ad['action_flags']['mark_as_sold']
                                  ? 1.0
                                  : 0.5,
                              child: ad['assets']?.isNotEmpty == true
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          'http://13.200.179.78/${ad['assets'][0]['url']}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_outlined,
                                              size: 40,
                                              color: const Color.fromARGB(
                                                  255, 127, 85, 85),
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
                                  : Column(
                                      children: [
                                        Icon(
                                          Icons.image_outlined,
                                          size: 40,
                                          color: const Color.fromARGB(
                                              255, 127, 85, 85),
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
                          OverflowBar(
                            spacing: 8,
                            alignment: MainAxisAlignment.spaceEvenly,
                            // alignment: MainAxisAlignment.end, // Align buttons to the end (right)
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
                                          ? const Color.fromARGB(
                                              255, 247, 251, 2)
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              TextButton(
                                onPressed: ad['action_flags']['featured']
                                    ? () async {
                                        // Store the ScaffoldMessenger context
                                        final scaffoldMessenger =
                                            ScaffoldMessenger.of(context);
                                        try {
                                          final success = await _myAdsService
                                              .makeFeatured(context, ad['_id']);

                                          if (success) {
                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Ad featured successfully'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            // Refresh the ads list to show updated status
                                            await _loadMyAds(); // Make sure you have this method to refresh the ads
                                          } else {
                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Failed to feature ad'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            scaffoldMessenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error: ${e.toString()}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    : null, // Disable if not featured
                                child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color.fromARGB(255, 57, 113, 1),
                                          const Color.fromARGB(
                                              255, 223, 210, 227)
                                        ],
                                      ),
                                      border: Border.all(
                                        color: ad['action_flags']['featured']
                                            ? const Color.fromARGB(
                                                255, 23, 0, 71)
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),

                                    // Add this to your State class

                                    // Replace the existing Text widget with this:
                                    child: Stack(
                                      children: [
                                        Text(
                                          'FEATURED',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ad['action_flags']
                                                    ['featured']
                                                ? const Color.fromARGB(
                                                    255, 30, 1, 66)
                                                : !ad['isActive'] ||
                                                        !ad['action_flags']
                                                            ['edit'] ||
                                                        !ad['action_flags']
                                                            ['remove'] ||
                                                        !ad['action_flags']
                                                            ['mark_as_sold'] ||
                                                        !ad['action_flags']
                                                            ['mark_as_inactive']
                                                    ? Colors.red
                                                    : const Color.fromARGB(
                                                        255, 252, 251, 251),
                                          ),
                                        ),
                                        if (ad['action_flags'][
                                            'featured']) // Only show animation when featured is true
                                          // AnimatedBuilder(
                                          //   animation: _animation,
                                          //   builder: (context, child) {
                                          //     return Positioned(
                                          //       left: (_animation.value + 1) * 50,
                                          //       top: 2,
                                          //       child: Container(
                                          //         width: 6,
                                          //         height: 6,
                                          //         decoration: BoxDecoration(
                                          //           shape: BoxShape.circle,
                                          //           color: const Color.fromARGB(255, 3, 77, 25).withOpacity(0.6),
                                          //           boxShadow: [
                                          //             BoxShadow(
                                          //               color: const Color.fromARGB(255, 3, 77, 25).withOpacity(0.3),
                                          //               blurRadius: 4,
                                          //               spreadRadius: 1,
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     );
                                          //   },
                                          // ),

                                          AnimatedBuilder(
                                            animation: _animation,
                                            builder: (context, child) {
                                              return Positioned(
                                                left:
                                                    (_animation.value + 1) * 80,
                                                top: 2,
                                                child: Transform.scale(
                                                  scale: 0.9 +
                                                      (_animation.value * 0.9)
                                                          .abs(), // Pulsing effect
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: RadialGradient(
                                                        colors: [
                                                          const Color.fromARGB(
                                                                  255,
                                                                  15,
                                                                  255,
                                                                  3)
                                                              .withOpacity(0.9),
                                                          const Color.fromARGB(
                                                                  255,
                                                                  32,
                                                                  251,
                                                                  3)
                                                              .withOpacity(0.6),
                                                        ],
                                                        center:
                                                            Alignment.topLeft,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(
                                                                  0xFF2ECC71)
                                                              .withOpacity(0.4),
                                                          blurRadius: 8,
                                                          spreadRadius: 2,
                                                        ),
                                                        BoxShadow(
                                                          color: const Color(
                                                                  0xFF27AE60)
                                                              .withOpacity(0.2),
                                                          blurRadius: 12,
                                                          spreadRadius: -2,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          top: 2,
                                                          left: 2,
                                                          child: Container(
                                                            width: 4,
                                                            height: 4,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.8),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                      ],
                                    )

                                    // child: Text(
                                    //   'FEATURED',
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //     color: ad['action_flags']['featured']
                                    //         ? const Color.fromARGB(255, 3, 77, 25) // Blue when featured is true
                                    //         : !ad['isActive'] ||
                                    //                 !ad['action_flags']['edit'] ||
                                    //                 !ad['action_flags']['remove'] ||
                                    //                 !ad['action_flags']
                                    //                     ['mark_as_sold'] ||
                                    //                 !ad['action_flags']
                                    //                     ['mark_as_inactive']
                                    //             ? Colors.red
                                    //             : Colors.grey,
                                    //   ),
                                    // ),
                                    ),
                              ),
                              if (!ad['isActive'] &&
                                  ad['action_flags']['publish'])
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await _myAdsService.publishAd(
                                          context, ad['_id']);
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
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
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
                                child: Text(
                                  'SELL FAST',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 254, 4, 137)),
                                ),
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
