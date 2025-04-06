import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/cart_packages_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/package_controller.dart';

class OfferPackageScreen extends StatefulWidget {
  const OfferPackageScreen({super.key});

  @override
  State<OfferPackageScreen> createState() => _OfferPackageScreenState();
}

class _OfferPackageScreenState extends State<OfferPackageScreen> {
  @override
    void dispose() {
    // Cancel any subscriptions or listeners
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PackageController>(
        init: PackageController(),
        builder: (controller) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 150.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Premium Packages',
                    style: TextStyle(
                      color: Color.fromARGB(255, 33, 8, 2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue[400]!,
                          Colors.blue[800]!,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(height: 20),
                          Icon(
                            Icons.workspace_premium,
                            size: 50,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Choose Your Perfect Plan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Select the package that best suits your needs',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (controller.error != null)
                SliverFillRemaining(
                  child: Center(child: Text(controller.error!)),
                )
              else if (controller.packages.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text('No packages available')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final package = controller.packages[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(51),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            package.name ?? 'Unknown Package',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$${package.price?.toStringAsFixed(2)}/month',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withAlpha(51),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.blue[700],
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    package.description ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (package.features != null) ...[
                                    const Text(
                                      'Features',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...package.features!
                                        .map((feature) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green[600],
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    feature,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            )),
                                  ],
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildDetailRow(
                                          'Validity',
                                          '${package.validityMonths} months',
                                          Icons.calendar_today,
                                        ),
                                        _buildDetailRow(
                                          'Posts',
                                          '${package.postCount}',
                                          Icons.post_add,
                                        ),
                                        _buildDetailRow(
                                          'Images',
                                          '${package.imageAttachments}',
                                          Icons.image,
                                        ),
                                        _buildDetailRow(
                                          'Videos',
                                          '${package.videoAttachments}',
                                          Icons.videocam,
                                        ),
                                        _buildDetailRow(
                                          'Contacts',
                                          '${package.contacts}',
                                          Icons.contacts,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Your existing purchase logic here
                                        final snackBar = SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.all(16),
                                          duration: const Duration(seconds: 20),
                                          content: Row(
                                            children: [
                                              const Icon(Icons.currency_rupee,
                                                  color: Colors.white),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '${package.name} added - Total: ₹${package.price}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                          action: SnackBarAction(
                                            label: 'View Cart',
                                            onPressed: () {
                                                final currentContext = context;
                                              Navigator.push(
                                                currentContext,
                                                MaterialPageRoute(
                                                  builder: (Context) =>
                                                      CartPackagesScreen(
                                                    selectedPackage: package,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Buy Now',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                 
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: controller.packages.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}




