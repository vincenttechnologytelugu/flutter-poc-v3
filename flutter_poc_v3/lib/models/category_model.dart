
class CategoryModel {
  final String category;
  final String icon;

  CategoryModel({
    required this.category,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}


// class CategoryModel {
//   // int id;
//   // String title;
//   // double price;
//   // String description;
//   String category;
//   String icon;
//   // String iconButton;

//   CategoryModel({
//     // this.id = 0,
//     // this.title = "",
//     // this.price = 0,
//     // this.description = "",
//     this.category = "",
//     this.icon = "",
//     // this.iconButton="",
//   });

//   factory CategoryModel.fromJson(Map map) {
//     return CategoryModel(
//         // id: map["id"],
//         // title: map["title"],
//         // price: double.parse(map["price"].toString()),
//         // description: map["description"],
//         category: map["category"],
//         icon: map["icon"]);
      
       
//   }
// }
