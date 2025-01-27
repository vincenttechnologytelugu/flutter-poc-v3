// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class RazorPaymentGateway extends StatefulWidget {

//   final double price; // Amount to be paid
  
//   const RazorPaymentGateway({super.key, required this.price});

//   @override
//   State<RazorPaymentGateway> createState() => _RazorPaymentGatewayState();
// }

// class _RazorPaymentGatewayState extends State<RazorPaymentGateway> {
//   late Razorpay _razorpay;

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    
//     // Start payment when widget is initialized
//     _startPayment();
//   }

//   void _startPayment() {
//     var options = {
//       'key': 'YOUR_RAZORPAY_KEY', // Replace with your Razorpay key
//       'amount': widget.price * 100, // Amount in smallest currency unit (paise for INR)
//       'name': 'Your Company Name',
//       'description': 'Payment for your order',
//       'prefill': {
//         'contact': '1234567890', // User's phone number
//         'email': 'test@example.com' // User's email
//       },
//       'external': {
//         'wallets': ['paytm']
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     // Payment successful
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
//     );
//     Navigator.pop(context, true); // Return success
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     // Payment failed
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment Failed: ${response.message}')),
//     );
//     Navigator.pop(context, false); // Return failure
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('External Wallet Selected: ${response.walletName}')),
//     );
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment'),
//       ),
//       body: const Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }





import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
//import 'package:shopping_api_classes/screens/products_screen.dart';
class RazorpaymentGateway extends StatefulWidget {
  const RazorpaymentGateway({super.key});

  @override
  State<RazorpaymentGateway> createState() => _RazorpaymentGatewayState();
}

class _RazorpaymentGatewayState extends State<RazorpaymentGateway> {
 final Razorpay _razorpay = Razorpay();
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              var options = {
                'key': 'rzp_test_SHO15jj5fCGbi2',
                'price': 1000,
                'name': 'Olx Corp.',
                'description': 'Silver Package',
                'prefill': {
                  'contact': '8888888888',
                  'email': 'test@razorpay.com'
                }
              };
              _razorpay.open(options);
            },
            child: Text("Pay now")),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    
    // Do something when payment succeeds
    log("_handlePaymentSuccess ${response.data.toString()}");
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
    (route) => false, // This will clear all routes
  );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    log("_handlePaymentError ${response.message.toString()}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
}
