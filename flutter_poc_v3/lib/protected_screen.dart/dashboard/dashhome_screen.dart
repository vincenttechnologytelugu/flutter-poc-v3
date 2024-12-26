import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/responsive_products_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/product_details.dart';
import 'package:flutter_poc_v3/protected_screen.dart/responsive_products_screen.dart';


class DashhomeScreen extends StatefulWidget {
  const DashhomeScreen({super.key});

  @override
  State<DashhomeScreen> createState() => _DashhomeScreenState();
}

class _DashhomeScreenState extends State<DashhomeScreen> {
  final ProductsController productsController = Get.put(ProductsController());
  final ResponsiveProductsScreen responsiveProductsScreen =Get.put(ResponsiveProductsScreen());

  final List<Map<String, String>> items = [
    {"image": "assets/images/car s.jpg", "caption": "Cars"},
    {"image": "assets/images/property.png", "caption": "Property"},
    {"image": "assets/images/mobiles.png", "caption": "Mobiles"},
    {"image": "assets/images/jobs.png", "caption": "Jobs"},
    {"image": "assets/images/fashion.png", "caption": "Fashion"},
    {
      "image": "assets/images/books,sports & Hobbies.jpg",
      "caption": "Books & Sports"
    },
    {"image": "assets/images/bike.jpg", "caption": "Bike"},
    {
      "image": "assets/images/Electronics and appliances.png",
      "caption": "Electronics"
    },
    {
      "image": "assets/images/Commercialvehicle&spares.jpg",
      "caption": "Commercial Vehicle"
    },
    {"image": "assets/images/furniture.png", "caption": "Furniture"},
    {"image": "assets/images/pets.png", "caption": "Pets"},
    {"image": "assets/images/services.jpg", "caption": "Services"},
  ];

  @override
  void initState() {
    super.initState();
    productsController.getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (screenWidth > 1200) {
      crossAxisCount = 12;
    } else if (screenWidth > 600) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 6;
    }

    return Scaffold(
      appBar: AppBar(title: Text("data")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Browse Categories Title
            Container(
              margin: EdgeInsets.only(left: 150),
              child: Text(
                'Browse Categories',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Categories Grid
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        log('Tapped on ${items[index]["caption"]}');
                      },
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    items[index]["image"]!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              items[index]["caption"]!,
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Fresh Recommendations Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Fresh Recommendations",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Products Grid
            GetBuilder<ProductsController>(
              builder: (controller) {
                if (controller.isLoadingOne) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.productModelList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('No products available'),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 1200 ? 4 : 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: controller.productModelList.length,
                    itemBuilder: (context, index) {
                      final product = controller.productModelList[index];
                      return ProductCard(product: product);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Product Card Widget
class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(productModel: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: product.thumb != null
                      ? Image.network(
                          product.thumb!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.image_not_supported),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported),
                        ),
                ),
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.brand ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '₹ ${product.price?.toString() ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.year ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${product.mileage ?? '0'} km',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
