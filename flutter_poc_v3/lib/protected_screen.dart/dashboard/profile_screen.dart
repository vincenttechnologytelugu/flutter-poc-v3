import 'dart:async';
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
  Timer? _refreshTimer;
  String firstName = '';
  String lastName = '';
  String email = '';
  bool isLoading = true;
  bool _mounted = true; // Track mounted state
  late ProfileDetails profileDetails;

  ProfileResponseModel profileData = ProfileResponseModel();
  XFile? pickedXFile;
  @override
  void initState() {
    super.initState();
    refreshUserDataFromApi();
    // Set up periodic refresh
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (mounted) {
        // Check if widget is still mounted
        refreshUserData();
      }
    });
  }

  @override
  void dispose() {
    _mounted = false; // Update mounted state
    _refreshTimer?.cancel(); // Cancel timer
    super.dispose();
  }

  Future<void> refreshUserData() async {
    if (!_mounted) return; // Check if still mounted

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || !_mounted) return;

      final response = await http.get(
        Uri.parse('http://13.200.179.78/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (!_mounted) return; // Check again after async operation

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        if (_mounted) {
          // Final check before setState
          setState(() {
            // Update your state here
          });
        }
      }
    } catch (e) {
      if (_mounted) {
        log('Error refreshing user data: $e');
      }
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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
        Uri.parse('http://13.200.179.78/authentication/auth_user'),
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
      backgroundColor: const Color.fromARGB(255, 242, 245, 247),
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
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Profile Card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Profile Image Section
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 3,
                                      ),
                                    ),
                                    child: pickedXFile != null
                                        ? CircleAvatar(
                                            radius: 60,
                                            backgroundImage: FileImage(
                                                File(pickedXFile!.path)),
                                          )
                                        : const CircleAvatar(
                                            radius: 60,
                                            backgroundColor: Colors.blue,
                                            child: Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          final ImagePicker imagePicker =
                                              ImagePicker();
                                          pickedXFile =
                                              await imagePicker.pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 30,
                                            preferredCameraDevice:
                                                CameraDevice.rear,
                                          );
                                          if (pickedXFile != null) {
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // User Info Section
                              Text(
                                '${profileData.firstName ?? ""} ${profileData.lastName ?? ""}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.email, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      profileData.email ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Actions Card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildActionButton(
                                icon: Icons.edit,
                                label: 'Update Profile',
                                color: Colors.blue,
                                onPressed: () async {
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
                                  if (result != null &&
                                      result is Map<String, String>) {
                                    await loadUserData();
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildActionButton(
                                icon: Icons.lock_reset,
                                label: 'Reset Password',
                                color: Colors.green,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetPasswordScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildActionButton(
                                icon: Icons.shopping_cart,
                                label: 'Buy Packages',
                                color: Colors.purple,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const InvoiceBillingScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildActionButton(
                                icon: Icons.logout,
                                label: 'Logout',
                                color: Colors.red,
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  await AuthService.logout();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
