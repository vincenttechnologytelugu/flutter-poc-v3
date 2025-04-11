

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/sell_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/offer_package_screen.dart';
import 'package:intl/intl.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RazorpaymentGateway extends StatefulWidget {
  final double amount;
  final String packageId;
  final bool isFreePlan;
  final bool isSilverPlan;

  const RazorpaymentGateway({
    super.key,
    required this.amount,
    required this.packageId,
    this.isFreePlan = false,
    this.isSilverPlan = false,
  });

  @override
  State<RazorpaymentGateway> createState() => _RazorpaymentGatewayState();
}

class _RazorpaymentGatewayState extends State<RazorpaymentGateway> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Automatically trigger payment when screen opens
   WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (widget.amount == 0) {
      bool canProceed = await _checkFreePackageStatus();
      if (canProceed) {
        _handlePayment();
      }
    } else {
      _handlePayment();
    }
  });
  }

// Add this function to check free package status
Future<bool> _checkFreePackageStatus() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    final userData = json.decode(userDataString ?? '{}');
    
    if (userData['free_subscription_freeze_till'] != null) {
      final freezeDate = DateTime.parse(userData['free_subscription_freeze_till']);
      final now = DateTime.now();
      
      if (now.isBefore(freezeDate)) {
        final formattedDate = DateFormat('dd MMM yyyy').format(freezeDate);
        await _showFreePackageRestrictionDialog(
          'You have already used your free package. You can subscribe to free package again after $formattedDate.',
        );
        return false;
      }
    }
    return true;
  } catch (e) {
    log('Error checking free package status: $e');
    return false;
  }
}




// Add free package validation function
  Future<void> _validateFreePackage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userDataString = prefs.getString('user_data');
      final userData = json.decode(userDataString ?? '{}');
      final userId = userData['_id'];

      final response = await http.post(
        Uri.parse('http://13.200.179.78/packages/validate-free-subscription'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'package_id': widget.packageId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        _showFreePackageRestrictionDialog(
          errorData['message'] ?? 'You can only subscribe to free package once per month.',
        );
      } else {
        _handlePayment(); // Proceed with payment if validation passes
      }
    } catch (e) {
      log('Error validating free package: $e');
      _showFreePackageRestrictionDialog(
        'Error validating free package. Please try again later.',
      );
    }
  }

// Add dialog to show free package restriction
 Future<void> _showFreePackageRestrictionDialog(String message) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Free Package Restricted',
          style: TextStyle(
            color: Colors.red[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OfferPackageScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text('View Other Packages', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}









  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }



  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString =
          prefs.getString('user_data'); // Get stored JSON string
      final token = prefs.getString('token');

      // Parse user data JSON
      final userData = json.decode(userDataString ?? '{}');
      final userId = userData['_id']; // Extract _id from user data

      // Debug logs
      log('Payment Success Details:');
      log('UserData: $userDataString');
      log('UserId: $userId');
      log('PackageId: ${widget.packageId}');
      log('PaymentId: ${response.paymentId}');

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found');
      }


       // Check if it's a free package
    if (widget.amount == 0) {
      bool canProceed = await _checkFreePackageStatus();
      if (!canProceed) {
        return;
      }
    }

      final requestBody = {
        'package_id': widget.packageId,
        'user_id': userId,
        'payment_reference': response.paymentId ?? '',
        'payment_status': 'success'
      };

      log('Request Body: ${json.encode(requestBody)}'); // Debug log

      final apiResponse = await http.post(
        Uri.parse('http://13.200.179.78/packages/subscribe'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      log('API Response Status: ${apiResponse.statusCode}');
      log('API Response Body: ${apiResponse.body}');

        if (apiResponse.statusCode == 400) {
      final errorData = json.decode(apiResponse.body);
      if (errorData['error']?.contains('not allowed to subscribe for free package')) {
        await _showFreePackageRestrictionDialog(errorData['message']);
        return;
      }
    }
      

      if (apiResponse.statusCode == 200) {
     
 final responseData = json.decode(apiResponse.body);
      
      // Update SharedPreferences with new subscription
      if (userDataString != null) {
        Map<String, dynamic> userData = json.decode(userDataString);

           // Update free package freeze date if it's a free package
        if (widget.amount == 0 && responseData['free_subscription_freeze_till'] != null) {
         userData['free_subscription_freeze_till'] = responseData['free_subscription_freeze_till'];
        }


        // Set package rules based on package type
        Map<String, dynamic> packageRules = {};
        
        // Determine package rules based on packageId
        if (widget.packageId == '678f2d327f36cdf7fba13595') { // Free package
          packageRules = {
            'images': 2,
            'video': 0,
            'valid_till': responseData['valid_till'],
            'manual_boost_interval': 1,
            'post_count': 1
          };
        } else if (widget.packageId == '678f2d7190a04f51b9267b17') { // Silver package
          packageRules = {
            'images': 4,
            'video': 0,
            'valid_till': responseData['valid_till'],
            'manual_boost_interval': 15,
            'post_count': 6
          };
        } else if (widget.packageId == '678f2e2f9ccc3e56abbd8c65') { // Gold package
          packageRules = {
            'images': 4,
            'video': 1,
            'valid_till': responseData['valid_till'],
            'manual_boost_interval': 3,
            'post_count': 12
          };
        }

        // Update user data
        userData['active_subscription'] = responseData['subscription_plan'] ?? widget.packageId;
        userData['active_subscription_rules'] = packageRules;
        userData['active_subscription_valid_till'] = responseData['valid_till'];

        // Save to SharedPreferences
        await prefs.setString('user_data', json.encode(userData));
        await prefs.reload();

        log('Updated subscription data: ${json.encode(userData)}');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subscription updated successfully!')),
      );
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SellScreen()),
        (route) => false,
      );
    }
  } catch (e) {
    log('Error saving subscription: $e');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}



  void _handlePaymentError(PaymentFailureResponse response) {
    log('Error: ${response.code} - ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('External Wallet: ${response.walletName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

// Update the payment initialization
  void _handlePayment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      final userData = json.decode(userDataString ?? '{}');
      final userId = userData['_id'];
      log('User ID: $userId');

      if (userId == null || userId.isEmpty) {
        throw Exception('User not logged in');
      }

      var options = {
        'key': 'rzp_test_SHO15jj5fCGbi2',
        'amount': (widget.amount * 100).toInt(),
        'name': 'Onlinefreeadds.in',
        'description': 'Package Subscription',
        'prefill': {
          'contact': '9618081713',
          'email': userData['email'] ?? 'test@razorpay.com'
        },
        'notes': {
          'package_id': widget.packageId,
          'user_id': userId,
        }
      };

      _razorpay.open(options);
    } catch (e) {
      log('Error initiating payment: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
// Add this method to verify user is logged in

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Amount to pay: ₹${widget.amount}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // onPressed: _handlePayment,
               onPressed: widget.amount == 0 ? _validateFreePackage : _handlePayment,
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
