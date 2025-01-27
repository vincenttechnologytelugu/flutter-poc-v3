import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/my_orders_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/package_screen.dart';

class InvoiceBillingScreen extends StatefulWidget {
  const InvoiceBillingScreen({super.key});

  @override
  State<InvoiceBillingScreen> createState() => _InvoiceBillingScreenState();
}

class _InvoiceBillingScreenState extends State<InvoiceBillingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Invoice & Billing'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                  title: const Text(
                    'Buy Package',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text('Sell faster'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const PackageScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16), // Space between cards
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.receipt, color: Colors.blue),
                  title: const Text(
                    'Invoice',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text('Invoice & Billing'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Invoice screen
                  },
                ),
              ),
              const SizedBox(height: 16), // Space between cards
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.payment, color: Colors.blue),
                  title: InkWell(
                    // In your InvoiceBillingScreen
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyOrdersScreen(),
                        ),
                      );
                    },
        
                    child: const Text(
                      'My Orders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: const Text('Active,scheduled and expired orders'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Payment screen
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
