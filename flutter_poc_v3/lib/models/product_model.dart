import 'dart:developer';

import 'package:flutter_poc_v3/models/action_flags.dart';
import 'package:intl/intl.dart';

class ProductModel {


  

   // ignore: non_constant_identifier_names
   final String? published_at;
  final String publishedAt; // Add this field
  
    // ignore: non_constant_identifier_names
    final dynamic featured_at;  // Add this line
  // ignore: non_constant_identifier_names
  dynamic valid_till; // Change type to dynamic to handle both int and String
  final ActionFlags? actionFlags;
  final String? id;
  final String? title;
  final dynamic price;
  final String? model;
  final int? year;
  final String? location;
  final String? brand;
  final String? fuel;
  final String? transmission;
  final int? mileage;
  final String? ownerType;
  final String? condition;
  final String? description;
  final String? category;
  final String? city;
  final String? thumb;
  final String icon;
  
 
  

  // ignore: non_constant_identifier_names
  final String? electronics_category;

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
  final dynamic storage;
  final String? ram;
  final dynamic screenSize;
  final dynamic camera;

  final dynamic battery;
  final String? processor;
  final dynamic operatingSystem;

  // Jobs specific
  final String? position;
  final String? company;
  final double? salary;
  final String? experienceLevel;
  final String? jobType;
  final String? industry;
  final String? qualifications;
  // ignore: non_constant_identifier_names
  final String? contact_info;
  final dynamic warranty;
//  final int? featured_at; // Unix timestamp in seconds

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
 
  final String? bikeCondition;
  final String? bikeDescription;

  //electronics
  // ignore: non_constant_identifier_names

  final String? product;

  final dynamic color;
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
  final String? convesationId;

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
  // ignore: non_constant_identifier_names
  String? posted_by;
  // ignore: non_constant_identifier_names
  int? created_at;
  // ignore: non_constant_identifier_names
  int? last_updated_at;
  // final int? valid_till;
  
  // ignore: non_constant_identifier_names
  int? deleted_at;
  int? assetId;

  
  final List<Map<String, dynamic>>? assets; // Add this field

  String get thumbnailUrl {
    if (assets == null || assets!.isEmpty) return '';
    // Find first image asset
    final imageAsset = assets!.firstWhere(
      (asset) => asset['type']?.toString().startsWith('image/') ?? false,
      orElse: () => {},
    );
    return imageAsset['url'] ?? '';
  }


  //  String getFirstImageUrl() {
  //   if (assets != null && assets!.isNotEmpty) {
  //     var imageAsset = assets!.firstWhere(
  //       (asset) => asset['type'].toString().contains('image'),
  //       orElse: () => {},
  //     );
  //     if (imageAsset.containsKey('url')) {
  //       return 'http://13.200.179.78/${imageAsset['url']}';
  //     }
  //   }
  //   return '';
  // }

  ProductModel({
   
    // ignore: non_constant_identifier_names
    this.published_at,
 required this.publishedAt, // Add this
    this.assetId,
    this.assets,
    this.actionFlags,
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
    this.convesationId,
    required this.icon,
    // ignore: non_constant_identifier_names
    this.posted_by,
    // ignore: non_constant_identifier_names
    this.created_at,
    // ignore: non_constant_identifier_names
    this.last_updated_at,
    // ignore: non_constant_identifier_names
    this.valid_till,
   // ignore: non_constant_identifier_names
   this.featured_at,
   
    // ignore: non_constant_identifier_names
    this.deleted_at,
   

   
  });
  Map<String, dynamic> toJson() {
    return {
      'featured_at': featured_at,
      'valid_till': valid_till,
      // Add other fields as needed
    };
  }

 


