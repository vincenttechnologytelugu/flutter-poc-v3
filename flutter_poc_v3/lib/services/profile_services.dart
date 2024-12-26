import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future<bool> hasProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('first_name');
    final lastName = prefs.getString('last_name');
    final email = prefs.getString('email');
    
    return firstName != null && lastName != null && email != null &&
           firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty;
  }

  // You can also add more profile-related methods here
  static Future<Map<String, String>> getProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'first_name': prefs.getString('first_name') ?? '',
      'last_name': prefs.getString('last_name') ?? '',
      'email': prefs.getString('email') ?? '',
    };
  }

  static Future<void> saveProfileData({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', firstName);
    await prefs.setString('last_name', lastName);
    await prefs.setString('email', email);
  }
}
