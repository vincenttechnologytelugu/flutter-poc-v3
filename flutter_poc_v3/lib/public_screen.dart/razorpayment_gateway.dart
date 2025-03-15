// // import 'package:flutter/material.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';

// // class RazorPaymentGateway extends StatefulWidget {

// //   final double price; // Amount to be paid

// //   const RazorPaymentGateway({super.key, required this.price});

// //   @override
// //   State<RazorPaymentGateway> createState() => _RazorPaymentGatewayState();
// // }

// // class _RazorPaymentGatewayState extends State<RazorPaymentGateway> {
// //   late Razorpay _razorpay;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

// //     // Start payment when widget is initialized
// //     _startPayment();
// //   }

// //   void _startPayment() {
// //     var options = {
// //       'key': 'YOUR_RAZORPAY_KEY', // Replace with your Razorpay key
// //       'amount': widget.price * 100, // Amount in smallest currency unit (paise for INR)
// //       'name': 'Your Company Name',
// //       'description': 'Payment for your order',
// //       'prefill': {
// //         'contact': '1234567890', // User's phone number
// //         'email': 'test@example.com' // User's email
// //       },
// //       'external': {
// //         'wallets': ['paytm']
// //       }
// //     };

// //     try {
// //       _razorpay.open(options);
// //     } catch (e) {
// //       debugPrint('Error: $e');
// //     }
// //   }

// //   void _handlePaymentSuccess(PaymentSuccessResponse response) {
// //     // Payment successful
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
// //     );
// //     Navigator.pop(context, true); // Return success
// //   }

// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     // Payment failed
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text('Payment Failed: ${response.message}')),
// //     );
// //     Navigator.pop(context, false); // Return failure
// //   }

// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text('External Wallet Selected: ${response.walletName}')),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _razorpay.clear();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Payment'),
// //       ),
// //       body: const Center(
// //         child: CircularProgressIndicator(),
// //       ),
// //     );
// //   }
// // }

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/package_category_screen.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/package_screen.dart';
// import 'package:flutter_poc_v3/services/api_package.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// //import 'package:shopping_api_classes/screens/products_screen.dart';
// class RazorpaymentGateway extends StatefulWidget {
//   final double price;
//   const RazorpaymentGateway({super.key, required this.price});

//   @override
//   State<RazorpaymentGateway> createState() => _RazorpaymentGatewayState();
// }

// class _RazorpaymentGatewayState extends State<RazorpaymentGateway> {
//   final ApiPackage _apiPackage = ApiPackage();
//   late SharedPreferences _prefs;
//   TextEditingController textEditingController = TextEditingController();
//   final Razorpay _razorpay = Razorpay();
//   @override
//   void initState() {
//     _initializePrefs();
//     textEditingController.text = widget.price.toString();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     super.initState();
//   }

//   Future<void> _initializePrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   String _getPackageId() {
//     // Return package ID based on price
//     switch (widget.price) {
//       case 0: // Free package
//         return '678f2d327f36cdf7fba13595';
//       case 1000: // Silver package
//         return '678f2d7190a04f51b9267b17';
//       case 1200: // Gold package
//         return '678f2e2f9ccc3e56abbd8c65';
//       default:
//         return '';
//     }
//   }

//   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     final String paymentReference = response.paymentId ?? '';
//     final String userId = _prefs.getString('user_id') ?? '';
//     final String token = _prefs.getString('token') ?? '';
//     final String packageId = _getPackageId();

//     // Save payment reference
//     await _prefs.setString('payment_reference', paymentReference);

//     // Call API to save subscription
//     final bool success = await _apiPackage.savePackageSubscription(
//       packageId: packageId,
//       userId: userId,
//       paymentReference: paymentReference,
//       paymentStatus: 'success',
//       token: token,
//     );

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
//       );

//       // Navigate to home screen and refresh orders
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//         (route) => false,
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error saving subscription')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 140, 194, 233),
//       appBar: AppBar(
//         title: Text("Razorpay Payment Gateway"),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 margin: EdgeInsets.only(left: 70, right: 70),
//                 child: TextField(
//                   readOnly: true,
//                   controller: textEditingController,
//                   decoration: InputDecoration(
//                     hintText: "Enter amount",
//                     labelText: "Amount",
//                     fillColor: Colors.black,
//                     focusColor: const Color.fromARGB(255, 5, 3, 13),
//                     hoverColor: const Color.fromARGB(255, 229, 11, 11),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide(color: Colors.black),
//                       gapPadding: 10.0,
//                     ),
//                     labelStyle:
//                         TextStyle(color: const Color.fromARGB(255, 13, 4, 15)),
//                     hintStyle: TextStyle(color: Colors.black),
//                   ),
//                   keyboardType: TextInputType.number,

//                   maxLength: 10,
//                   style: TextStyle(color: Colors.black),

//                   // onChanged: (value) {
//                   //   setState(() {});
//                   // },
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                   onPressed: () {
//                     var options = {
//                       'key': 'rzp_test_SHO15jj5fCGbi2',
//                       // 'amount': int.parse(textEditingController.text) * 100,
//                       'amount': (double.parse(textEditingController.text) * 100)
//                           .toInt(),
//                       'name': 'Onlinefreeadds.in Corp.',
//                       'description': 'Selected Package',
//                       'prefill': {
//                         'contact': '8888888888',
//                         'email': 'test@razorpay.com'
//                       },
//                       'notes': {
//                         'package_id': _getPackageId(),
//                         'user_id': _prefs.getString('user_id') ?? '',
//                       }
//                     };

//                     try {
//                       _razorpay.open(options);
//                     } catch (e) {
//                       debugPrint('Error: $e');
//                     }
//                   },
//                   child: Text("Pay now")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // void _handlePaymentSuccess(PaymentSuccessResponse response) {
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(
//   //         content:
//   //             Text('Payment Successful: ${response.paymentId.toString()}')),
//   //   );

//   //   // Do something when payment succeeds
//   //   log("_handlePaymentSuccess ${response.data.toString()}");
//   //   Navigator.pushAndRemoveUntil(
//   //     context,
//   //     MaterialPageRoute(builder: (context) =>const HomeScreen()),
//   //     (route) => false, // This will clear all routes
//   //   );
//   // }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     // Do something when payment fails
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment Failed: ${response.message.toString()}')),
//     );
//     log("_handlePaymentError ${response.message.toString()}");
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => PackageScreen()),
//       (route) => false, // This will clear all routes
//     );
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     // Do something when an external wallet was selected
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content: Text(
//               'External Wallet Selected: ${response.walletName.toString()}')),
//     );
//     log("_handleExternalWallet ${response.walletName.toString()}");
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/my_orders_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RazorpaymentGateway extends StatefulWidget {
  final double amount;
  final String packageId;
  final bool isFreePlan;
  final bool isSilverPlan;

  const RazorpaymentGateway({
    Key? key,
    required this.amount,
    required this.packageId,
    this.isFreePlan = false,
    this.isSilverPlan = false,
  }) : super(key: key);

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePayment();
    });
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
      

      if (apiResponse.statusCode == 200) {
     
 final responseData = json.decode(apiResponse.body);
      
      // Update SharedPreferences with new subscription
      if (userDataString != null) {
        Map<String, dynamic> userData = json.decode(userDataString);

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
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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
              onPressed: _handlePayment,
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