  factory ProductModel.fromJson(Map<String, dynamic> map) {
    try {
      log('Parsing JSON: $map'); // Add this debug log
      String id = map['_id']?.toString() ?? '';

      // Handle MongoDB ObjectId
      if (map['_id'] != null) {
        if (map['_id'] is Map && map['_id']['\$oid'] != null) {
          id = map['_id']['\$oid'].toString();
        } else {
          id = map['_id'].toString();
        }
      }

      log('Parsed ID: $id');
      //         var id = map['_id'];
      // if (id is Map) {
      //   id = id['\$oid']; // MongoDB ObjectId format
      // } else if (id ??= "") {
      //   id = map['id']; // Fallback to regular id field
      // }
      //    log('Parsed ID: $id'); // Debug print to verify parsed ID
      return ProductModel(
        publishedAt: map['published_at'] ?? '',
          published_at: map['published_at'],
        id: id,
        // id: int.tryParse(id.toString()), // Convert to int if needed

        // id: map['id'],
        icon: map['icon'] ?? '',

        title: map['title']?.toString(),
        assetId: map['assetId'],
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
        // mileage: map['mileage'] != null
        //     ? (map['mileage'] is int
        //         ? map['mileage']
        //         : int.tryParse(map['mileage'].toString()))
        //     : null,
        
      
        ownerType: map['ownerType']?.toString(),
        condition: map['condition']?.toString(),
        description: map['description']?.toString(),
        category: map['category']?.toString(),
        city: map['city']?.toString(),
        thumb: map['thumb']?.toString(),
          // thumb: map['thumb'] != null ? 'http://13.200.179.78/${map['thumb']}' : null,
        // Properties specific
        propertyType: map['propertyType']?.toString(),
        bedrooms: map['bedrooms']?.toString(),
        bathrooms: map['bathrooms']?.toString(),
        area: map['area']?.toString(),
        furnishing: map['furnishing']?.toString(),
        // Mobile specific
        storage: map['storage'],
        ram: map['ram']?.toString(),
        screenSize: map['screenSize'],
        camera: map['camera'],
        battery: map['battery'],
        processor: map['processor']?.toString(),
        operatingSystem: map['operatingSystem'],
        // Jobs specific
        position: map['position']?.toString(),
        company: map['company']?.toString(),
        
        // salary: map['salary'] != null
        //     ? (map['salary'] is double
        //         ? map['salary']
        //         : double.tryParse(map['salary'].toString()))
        //     : null,
          // salary: map['salary']?.toDouble(),
             // Modify the salary parsing
      salary: map['salary'] != null 
          ? (map['salary'] is num 
              ? (map['salary'] as num).toDouble()
              : map['salary'].toString().isNotEmpty 
                  ? double.tryParse(map['salary'].toString()) ?? 0.0
                  : 0.0)
          : 0.0,
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
    
        bikeCondition: map['bikeCondition']?.toString(),
        bikeDescription: map['bikeDescription']?.toString(),
        type: map['type']?.toString(),
        floorNumber: map['floorNumber']?.toString(),
        totalFloors: map['totalFloors']?.toString(),
        //electronics
        electronics_category: map['electronics_category']?.toString(),
        product: map['product']?.toString(),
        warranty: map['warranty']?.toString(),
        color: map['color'],
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
        features:
            map['features'] != null ? List<String>.from(map['features']) : null,
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
        convesationId: map['convesationId']?.toString(),
        posted_by: map['posted_by']?.toString(),
        created_at: map['created_at'] != null
            ? (map['created_at'] is int
                ? map['created_at']
                : int.tryParse(map['created_at'].toString()))
            : null,
        last_updated_at: map['last_updated_at'] != null
            ? (map['last_updated_at'] is int
                ? map['last_updated_at']
                : int.tryParse(map['last_updated_at'].toString()))
            : null,
      
        // published_at: map['published_at'] != null
        //     ? (map['published_at'] is int
        //         ? map['published_at']
        //         : int.tryParse(map['published_at'].toString()))
        //     : null,
        deleted_at: map['deleted_at'] != null
            ? (map['deleted_at'] is int
                ? map['deleted_at']
                : int.tryParse(map['deleted_at'].toString()))
            : null,

        // Add this line to parse action_flags
        actionFlags: map['action_flags'] != null
            ? ActionFlags.fromJson(map['action_flags'])
            : null,
        // In ProductModel.fromJson method, update these lines:
        featured_at: map['featured_at'] != null
            ? (map['featured_at'] is int
                ? map['featured_at']
                : map['featured_at'] is String
                    ? DateTime.parse(map['featured_at'])
                            .millisecondsSinceEpoch ~/
                        1000
                    : null)
            : null,
         
        valid_till: map['valid_till'] != null
            ? (map['valid_till'] is int
                ? map['valid_till']
                : map['valid_till'] is String
                    ? DateTime.parse(map['valid_till'])
                            .millisecondsSinceEpoch ~/
                        1000
                    : null)
            : null,
        assets: map['assets'] != null
            ? List<Map<String, dynamic>>.from(map['assets'])
            : null, // Add this line to parse assets


            
      );
    } catch (e) {
      log('Error parsing JSON: $e');
      rethrow;
    }


  }
  Map<String, dynamic> toMap() {
    return {
     
      'assets': assets, // Add this line to include assets in the map
        'featured_at': featured_at,  // Add this line
    };
  }
 List<String> getAllImageIds() {
    if (assets == null) return [];
    return assets!
        .where((asset) => asset['type'].toString().startsWith('image/'))
        .map((asset) => asset['_id'].toString())
        .toList();
  }

  List<String> getAllVideoIds() {
    if (assets == null) return [];
    return assets!
        .where((asset) => asset['type'].toString().startsWith('video/'))
        .map((asset) => asset['_id'].toString())
        .toList();
  }

  //  String getFormattedPublishedDate() {
  //   if (published_at == null || published_at!.isEmpty) {
  //     return 'No date';
  //   }

  //   try {
  //     DateTime dateTime = DateTime.parse(published_at!).toLocal();
  //     return DateFormat('EEEE, MMMM d, yyyy').format(dateTime);
  //     // This will output: "Thursday, March 13, 2025"
  //   } catch (e) {
  //     log('Error parsing date: $e');
  //     return 'Invalid date';
  //   }
  // }
    // Format 5: "Thursday, March 13, 2025 at 3:13 PM"
  String getFormattedDateWithTime() {
    if (published_at == null || published_at!.isEmpty) return 'No date';
    try {
      DateTime dateTime = DateTime.parse(published_at!).toLocal();
      return DateFormat('EEEE, MMMM d, yyyy \'at\' h:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }



  String getFirstImageUrl() {
    try {
      if (assets != null && assets!.isNotEmpty) {
        var imageAsset = assets!.firstWhere(
          (asset) => asset['type'].toString().contains('image'),
          orElse: () => {},
        );
        if (imageAsset.containsKey('url')) {
          log('Found image URL: ${imageAsset['url']}'); // Debug print
          return 'http://13.200.179.78/${imageAsset['url']}';
        }
      }
      log('No image assets found'); // Debug print
      return '';
    } catch (e) {
      log('Error getting image URL: $e'); // Debug print
      return '';
    }
  }




  // ToJson method
  Map<String, dynamic> map() {
    return {
      'mileage': mileage,
      // ... other fields
    };
  }
 

  

}

