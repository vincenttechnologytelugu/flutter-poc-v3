

// lib/utils/location_utils.dart
 import 'package:shared_preferences/shared_preferences.dart';

class LocationUtils {
  // ignore: constant_identifier_names
  static const String LOCATION_KEY = 'current_location';
  // ignore: constant_identifier_names
  static const String CITY_KEY = 'current_city';
  // ignore: constant_identifier_names
  static const String STATE_KEY = 'current_state';

  static Future<String> getCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(LOCATION_KEY) ?? '';
  }

  static Future<String> getCurrentCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(CITY_KEY) ?? '';
  }

  static Future<String> getCurrentState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(STATE_KEY) ?? '';
  }

  static Future<void> saveLocation({
    required String location,
    required String city,
    required String state,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LOCATION_KEY, location);
    await prefs.setString(CITY_KEY, city);
    await prefs.setString(STATE_KEY, state);
  }
}







// // In a new file: lib/utils/location_utils.dart
// import 'package:shared_preferences/shared_preferences.dart';

// class LocationUtils {
//   static const String LOCATION_KEY = 'current_location';
//   static const String CITY_KEY = 'current_city';
//   static const String STATE_KEY = 'current_state';

//   static Future<void> saveLocation({
//     required String location,
//     required String city,
//     required String state,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(LOCATION_KEY, location);
//     await prefs.setString(CITY_KEY, city);
//     await prefs.setString(STATE_KEY, state);
//   }

//   static Future<String> getCurrentLocation() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(LOCATION_KEY) ?? '';
//   }

//   static Future<String> getCurrentCity() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(CITY_KEY) ?? '';
//   }

//   static Future<String> getCurrentState() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(STATE_KEY) ?? '';
//   }
// }
