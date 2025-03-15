// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/services/api_package.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class MyOrdersScreen extends StatefulWidget {
//   const MyOrdersScreen({super.key});

//   @override
//   _MyOrdersScreenState createState() => _MyOrdersScreenState();
// }

// class _MyOrdersScreenState extends State<MyOrdersScreen>
//    with TickerProviderStateMixin{
//   late TabController _tabController;
//   List<Package> activePackages = [];
//   List<Package> expiredPackages = [];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//        _fetchPackages();
//   }

//    Future<void> _fetchPackages() async {
//     // Fetch packages from your API
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? '';
//     final userId = prefs.getString('_id') ?? '';

//     try {
//       final response = await http.get(
//         Uri.parse('${ApiPackage.baseUrl}/subscriptions/$userId'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final now = DateTime.now();

//         setState(() {
//           activePackages = data['subscriptions']
//               .where((sub) => DateTime.parse(sub['end_date']).isAfter(now))
//               .map<Package>((sub) => Package(
//                     name: sub['package_name'],
//                     description: sub['description'],
//                     duration: sub['duration'],
//                     price: sub['price'].toString(),
//                     purchaseDate: DateTime.parse(sub['start_date']),
//                   ))
//               .toList();

//           expiredPackages = data['subscriptions']
//               .where((sub) => DateTime.parse(sub['end_date']).isBefore(now))
//               .map<Package>((sub) => Package(
//                     name: sub['package_name'],
//                     description: sub['description'],
//                     duration: sub['duration'],
//                     price: sub['price'].toString(),
//                     purchaseDate: DateTime.parse(sub['start_date']),
//                   ))
//               .toList();
//         });
//       }
//     } catch (e) {
//       log('Error fetching packages: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('My Orders'),
//         centerTitle: true,
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Active'),
//             Tab(text: 'Scheduled'),
//             Tab(text: 'Expired'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildPackageList(activePackages, 'active'),
//           // _buildPackageList(scheduledPackages, 'scheduled'),
//           _buildPackageList(expiredPackages, 'expired'),
//         ],
//       ),
//     );
//   }

//   Widget _buildPackageList(List<Package> packages, String type) {
//     if (packages.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.hourglass_empty,
//               size: 64,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Nothing here',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'You don\'t have any $type package',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: packages.length,
//       itemBuilder: (context, index) {
//         final package = packages[index];
//         return PackageCard(package: package);
//       },
//     );
//   }
// }

// // Package Model
// class Package {
//   final String name;
//   final String description;
//   final String duration;
//   final String price;
//   final DateTime purchaseDate;

//   Package({
//     required this.name,
//     required this.description,
//     required this.duration,
//     required this.price,
//     required this.purchaseDate,
//   });
// }

// // Package Card Widget
// class PackageCard extends StatelessWidget {
//   final Package package;

//   const PackageCard({super.key, required this.package});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               package.name,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               package.description,
//               style: TextStyle(
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Duration: ${package.duration}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   'Price: ${package.price}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Purchased on: ${_formatDate(package.purchaseDate)}',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

// Update Package class in my_orders_screen.dart

// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/services/api_package.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Package {
//   final String name;
//   final String description;
//   final String duration;
//   final String price;
//   final DateTime purchaseDate;
//   final Map<String, dynamic> subscriptionRules;
//   final String paymentId;

//   Package({
//     required this.name,
//     required this.description,
//     required this.duration,
//     required this.price,
//     required this.purchaseDate,
//     required this.subscriptionRules,
//     required this.paymentId,
//   });
// }

// // Update MyOrdersScreen
// class MyOrdersScreen extends StatefulWidget {
//   final Package? activePackage;

//   const MyOrdersScreen({
//     Key? key,
//     this.activePackage,
//   }) : super(key: key);

//   @override
//   _MyOrdersScreenState createState() => _MyOrdersScreenState();
// }

