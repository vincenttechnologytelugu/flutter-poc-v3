import 'package:get/get.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductsController());
  }
}
