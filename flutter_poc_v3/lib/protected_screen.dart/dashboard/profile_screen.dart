import 'dart:convert';
import 'dart:developer';
import 'package:flutter_poc_v3/protected_screen.dart/invoice_billing_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/ProfileResponseModel.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/update_profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_poc_v3/models/profile_details.dart';
import 'package:flutter_poc_v3/public_screen.dart/reset_password_screen.dart';
import 'dart:io'; // Add this import

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  bool isLoading = true;
  late ProfileDetails profileDetails;

  ProfileResponseModel profileData = ProfileResponseModel();
  XFile? pickedXFile;
  @override
  void initState() {
    super.initState();
    refreshUserDataFromApi();
  }

  Future<void> loadUserData() async {
    setState(() {
      isLoading = true;
      // Clear previous data
      profileData = ProfileResponseModel(); // Reset to empty model
    });
    // setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();

      // Debug log to check what's stored in SharedPreferences
      log('Loading user data from SharedPreferences:');
      log('Stored firstName: ${prefs.getString('first_name')}');
      log('Stored lastName: ${prefs.getString('last_name')}');
      log('Stored email: ${prefs.getString('email')}');

      setState(() {
        firstName = prefs.getString('first_name') ?? 'Not available';
        lastName = prefs.getString('last_name') ?? 'Not available';
        email = prefs.getString('email') ?? 'Not available';
        isLoading = false;
      });

      // If the data is missing, try to fetch it from the API
      if (firstName == 'Not available' || lastName == 'Not available') {
        await refreshUserDataFromApi();
      }
    } catch (e) {
      log('Error loading user data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoading) {
      loadUserData();
    }
  }

  Future<void> refreshUserDataFromApi() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        log('No token found');
        return;
      }

      // Make API call to get user details
      final response = await http.get(
        Uri.parse('http://192.168.0.179:8080/authentication/auth_user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userDetails = jsonDecode(response.body);
        log('User details: $userDetails');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        profileData = ProfileResponseModel.fromJson(responseData);
        setState(() {
          isLoading = false;
        });
        log('User details: $userDetails');
        // Update SharedPreferences with latest data
        await prefs.setString('first_name', profileData.firstName ?? '');
        await prefs.setString('last_name', profileData.lastName ?? '');
        await prefs.setString('email', profileData.email ?? '');
      }
    } catch (e) {
      log('Error refreshing user data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshUserDataFromApi,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadUserData,
              // onRefresh: refreshUserDataFromApi,

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                pickedXFile != null
                                    ? CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                            FileImage(File(pickedXFile!.path)))
                                    : CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.person, size: 50),
                                        // backgroundImage:FileImage(File(pickedXFile!.path))
                                      ),
                                // CircleAvatar(
                                //   backgroundColor: Colors.grey,
                                //   radius: 60,
                                //   backgroundImage: pickedXFile != null
                                //       ? FileImage(
                                //           File(pickedXFile!.path),
                                //         )
                                //       : null,
                                //   // child: Icon(Icons.person, size: 50),
                                // ),
                                // Positioned(
                                //   bottom: 0,
                                //   right: 10,
                                //   child: Icon(
                                //     Icons.photo_camera
                                //     )
                                //     )
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: InkWell(
                                        onTap: () async {
                                          // Handle camera icon tap
                                          final ImagePicker imagePicker =
                                              ImagePicker();
                                          pickedXFile =
                                              await imagePicker.pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 30,
                                            // maxHeight: 500,
                                            preferredCameraDevice:
                                                CameraDevice.rear,
                                            // maxWidth: 500,
                                          );

                                          if (pickedXFile != null) {
                                            log("Image Picked: ${pickedXFile!.path}");
                                            setState(() {
                                              pickedXFile = pickedXFile;
                                            });
                                          } else {
                                            log("Image not Picked");
                                          }
                                          //     .then((value) {
                                          //   if (value != null) {
                                          //     // Handle the picked image
                                          //     // You can update the profile image here
                                          //     // For example, you can save the image to SharedPreferences
                                          //     // and update the UI accordingly
                                          //   }
                                          // });
                                          // ImagePickerService.pickImage(
                                          //     context, (image) {
                                          //   // Handle the picked image
                                          //   // You can update the profile image here
                                          //   // For example, you can save the image to SharedPreferences
                                          //   // and update the UI accordingly
                                          // });
                                        },
                                        child:
                                            Icon(Icons.photo_camera, size: 20)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              'Welcome, ${profileData.firstName ?? ""} ${profileData.lastName ?? ""}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 16),

                          const SizedBox(height: 8),
                          Text(
                            'Email: ${profileData.email ?? ""}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),

                          // Add these buttons after the email Text widget in the Column
                          const SizedBox(height: 20),
                          // In your ProfileScreen where you navigate to UpdateProfileScreen
                          // In ProfileScreen
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Navigate to UpdateProfileScreen and pass the current profile data
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateProfileScreen(
                                      firstName: profileData.firstName ?? '',
                                      lastName: profileData.lastName ?? '',
                                      email: profileData.email ?? '',
                                    ),
                                  ),
                                );
                                // Check if updated details are returned
                                if (result != null &&
                                    result is Map<String, String>) {
                                  await loadUserData(); // Refresh data from SharedPreferences
                                }
                                // Check if we got updated data back
                                if (result != null &&
                                    result is Map<String, String>) {
                                  setState(() {
                                    profileData.firstName = result['firstName'];
                                    profileData.lastName = result['lastName'];
                                    profileData.email = result['email'];
                                  });

                                  // Optionally save updated data to SharedPreferences or refresh from API
                                  final prefs =
                                      await SharedPreferences.getInstance();

                                  await prefs.setString('first_name',
                                      profileData.firstName ?? '');
                                  await prefs.setString(
                                      'last_name', profileData.lastName ?? '');
                                  await prefs.setString(
                                      'email', profileData.email ?? '');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                // const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: const Color.fromARGB(255, 93,
                                    93, 132), // You can customize the color
                              ),
                              child: const Text(
                                "Update Profile",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordScreen(),
                                  ),
                                );
                                // Add reset password navigation/logic here
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                backgroundColor:
                                    Colors.green, // You can customize the color
                              ),
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          // After Reset Password button, add this:
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const InvoiceBillingScreen(),
                                  ),
                                );
                                // Add reset password navigation/logic here
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                backgroundColor: const Color.fromARGB(255, 239,
                                    7, 170), // You can customize the color
                              ),
                              child: const Text(
                                'Buy Packages',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: double.parse("100"),
                            child: ElevatedButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();

                                await prefs.clear(); // Clear all stored data

                                await prefs.remove('token');
                                await AuthService.logout();

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                backgroundColor:
                                    Colors.red, // You can customize the color
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