// class _MyOrdersScreenState extends State<MyOrdersScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('My Orders'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Active'),
//               Tab(text: 'Scheduled'),
//               Tab(text: 'Expired'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildActivePackageView(),
//             _buildEmptyView('scheduled'),
//             _buildEmptyView('expired'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActivePackageView() {
//     if (widget.activePackage == null) {
//       return _buildEmptyView('active');
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Card(
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.activePackage!.name,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text('Price: ₹${widget.activePackage!.price}'),
//               Text('Valid Till: ${widget.activePackage!.duration}'),
//               Text('Payment ID: ${widget.activePackage!.paymentId}'),
//               const SizedBox(height: 16),
//               const Text(
//                 'Subscription Rules:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text('Images: ${widget.activePackage!.subscriptionRules['images']}'),
//               Text('Videos: ${widget.activePackage!.subscriptionRules['video']}'),
//               Text('Posts: ${widget.activePackage!.subscriptionRules['post_count']}'),
//               Text('Boost Interval: ${widget.activePackage!.subscriptionRules['manual_boost_interval']}'),
//               Text('Valid Till: ${widget.activePackage!.subscriptionRules['valid_till']}'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyView(String type) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'No $type packages',
//             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/services/api_package.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Package> activePackages = [];
  List<Package> expiredPackages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserSubscriptions();
  }

  // Add this helper function in your _MyOrdersScreenState class
  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  Future<void> _fetchUserSubscriptions() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('http://13.200.179.78/authentication/auth_user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final now = DateTime.now();
        final validTill =
            DateTime.parse(userData['active_subscription_valid_till']);

        final package = Package(
          name: _getPackageName(userData['active_subscription']),
          description: 'Subscription Package',
          duration: userData['active_subscription_valid_till'],
          price: _getPackagePrice(userData['active_subscription']),
          purchaseDate: DateTime.now(),
          subscriptionRules: userData['active_subscription_rules'],
          isExpired: now.isAfter(validTill),
          id: userData['active_subscription'].split('::')[1],
        );

        setState(() {
          if (package.isExpired) {
            expiredPackages.add(package);
          } else {
            activePackages.add(package);
          }
        });
      }
    } catch (e) {
      log('Error fetching subscriptions: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _getPackageName(String subscription) {
    final packageId = subscription.split('::')[0];
    switch (packageId) {
      case '678f2d327f36cdf7fba13595':
        return 'Free Package';
      case '678f2d7190a04f51b9267b17':
        return 'Silver Package';
      default:
        return 'Gold Package';
    }
  }

  String _getPackagePrice(String subscription) {
    final packageId = subscription.split('::')[0];
    switch (packageId) {
      case '678f2d327f36cdf7fba13595':
        return '0';
      case '678f2d7190a04f51b9267b17':
        return '1000';
      default:
        return '1200';
    }
  }

  Future<void> _removeSubscription(String id, bool isExpired) async {
    setState(() {
      if (isExpired) {
        expiredPackages.removeWhere((package) => package.id == id);
      } else {
        activePackages.removeWhere((package) => package.id == id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Subscriptions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Scheduled'),
              Tab(text: 'Expired'),
            ],
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            indicatorColor: Color.fromARGB(255, 224, 8, 210),
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 4.0,
          ),
        ),
        body: TabBarView(
          children: [
            _buildPackageList(activePackages, false),
            _buildEmptyView('scheduled'),
            _buildPackageList(expiredPackages, true),
          ],
        ),
      ),
    );
  }

// Update the _buildPackageList method with formatted dates
  Widget _buildPackageList(List<Package> packages, bool isExpired) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (packages.isEmpty) {
      return _buildEmptyView(isExpired ? 'expired' : 'active');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            color: package.isExpired ? Colors.grey[100] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        package.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: package.isExpired ? Colors.grey : Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        onPressed: () =>
                            _removeSubscription(package.id!, isExpired),
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildInfoRow('Price', '₹${package.price}'),
                  _buildInfoRow(
                      'Valid Till', _formatDateTime(package.duration)),
                  const SizedBox(height: 16),
                  Text(
                    'Subscription Rules',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: package.isExpired ? Colors.grey : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRuleRow(
                      'Images', package.subscriptionRules['images'].toString()),
                  _buildRuleRow(
                      'Videos', package.subscriptionRules['video'].toString()),
                  _buildRuleRow('Posts',
                      package.subscriptionRules['post_count'].toString()),
                  _buildRuleRow(
                      'Boost Interval',
                      package.subscriptionRules['manual_boost_interval']
                          .toString()),
                  const Divider(),
                  Text(
                    'Valid Till: ${_formatDateTime(package.subscriptionRules['valid_till'].toString())}',
                    style: TextStyle(
                      color: package.isExpired ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Purchase Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(package.purchaseDate)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text('$label: $value'),
        ],
      ),
    );
  }

  Widget _buildEmptyView(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No $type subscriptions',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class Package {
  final String name;
  final String description;
  final String duration;
  final String price;
  final DateTime purchaseDate;
  final Map<String, dynamic> subscriptionRules;
  final bool isExpired;
  final String? id;

  Package({
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.purchaseDate,
    required this.subscriptionRules,
    required this.isExpired,
    this.id,
  });
}
