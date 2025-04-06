import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/category_details_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/leven_category_details_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/category_controller.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: GetBuilder<CategoryController>(builder: (categoryController) {
        return categoryController.isLoadingOne
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 187, 9, 218),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: categoryController.productModelList.length,
                itemBuilder: (context, index) {
                  ProductModel productModel =
                      categoryController.productModelList[index];
                  return InkWell(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => CategoryDetailsScreen(
                    //         productModel: productModel,
                    //       ),
                    //     ),
                    //   );
                    // },

                    onTap: () {
                      // Check if the category is Cars
                      if (productModel.category?.toLowerCase() == 'cars') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailsScreen(
                              productModel: productModel,
                            ),
                          ),
                        );
                      } else {
                        // For all other categories
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevenCategoryDetailsScreen(
                              productModel: productModel,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 57, 37, 183)
                                // ignore: deprecated_member_use
                                .withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              productModel.icon,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.category,
                                  size: 50,
                                  color: Colors.purple.shade300,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            productModel.category.toString(),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 95, 1, 211),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
