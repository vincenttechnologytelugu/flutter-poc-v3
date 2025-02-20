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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
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
                                        'Purchase Now',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // SizedBox(
                                  //   width: double.infinity,
                                  //   child: ElevatedButton(
                                  //     onPressed: package.price == 0
                                  //         ? null
                                  //         : () {
                                  //             // Your existing purchase logic here
                                  //             final snackBar = SnackBar(
                                  //               behavior:
                                  //                   SnackBarBehavior.floating,
                                  //               margin:
                                  //                   const EdgeInsets.all(16),
                                  //               duration:
                                  //                   const Duration(seconds: 20),
                                  //               content: Row(
                                  //                 children: [
                                  //                   const Icon(
                                  //                       Icons.currency_rupee,
                                  //                       color: Colors.white),
                                  //                   const SizedBox(width: 8),
                                  //                   Expanded(
                                  //                     child: Text(
                                  //                       '${package.name} added - Total: ₹${package.price}',
                                  //                       style: const TextStyle(
                                  //                           fontSize: 16),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               action: SnackBarAction(
                                  //                 label: 'View Cart',
                                  //                 onPressed: () {
                                  //                   Navigator.push(
                                  //                     context,
                                  //                     MaterialPageRoute(
                                  //                       builder: (context) =>
                                  //                           CartPackagesScreen(
                                  //                               selectedPackage:
                                  //                                   package,

                                  //                                   ),
                                  //                     ),
                                  //                   );
                                  //                 },
                                  //               ),
                                  //             );
                                  //             ScaffoldMessenger.of(context)
                                  //                 .showSnackBar(snackBar);
                                  //           },
                                  //     style:
                                  //      ElevatedButton.styleFrom(
                                  //       backgroundColor: package.price == 0
                                  //           ? Colors.grey
                                  //           : Colors.blue,
                                  //       padding: const EdgeInsets.symmetric(
                                  //           horizontal: 32, vertical: 16),
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(8),
                                  //       ),
                                  //     ),
                                  //     child: Text(
                                  //       package.price == 0
                                  //           ? 'Free Package'
                                  //           : 'Purchase Now',
                                  //       style: TextStyle(
                                  //         fontSize: 18,
                                  //         color: package.price == 0
                                  //             ? Colors.grey[600]
                                  //             : Colors.white,
                                  //       ),
                                  //     ),
                                  //   ),

                                  //   // ElevatedButton(
                                  //   //   onPressed: () {
                                  //   //     // Add purchase package logic here
                                  //   //   },
                                  //   //   style: ElevatedButton.styleFrom(
                                  //   //     backgroundColor: Colors.blue[700],
                                  //   //     // iconColor: Colors.blue[700],
                                  //   //     padding: const EdgeInsets.symmetric(vertical: 16),
                                  //   //     shape: RoundedRectangleBorder(
                                  //   //       borderRadius: BorderRadius.circular(12),
                                  //   //     ),
                                  //   //   ),
                                  //   //   child: const Text(
                                  //   //     'Purchase Package',
                                  //   //     style: TextStyle(
                                  //   //       fontSize: 18,
                                  //   //       fontWeight: FontWeight.bold,
                                  //   //       color: Colors.white,
                                  //   //     ),
                                  //   //   ),
                                  //   // ),
                                  // ),
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





// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_poc_v3/controllers/package_controller.dart';

// class OfferPackageScreen extends StatefulWidget {
//   const OfferPackageScreen({super.key});

//   @override
//   State<OfferPackageScreen> createState() => _OfferPackageScreenState();
// }

// class _OfferPackageScreenState extends State<OfferPackageScreen> {
//   final PackageController packageController = Get.put(PackageController());

//   @override
//   void initState() {
//     super.initState();
//     packageController.getPackages();
  
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Available Packages'),
//       ),
//       body: GetBuilder<PackageController>(
//         init: PackageController(),
//         builder: (controller) {
//           if (controller.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (controller.error != null) {
//             return Center(child: Text(controller.error!));
//           }

//           if (controller.packages.isEmpty) {
//             return const Center(child: Text('No packages available'));
//           }

