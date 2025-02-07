import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/sell_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/favourite_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/package_screen.dart';

class MyAdds extends StatefulWidget {
  const MyAdds({super.key});

  @override
  State<MyAdds> createState() => _MyAddsState();
}

class _MyAddsState extends State<MyAdds> with SingleTickerProviderStateMixin {
  late TabController tabController;
 
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  
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
      body: TabBarView(controller: tabController, children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Promotion Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      "Want to reach more buyers?",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Post more ads for less. Affordable packages to boost your sales.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer
                            .withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const PackageScreen()),
                        );
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Check out our packages",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w900,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            

              // Empty State
              Column(
                children: [
                  Stack(
                    children: [
                     
                      Image.asset(
                        "assets/images/alltypes.jpg",
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          log(
                              'Error details: $error'); // This will print the error in debug console
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.broken_image, size: 50),
                                  SizedBox(height: 8),
                                  Text('Image not found: alltypes.jpg'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Icon(
                  //   Icons.inventory_2_outlined,
                  //   size: 64,
                  //   color: Theme.of(context).colorScheme.outline,
                  // ),
                  const SizedBox(height: 16),
                  Text(
                    "No listings yet?",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Turn your unused items into cash!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SellScreen()),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text("Post a New Ad",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Center(child: Text('My Adds')), // First tab content
        FavouriteScreen(),
        // Center(child: Text('Content 2')), // Second tab content
      ]),
    );
    // SingleChildScrollView(
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Text(
    //           'My Ads',
    //           style: TextStyle(
    //             fontSize: 24,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         const SizedBox(height: 16),
    //         // Add your ads list here
    //       ],
    //     ),
    //   ),
    // );
  }
}
