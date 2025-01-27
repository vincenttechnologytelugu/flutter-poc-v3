import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/cart_screen.dart';

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
        Center(child: Text('My Adds')), // First tab content
        CartScreen(),
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