//           return ListView.builder(
//             itemCount: controller.packages.length,
//             itemBuilder: (context, index) {
//               final package = controller.packages[index];
//               return Card(
//                 margin: const EdgeInsets.all(8.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         package.name ?? 'Unknown Package',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Price: \$${package.price?.toStringAsFixed(2)}',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(package.description ?? ''),
//                       const SizedBox(height: 8),
//                       if (package.features != null) ...[
//                         const Text('Features:'),
//                         ...package.features!.map((feature) => 
//                           Padding(
//                             padding: const EdgeInsets.only(left: 16.0),
//                             child: Text('• $feature'),
//                           ),
//                         ),
//                       ],
//                       const SizedBox(height: 8),
//                       Text('Validity: ${package.validityMonths} months'),
//                       Text('Posts: ${package.postCount}'),
//                       Text('Images: ${package.imageAttachments}'),
//                       Text('Videos: ${package.videoAttachments}'),
//                       Text('Contacts: ${package.contacts}'),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Add purchase package logic here
//                         },
//                         child: const Text('Purchase Package'),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';

// class OfferPackageScreen extends StatefulWidget {
//   const OfferPackageScreen({super.key});

//   @override
//   State<OfferPackageScreen> createState() => _OfferPackageScreenState();
// }



// class _OfferPackageScreenState extends State<OfferPackageScreen> {
//   int _selectedPackage = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Premium Plans',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.blue.shade50, Colors.white],
//             ),
//           ),
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Text(
//                   'Choose Your Perfect Plan',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade900,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Select the plan that best suits your needs',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 _buildPackageCard(
//                   title: 'Free',
//                   price: '\$0/month',
//                   imageGenerationQuota: '1 post',
//                   validity: '1 month',
//                   imageLimit: '2 images',
//                   phoneNumberVisibility: 'No',
//                   features: [],
//                   isSelected: _selectedPackage == 0,
//                   color: Colors.grey,
//                 ),
//                 SizedBox(height: 16),
//                 _buildPackageCard(
//                   title: 'Silver',
//                   price: '\$1000/month',
//                   imageGenerationQuota: '6 posts',
//                   validity: '3 months',
//                   imageLimit: '4 images',
//                   phoneNumberVisibility: '5 numbers',
//                   features: [
//                     'Featured Enabled',
//                     'Manual Boost Every 15 Days',
//                   ],
//                   isSelected: _selectedPackage == 1,
//                   color: Colors.blue,
//                 ),
//                 SizedBox(height: 16),
//                 _buildPackageCard(
//                   title: 'Gold',
//                   price: '\$1200/month',
//                   imageGenerationQuota: '12 posts',
//                   validity: '6 months',
//                   imageLimit: '4 images + 1 video',
//                   phoneNumberVisibility: '12 numbers',
//                   features: [
//                     'Featured Enabled',
//                     'Manual Boost Every 3 Days',
//                   ],
//                   isSelected: _selectedPackage == 2,
//                   color: Colors.amber,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPackageCard({
//     required String title,
//     required String price,
//     required String imageGenerationQuota,
//     required String validity,
//     required String imageLimit,
//     required String phoneNumberVisibility,
//     required List<String> features,
//     required bool isSelected,
//     required Color color,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: isSelected ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(
//             color: isSelected ? color : Colors.grey.shade300,
//             width: 2,
//           ),
//         ),
//         child: InkWell(
//           onTap: () => setState(() => _selectedPackage = 
//               title == 'Free' ? 0 : title == 'Silver' ? 1 : 2),
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: color,
//                       ),
//                     ),
//                     if (isSelected)
//                       Icon(Icons.check_circle, color: color),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   price,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Divider(height: 24),
//                 _buildFeatureItem(Icons.image, imageGenerationQuota),
//                 _buildFeatureItem(Icons.calendar_today, validity),
//                 _buildFeatureItem(Icons.photo_library, imageLimit),
//                 _buildFeatureItem(Icons.phone, phoneNumberVisibility),
//                 if (features.isNotEmpty) ...[
//                   Divider(height: 24),
//                   ...features.map((feature) => _buildFeatureItem(
//                         Icons.check_circle_outline,
//                         feature,
//                       )),
//                 ],
//                 SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => setState(() => _selectedPackage = 
//                         title == 'Free' ? 0 : title == 'Silver' ? 1 : 2),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isSelected ? color : Colors.grey.shade200,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       isSelected ? 'Current Plan' : 'Select Plan',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: isSelected ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureItem(IconData icon, String text) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.grey.shade600),
//           SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class _OfferPackageScreenState extends State<OfferPackageScreen> {
//   int _selectedPackage = 0; // 0: Free, 1: Silver, 2: Gold

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Choose Your Plan'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Your Plan, Your Way: Tailored Solutions for Unmatched Experiences',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => setState(() => _selectedPackage = 0),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         _selectedPackage == 0 ? Colors.blue : Colors.grey,
//                   ),
//                   child: Text('Free'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () => setState(() => _selectedPackage = 1),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         _selectedPackage == 1 ? Colors.blue : Colors.grey,
//                   ),
//                   child: Text('Silver'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () => setState(() => _selectedPackage = 2),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         _selectedPackage == 2 ? Colors.blue : Colors.grey,
//                   ),
//                   child: Text('Gold'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 5),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildPackageCard(
//                   title: 'Free',
//                   price: '\$0/month',
//                   imageGenerationQuota: '1 post',
//                   validity: '1 month',
//                   imageLimit: '2 images',
//                   phoneNumberVisibility: 'No',
//                   features: [],
//                   isSelected: _selectedPackage == 0,
//                 ),
//                 SizedBox(height: 5),
//                 _buildPackageCard(
//                   title: 'Silver',
//                   price: '\$9.99/month',
//                   imageGenerationQuota: '6 posts',
//                   validity: '3 months',
//                   imageLimit: '4 images',
//                   phoneNumberVisibility: '5 numbers',
//                   features: [
//                     'Featured Enabled',
//                     'Manual Boost Every 15 Days',
//                   ],
//                   isSelected: _selectedPackage == 1,
//                 ),
//                 SizedBox(height: 5),
//                 _buildPackageCard(
//                   title: 'Gold',
//                   price: '\$19.99/month',
//                   imageGenerationQuota: '12 posts',
//                   validity: '6 months',
//                   imageLimit: '4 images + 1 video',
//                   phoneNumberVisibility: '12 numbers',
//                   features: [
//                     'Featured Enabled',
//                     'Manual Boost Every 3 Days',
//                   ],
//                   isSelected: _selectedPackage == 2,
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Unleash Possibilities, Embrace Excellence - Elevate Your Journey Today!',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPackageCard({
//     required String title,
//     required String price,
//     required String imageGenerationQuota,
//     required String validity,
//     required String imageLimit,
//     required String phoneNumberVisibility,
//     required List<String> features,
//     required bool isSelected,
//   }) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               price,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             _buildFeatureRow('Image Generation Quota:', imageGenerationQuota),
//             _buildFeatureRow('Validity:', validity),
//             _buildFeatureRow('Image Limit:', imageLimit),
//             _buildFeatureRow('Phone Number Visibility:', phoneNumberVisibility),
//             if (features.isNotEmpty) SizedBox(height: 16),
//             if (features.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: features.map((feature) {
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: 4),
//                     child: Text(feature),
//                   );
//                 }).toList(),
//               ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _selectedPackage = title == 'Free'
//                       ? 0
//                       : title == 'Silver'
//                           ? 1
//                           : 2;
//                 });
//                 // Add navigation or further actions here
//                 // For example:
//                 // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isSelected ? Colors.blue : Colors.grey,
//               ),
//               child: Text(isSelected ? 'Selected' : 'Select'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureRow(String label, String value) {
//     return Row(
//       children: [
//         Text('$label '),
//         Text(value),
//       ],
//     );
//   }
// }

// class _OfferPackageScreenState extends State<OfferPackageScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text('Offer Packages'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               'Available Packages',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             // Add your package offerings here
//           ],
//         ),
//       ),
//     );
//   }
// }
