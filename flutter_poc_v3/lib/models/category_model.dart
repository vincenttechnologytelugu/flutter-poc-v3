
class CategoryModel {
  final String category;
  final String subCategory;
  final String icon;
    final int? id;
  final String? title;
  final double? price;
  final String? model;
  final int? year;
  final String? location;
  final String? brand;
  final String? fuel;
  final String? transmission;
  final int? mileage;
  final int? ownerType;
  final String? condition;
  final String? description;

  final String? city;
  final String? thumb;

  // Properties specific
  final String? propertyType;
  final String? bedrooms;
  final String? bathrooms;
  final String? area;
  final String? furnishing;
  final String? type;

  final String? floorNumber;
  final String? totalFloors;



  // Mobile specific
  final String? storage;
  final String? ram;
  final String? screenSize;
  final String? camera;
  
  final String? battery;
  final String? processor;
  final String? operatingSystem;

  // Jobs specific
  final String? position;
  final String? company;
  final String? salary;
  final String? experienceLevel;
  final String? jobType;
    final String? industry;
    final String? qualifications;
    // ignore: non_constant_identifier_names
    // final String? contact_info;
      final String? warranty;
 

    


  // Pets specific
   
  
  // ignore: non_constant_identifier_names
  // final String? pet_category;
  final String? breed;
  final String? vaccinationType;
  



  // Services specific
  final String? serviceType;
  
  final String? serviceCategory;

  // Bikes specific
  final String? bikeType;
  
  final String? bikeBrand;
  final String? bikeModel;
  final String? bikeYear;
  final String? bikeMileage;
  final String? bikeCondition;
  final String? bikeDescription;

  //electronics
  // ignore: non_constant_identifier_names
  // final String? electronics_category;
  final String? product;
  
  final String? color;
  // ignore: non_constant_identifier_names
  // final String? fashion_category;
  final String? size;
 
  // ignore: non_constant_identifier_names
  // final String? hobby_category;
  final String? material;
  final int? dimensions;
  final String? vaccinationdType;
  // ignore: non_constant_identifier_names
  // final String? posted_at;
  final int? kilometers;
  final String? fuelType;
  final String? firstName;
  final String? lastName;
   
 final String? name;

 
 final List<String>? features;
final  int? postCount;
final  int? validityMonths;
final  int? imageAttachments;
 final int? videoAttachments;
final  int? contacts;
final  int? manualBoostInterval;
final  String? createdAt;
 final String? lastUpdated;
 final bool? isActive;


  

  CategoryModel({
    required this.category,
    required this.icon,
    this.id,
    this.title,
    this.price,
    this.model,
    this.year,
    this.location,
    this.brand,
    this.fuel,
    this.transmission,
    this.mileage,
    this.ownerType,
    this.condition,
    this.description,
    this.city,
    this.thumb,
    this.propertyType,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.furnishing,
    this.type,
    this.floorNumber,
    this.totalFloors,
    this.storage,
    this.ram,
    this.screenSize,
    this.camera,
    this.battery,
    this.processor,
    this.operatingSystem,
    this.position,
    this.company,
    this.salary,
    this.experienceLevel,
    this.jobType,
    this.industry,
    this.qualifications,
    // this.contact_info,
    this.warranty,
    // this.pet_category,
    this.breed,
    this.vaccinationType,
    this.serviceType,
    this.serviceCategory,
    this.bikeType,
    this.bikeBrand,
    this.bikeModel,
    this.bikeYear,
    this.bikeMileage,
    this.bikeCondition,
    this.bikeDescription,
    // this.electronics_category,
    this.product,
    this.color,
    // this.fashion_category,
    this.size,
    // this.hobby_category,
    this.material,
    this.vaccinationdType,
    // this.posted_at,
    this.kilometers,
    this.fuelType,
    this.firstName,
    this.lastName,
    this.name,
    this.features,
    this.postCount,
    this.validityMonths,
    this.imageAttachments,
    this.videoAttachments,
    this.contacts,
    this.manualBoostInterval,
    this.createdAt,
    this.lastUpdated,
    this.isActive,
     this.dimensions,
     this.subCategory = '',

 
  });

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      category: map['category'] ?? '',
      icon: map['icon'] ?? '',
      id: map['id'],
      title: map['title'],
      price: map['price'] != null ? double.parse(map['price'].toString()) : null,
      model: map['model'],
      year: map['year'],
      location: map['location'],
      brand: map['brand'],
      fuel: map['fuel'],
      transmission: map['transmission'],
      mileage: map['mileage'],
      ownerType: map['owner_type'],
      condition: map['condition'],
      description: map['description'],
      city: map['city'],
      thumb: map['thumb'],
      propertyType: map['property_type'],
      bedrooms: map['bedrooms'],
      bathrooms: map['bathrooms'],
      area: map['area'],
      furnishing: map['furnishing'],
      type: map['type'],
      floorNumber: map['floor_number'],
      totalFloors: map['total_floors'],
      storage: map['storage'],
      ram: map['ram'],
      screenSize: map['screen_size'],
      camera: map['camera'],
      battery: map['battery'],
      processor: map['processor'],
      operatingSystem: map['operating_system'],
      position: map['position'],
      company: map['company'],
      salary: map['salary']?.toString(),
      experienceLevel: map['experience_level'],
      jobType: map['job_type'],
      industry: map['industry'],
      qualifications: map['qualifications'],
      // contact_info: map['contact_info'],
      warranty: map['warranty'],
      // pet_category: map['pet_category'],
      breed: map['breed'],
      vaccinationType: map['vaccination_type'],
      serviceType: map['service_type'],
      serviceCategory: map['service_category'],
      bikeType: map['bike_type'],
      bikeBrand: map['bike_brand'],
      bikeModel: map['bike_model'],
      bikeYear: map['bike_year'],
      bikeMileage: map['bike_mileage'],
      bikeCondition: map['bike_condition'],
      bikeDescription: map['bike_description'],
      // electronics_category: map['electronics_category'],
      product: map['product'],
      color: map['color'],
      // fashion_category: map['fashion_category'],
      size: map['size'],
      // hobby_category: map['hobby_category'],
      material: map['material'],
      vaccinationdType: map['vaccinationd_type'],
      // posted_at: map['posted_at'],
      kilometers: map['kilometers'],
      fuelType: map['fuel_type'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      name: map['name'],
      features: map['features'] != null ? List<String>.from(map['features']) : null,
      postCount: map['post_count'],
      validityMonths: map['validity_months'],
      imageAttachments: map['image_attachments'],
      videoAttachments: map['video_attachments'],
      contacts: map['contacts'],
      manualBoostInterval: map['manual_boost_interval'],
      createdAt: map['created_at'],
      lastUpdated: map['last_updated'],
      isActive: map['is_active'],
      dimensions: map['dimensions'],
      subCategory: map['sub_category'] ?? '',
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
