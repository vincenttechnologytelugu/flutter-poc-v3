import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'dart:developer';

class ResponsiveProductsScreen extends StatefulWidget {
  const ResponsiveProductsScreen({super.key});

  @override
  State<ResponsiveProductsScreen> createState() =>
      _ResponsiveProductsScreenState();
}

class _ResponsiveProductsScreenState extends State<ResponsiveProductsScreen> {
  final ProductsController productsController = Get.put(ProductsController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent - 200) {
  //     _loadMoreData();
  //   }
  // }
void _scrollListener() {
  if (!_scrollController.hasClients) return;
  
  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.position.pixels;
  final threshold = maxScroll * 0.9; // Load more when 90% scrolled

  if (currentScroll >= threshold) {
    _loadMoreData();
  }
}

  Future<void> _loadData() async {
    await productsController.getData();
  }

  
 Future<void> _loadMoreData() async {
    if (!productsController.isLoadingMore && productsController.hasMoreData) {
    log('Loading more data... Current page: ${productsController.currentPage}');
    await productsController.getData(loadMore: true);
    log('After loading more. Current page: ${productsController.currentPage}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (controller) {
        log('Building screen with ${controller.productModelList.length} products');
        return Scaffold(
          appBar: AppBar(
            title: const Text('Fresh recomendations'),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: _loadData,
            child: Column(
              children: [
                // Debug information
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black12,
                  child: Text(
                    'Page: ${controller.currentPage} / ${controller.totalPages}\n'
                    'Has More: ${controller.hasMoreData}\n'
                    'Items: ${controller.productModelList.length}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  child: _buildBody(controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(ProductsController controller) {
    if (controller.isLoadingOne) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.productModelList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No products found',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: controller.productModelList.length,
            itemBuilder: (context, index) {
              final product = controller.productModelList[index];
              log('Building product card for index $index: ${product.brand}');
              return ProductCard(product: product);
            },
          ),
        ),
        if (controller.isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        if (!controller.isLoadingMore && controller.hasMoreData)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _loadMoreData,
              child: const Text('Load More' ,style: TextStyle(fontSize: 15,color: Colors.red),),
            ),
          ),
      ],
    );
  }
}

// Add this ProductCard widget class
class ProductCard extends StatefulWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                child: widget.product.thumb != null
                    ? Image.network(
                        widget.product.thumb!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                        ),
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
                    widget.product.brand ?? 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '₹ ${widget.product.price?.toString() ?? 'N/A'}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.product.year ?? 'N/A'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${widget.product.mileage ?? '0'} km',
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
    );
  }
}
