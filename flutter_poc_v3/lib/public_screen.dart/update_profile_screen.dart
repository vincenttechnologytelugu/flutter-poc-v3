
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  const UpdateProfileScreen({
    required this.firstName,
    required this.lastName,
    required this.email,
    super.key,
  });

  @override
  UpdateProfileScreenState createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> updateProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      log('No token found');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.179:8080/authentication/auth_user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
        
        }),
      );

      if (response.statusCode == 200) {
        log('Profile updated successfully');

        // Save updated data to SharedPreferences
        await prefs.setString('first_name', firstNameController.text);
        await prefs.setString('last_name', lastNameController.text);
        await prefs.setString('email', emailController.text);
     

        // Navigate back to ProfileScreen with updated data
        if (!mounted) return;
        Navigator.pop(context, {
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
        
      
          
        });
      } else {
        log('Failed to update profile: ${response.body}');
        if (!mounted) return;
        showDialog(
          
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to update profile. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      log('Error updating profile: $e');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              const SizedBox(height: 8),
              
        
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateProfileDetails,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UpdateProfileScreen extends StatefulWidget {
//   final String firstName;
//   final String lastName;
//   final String email;

//   const UpdateProfileScreen({
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     super.key,
//   });

//   @override
//   UpdateProfileScreenState createState() => UpdateProfileScreenState();
// }

// class UpdateProfileScreenState extends State<UpdateProfileScreen> {
//   late TextEditingController firstNameController;
//   late TextEditingController lastNameController;
//   late TextEditingController emailController;

//   @override
//   void initState() {
//     super.initState();
//     firstNameController = TextEditingController(text: widget.firstName);
//     lastNameController = TextEditingController(text: widget.lastName);
//     emailController = TextEditingController(text: widget.email);
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     // emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Update Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: firstNameController,
//               decoration: const InputDecoration(labelText: 'First Name'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: lastNameController,
//               decoration: const InputDecoration(labelText: 'Last Name'),
//             ),
//             const SizedBox(height: 8),
//             // TextField(
//             //   controller: emailController,
//             //   decoration: const InputDecoration(labelText: 'Email'),
//             // ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 final prefs = await SharedPreferences.getInstance();

//                 // Save updated data to SharedPreferences
//                 await prefs.setString('first_name', firstNameController.text);
//                 await prefs.setString('last_name', lastNameController.text);
//                 // await prefs.setString('email', emailController.text);
//                 // Return updated data to ProfileScreen
//                 Navigator.pop(context, {
//                   'firstName': firstNameController.text,
//                   'lastName': lastNameController.text,
//                   'email': emailController.text,
//                 });
//               },
//               child: const Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


