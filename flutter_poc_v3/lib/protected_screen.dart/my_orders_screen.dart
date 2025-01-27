import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy data - replace with your actual data
  final List<Package> activePackages = [
    // Package(
    //   name: 'Basic Package',
    //   description: 'This is a basic package',
    //   duration: '1 month',
    //   price: '\$10',
    //   purchaseDate: DateTime.now().subtract(const Duration(days: 30)),
    // ),
    // Package(
    //   name: 'Premium Package',
    //   description: 'This is a premium package',
    //   duration: '6 months',
    //   price: '\$50',
    //   purchaseDate: DateTime.now().subtract(const Duration(days: 180)),
    // ),
  ];
  final List<Package> scheduledPackages = [
    // Package(
    //   name: 'Gold Package',
    //   description: 'This is a gold package',
    //   duration: '1 year',
    //   price: '\$100',
    //   purchaseDate: DateTime.now().add(const Duration(days: 365)),
    // ),
  ];
  final List<Package> expiredPackages = [
    // Package(
    //   name: 'Platinum Package',
    //   description: 'This is a platinum package',
    //   duration: '2 years',
    //   price: '\$200',
    //   purchaseDate: DateTime.now().subtract(const Duration(days: 730)),
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Orders'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Scheduled'),
            Tab(text: 'Expired'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPackageList(activePackages, 'active'),
          _buildPackageList(scheduledPackages, 'scheduled'),
          _buildPackageList(expiredPackages, 'expired'),
        ],
      ),
    );
  }

  Widget _buildPackageList(List<Package> packages, String type) {
    if (packages.isEmpty) {
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
              'Nothing here',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any $type package',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        return PackageCard(package: package);
      },
    );
  }
}

// Package Model
class Package {
  final String name;
  final String description;
  final String duration;
  final String price;
  final DateTime purchaseDate;

  Package({
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.purchaseDate,
  });
}

// Package Card Widget
class PackageCard extends StatelessWidget {
  final Package package;

  const PackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              package.description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration: ${package.duration}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Price: ${package.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Purchased on: ${_formatDate(package.purchaseDate)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
