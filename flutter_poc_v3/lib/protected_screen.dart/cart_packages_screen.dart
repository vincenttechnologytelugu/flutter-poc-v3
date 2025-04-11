import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/public_screen.dart/razorpayment_gateway.dart';
import 'package:get/get.dart';
// import 'your_package_model_path.dart';

class CartPackagesScreen extends StatefulWidget {
  final ProductModel selectedPackage;



  const CartPackagesScreen(
      {super.key, required this.selectedPackage, });

  @override
  State<CartPackagesScreen> createState() => _CartPackagesScreenState();
}

class _CartPackagesScreenState extends State<CartPackagesScreen> {

  
void _handleProceedToPayment() {
    String packageId;
    double amount = widget.selectedPackage.price?.toDouble() ?? 0.0;
    
    
    // Determine package ID based on amount
    if (amount == 0) {
      packageId = '678f2d327f36cdf7fba13595';
    } else if (amount == 1000) {  // Changed from 499 to 1000 as per your original prices
      packageId = '678f2d7190a04f51b9267b17';
    } else if (amount == 1200) {  // Changed from 999 to 1200 as per your original prices
      packageId = '678f2e2f9ccc3e56abbd8c65';
    } else {
      // Handle other cases or set a default value
      packageId = 'default_package_id';
    }
    
  log('Selected Package Details:');
  log('Amount: $amount');
  log('PackageId: $packageId');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RazorpaymentGateway(
          amount: amount,
          packageId: packageId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Package Details Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectedPackage.name ?? '',
                            // widget.selectedPackage.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.selectedPackage.description ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Package Features
                          if (widget.selectedPackage.features != null) ...[
                            const Text(
                              'Features:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...widget.selectedPackage.features!.map(
                              (feature) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(feature),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        

            Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(51),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee),
                        Text(
                          '${widget.selectedPackage.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleProceedToPayment, // Updated here
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Pay',
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
        ],
      ),
    );
  }
}
