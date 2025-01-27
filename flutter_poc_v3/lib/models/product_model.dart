


import 'dart:developer';

class ProductModel {
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
  final String? category;
  final String? city;
  final String? thumb;
 final String icon;

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
    final String? contact_info;
      final String? warranty;
 

    


  // Pets specific
   
  
  // ignore: non_constant_identifier_names
  final String? pet_category;
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
  final String? electronics_category;
  final String? product;
  
  final String? color;
  // ignore: non_constant_identifier_names
  final String? fashion_category;
  final String? size;
 
  // ignore: non_constant_identifier_names
  final String? hobby_category;
  final String? material;
  final int? dimensions;
  final String? vaccinationdType;
  // ignore: non_constant_identifier_names
  final String? posted_at;
  final int? kilometers;
  final String? fuelType;
  final String? firstName;
  final String? lastName;
  final String? state;
  
   
  String? name;

 
  List<String>? features;
  int? postCount;
  int? validityMonths;
  int? imageAttachments;
  int? videoAttachments;
  int? contacts;
  int? manualBoostInterval;
  String? createdAt;
  String? lastUpdated;
  bool? isActive;

   

 
 
  


  
  
  



  

  ProductModel({
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
    this.category,
    this.city,
    this.thumb,
    this.propertyType,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.furnishing,
    this.storage,
    this.ram,
    this.position,
    this.company,
    this.salary,
    this.experienceLevel,
    this.jobType,
    
    this.serviceType,
    this.serviceCategory,
    this.bikeType,
    this.bikeBrand,
    this.bikeModel,
    this.bikeYear,
    this.bikeMileage,
    this.bikeCondition,
    this.bikeDescription,
    this.type,
    this.floorNumber,
    this.totalFloors,
    this.screenSize,
    this.camera,
    this.battery,
    this.processor,
    this.operatingSystem,
    this.industry,
    this.qualifications,
    // ignore: non_constant_identifier_names
    this.contact_info,
    // ignore: non_constant_identifier_names
    this.pet_category,
    this.breed,
    this.vaccinationType,
    // ignore: non_constant_identifier_names
    this.electronics_category,
    this.product,
    this.warranty,
    this.color,
    // ignore: non_constant_identifier_names
    this.fashion_category,
    this.size,

    // ignore: non_constant_identifier_names
    this.hobby_category,
    this.material,
    this.dimensions,
    this.vaccinationdType,
    // ignore: non_constant_identifier_names
    this.posted_at,
    this.kilometers,
    this.fuelType,
    this.firstName,
    this.lastName,
  
    this.name,
    this.state,
   


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
   required this.icon,
    


    
    
  
   
  
    
    
    
   
  
    


  });

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    try {
      log('Parsing JSON: $map'); // Add this debug log
      return ProductModel(
        id: map['id'],
        icon: map['icon'] ?? '',
        title: map['title']?.toString(),
        price: map['price'] != null 
            ? (map['price'] is double 
                ? map['price'] 
                : double.tryParse(map['price'].toString())) 
            : null,
        model: map['model']?.toString(),
        year: map['year'] != null 
            ? (map['year'] is int 
                ? map['year'] 
                : int.tryParse(map['year'].toString())) 
            : null,
        location: map['location']?.toString(),
        brand: map['brand']?.toString(),
        fuel: map['fuel']?.toString(),
        transmission: map['transmission']?.toString(),
        mileage: map['mileage'] != null 
            ? (map['mileage'] is int 
                ? map['mileage'] 
                : int.tryParse(map['mileage'].toString())) 
            : null,
        ownerType: map['ownerType'] != null 
            ? (map['ownerType'] is int 
                ? map['ownerType'] 
                : int.tryParse(map['ownerType'].toString())) 
            : null,
        condition: map['condition']?.toString(),
        description: map['description']?.toString(),
        category: map['category']?.toString(),
        city: map['city']?.toString(),
        thumb: map['thumb']?.toString(),
         // Properties specific
        propertyType: map['propertyType']?.toString(),
        bedrooms: map['bedrooms']?.toString(),
        bathrooms: map['bathrooms']?.toString(),
        area: map['area']?.toString(),
        furnishing: map['furnishing']?.toString(),
        // Mobile specific
        storage: map['storage']?.toString(),
        ram: map['ram']?.toString(),
        screenSize: map['screenSize']?.toString(),
        camera: map['camera']?.toString(),
        battery: map['battery']?.toString(),
        processor: map['processor']?.toString(),
        operatingSystem: map['operatingSystem']?.toString(),
        // Jobs specific
        position: map['position']?.toString(),
        company: map['company']?.toString(),
        salary: map['salary']?.toString(),
        experienceLevel: map['experienceLevel']?.toString(),

        jobType: map['jobType']?.toString(),
        industry: map['industry']?.toString(),
        qualifications: map['qualifications']?.toString(),
        contact_info: map['contact_info']?.toString(),


        // Pets specific
        pet_category: map['pet_category']?.toString(),
        breed: map['breed']?.toString(),
        vaccinationType: map['vaccinationType']?.toString(),
      
        
        // Services specific
        serviceType: map['serviceType']?.toString(),
        serviceCategory: map['serviceCategory']?.toString(),
        // Bikes specific
        bikeType: map['bikeType']?.toString(),
        bikeBrand: map['bikeBrand']?.toString(),
        bikeModel: map['bikeModel']?.toString(),
        bikeYear: map['bikeYear']?.toString(),
        bikeMileage: map['bikeMileage']?.toString(),
        bikeCondition: map['bikeCondition']?.toString(),
        bikeDescription: map['bikeDescription']?.toString(),
        type: map['type']?.toString(),
        floorNumber: map['floorNumber']?.toString(),
        totalFloors: map['totalFloors']?.toString(),
        //electronics
        electronics_category: map['electronics_category']?.toString(),
        product: map['product']?.toString(),
        warranty: map['warranty']?.toString(),
        color: map['color']?.toString(),
        fashion_category: map['fashion_category']?.toString(),
        size: map['size']?.toString(),
        hobby_category: map['hobby_category']?.toString(),
        material: map['material']?.toString(),
        dimensions: map['dimensions'] != null 
            ? (map['dimensions'] is int 
                ? map['dimensions'] 
                : int.tryParse(map['dimensions'].toString())) 
            : null,
            vaccinationdType: map['vaccinationdType']?.toString(),
            posted_at: map['posted_at']?.toString(),
            kilometers: map['kilometers'] != null 
            ? (map['kilometers'] is int 
                ? map['kilometers'] 
                : int.tryParse(map['kilometers'].toString())) 
            : null,
            fuelType: map['fuelType']?.toString(),
            firstName: map['firstName']?.toString(),
            lastName: map['lastName']?.toString(),

            
            name: map['name']?.toString(),
            features: map['features'] != null ? List<String>.from(map['features']) : null,
            postCount: map['post_count'] != null 
            ? (map['post_count'] is int 
                ? map['post_count'] 
                : int.tryParse(map['post_count'].toString())) 
            : null,
            validityMonths: map['validity_months'] != null 
            ? (map['validity_months'] is int 
                ? map['validity_months'] 
                : int.tryParse(map['validity_months'].toString())) 
            : null,
            imageAttachments: map['image_attachments'] != null 
            ? (map['image_attachments'] is int 
                ? map['image_attachments'] 
                : int.tryParse(map['image_attachments'].toString())) 
            : null,
            videoAttachments: map['video_attachments'] != null 
            ? (map['video_attachments'] is int 
                ? map['video_attachments'] 
                : int.tryParse(map['video_attachments'].toString())) 
            : null,
            contacts: map['contacts'] != null 
            ? (map['contacts'] is int 
                ? map['contacts'] 
                : int.tryParse(map['contacts'].toString())) 
            : null,
            manualBoostInterval: map['manual_boost_interval'] != null 
            ? (map['manual_boost_interval'] is int 
                ? map['manual_boost_interval'] 
                : int.tryParse(map['manual_boost_interval'].toString())) 
            : null,
            createdAt: map['created_at']?.toString(),
            lastUpdated: map['last_updated']?.toString(),
            isActive: map['is_active'] != null 
            ? (map['is_active'] is bool 
                ? map['is_active'] 
                : bool.tryParse(map['is_active'].toString())) 
            : null,
            state: map['state']?.toString(),



           

      
      //        id: json['id'],
      // name: json['name'],
      // price: json['price']?.toDouble(),
      // description: json['description'],
      // features: json['features'] != null ? List<String>.from(json['features']) : null,
      // postCount: json['post_count'],
      // validityMonths: json['validity_months'],
      // imageAttachments: json['image_attachments'],
      // videoAttachments: json['video_attachments'],
      // contacts: json['contacts'],
      // manualBoostInterval: json['manual_boost_interval'],
      // createdAt: json['created_at'],
      // lastUpdated: json['last_updated'],
      // isActive: json['is_active'],
     
           
          
           
        



      );
    } catch (e) {
      log('Error parsing JSON: $e');
      rethrow;
    }
  }
}
