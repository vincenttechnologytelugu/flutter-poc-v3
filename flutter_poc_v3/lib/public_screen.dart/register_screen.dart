import 'package:flutter/material.dart';

import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';

import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  SizedBox textFieldDefaultGap = const SizedBox(height: 10);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool vissiblePassword = true;
  bool sanitizeAndCheckEmailAndPassword(String email, String password) {
    // Email validation
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    // Password validation
    bool passwordValid =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(password);

    return emailValid && passwordValid;
  }

  // void handleDummyRegister() {
  //   if (_formKey.currentState!.validate()) {
  //     final firstName = firstNameController.text.trim();
  //     final lastName = lastNameController.text.trim();
  //     final email = emailController.text.trim();
  //     final password = passwordController.text.trim();

  //     // Show success message
  //     Fluttertoast.showToast(
  //       msg: "Registration successful!",
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //     );

  //     // Navigate to home screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomeScreen()),
  //     );
  //   }
  // }


  

  bool isLoading = false;
// function to register to user
  Future<void> registerUser(
      String firstName, String lastName, String email, String password) async {
    try {
      if (!sanitizeAndCheckEmailAndPassword(email, password)) {
        throw Exception('Invalid email or password format');
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final response = await http.post(
        Uri.parse("http://192.168.0.179:8080/authentication/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        }),
      );

      // Add these debug logs
      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');
      log('Response Headers: ${response.headers}');

      // Hide loading indicator
      if (context.mounted) {
        if (!mounted) return;
        Navigator.pop(context);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Initialize prefs before using it
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        // Save user data immediately after successful registration
        await prefs.setString('first_name', firstNameController.text.trim());
        await prefs.setString('last_name', lastNameController.text.trim());
        await prefs.setString('email', emailController.text.trim());

        // Debug log to verify data is saved
        log('User data saved after registration:');
        log('first_name: ${prefs.getString('first_name')}');
        log('last_name: ${prefs.getString('last_name')}');
        log('email: ${prefs.getString('email')}');

        // Changed from 'token' to 'session'
        final token = responseData['session'];
        if (token != null && token.toString().isNotEmpty) {
          // Save token and user data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          // In registration
          log('Saved user data: ${firstNameController.text}, ${lastNameController.text}, ${emailController.text}');

// In profile loading
          log('Loaded user data: $firstName, $lastName, $email');

          // Save user data - Add these lines
          await prefs.setString('first_name', firstName);
          await prefs.setString('last_name', lastName);
          await prefs.setString('email', email);

// Debug log after saving
          log('Verification - Saved data:');
          log('first_name: ${prefs.getString('first_name')}');
          log('last_name: ${prefs.getString('last_name')}');
          log('email: ${prefs.getString('email')}');
          // Save user data from the 'data' object
          if (responseData['data'] != null) {
            await prefs.setString(
                'first_name', responseData['data']['first_name']);
            await prefs.setString(
                'last_name', responseData['data']['last_name']);
            await prefs.setString('email', responseData['data']['email']);
          }
          // Add after saving data
          log('Saved user data - First Name: ${prefs.getString('first_name')}');
          log('Saved user data - Last Name: ${prefs.getString('last_name')}');
          log('Saved user data - Email: ${prefs.getString('email')}');

          // Show success message
          Fluttertoast.showToast(
            msg: responseData['message'] ?? "Registration successful!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
          );

          // Navigate to home screen
          if (context.mounted) {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else {
          throw Exception('Session token not received from server');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      // Hide loading indicator if it's still showing
      if (context.mounted) {
        if (!mounted) return;
        Navigator.pop(context);
      }

      // Show error message
      Fluttertoast.showToast(
        msg: "Error during registration: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );

      log('Error during registration: $e');
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Future<void> _register() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() => isLoading = true);

  //   try {
  //     // Get the response from ApiService
  //     final responseData = await ApiService.register(
  //         firstNameController.text,
  //         lastNameController.text,
  //         emailController.text,
  //         passwordController.text);

  //          final prefs = await SharedPreferences.getInstance();
  //            // Add this after successful registration
  //   await prefs.setString('first_name', firstNameController.text);
  //   await prefs.setString('last_name', lastNameController.text);
  //   await prefs.setString('email', emailController.text);

  //     // Save user data to SharedPreferences
  //     // final prefs = await SharedPreferences.getInstance();
  //     if (responseData['data'] != null) {
  //       await prefs.setString('first_name', responseData['data']['first_name']);
  //       await prefs.setString('last_name', responseData['data']['last_name']);
  //       await prefs.setString('email', responseData['data']['email']);
  //     }

  //     if (mounted) {
  //       Fluttertoast.showToast(
  //         msg: "Registration successful!",
  //         backgroundColor: Colors.green,
  //       );

  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const HomeScreen()),
  //       );
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: e.toString(),
  //       backgroundColor: Colors.red,
  //     );
  //   } finally {
  //     if (mounted) {
  //       setState(() => isLoading = false);
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      // appBar: AppBar(
      //   title: const Text("Register"),
      //   backgroundColor: Colors.blue,
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // Color(0xffb81736), // Blue shade
                  // Color(0xff281537), // Lighter blue shade
                  Color.fromARGB(255, 129, 209, 201), // Blue shade
                  Color.fromARGB(255, 139, 1, 245), // Lighter blue shade
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      // Image.asset(
                      //   "assets/images/Register.jpg",
                      //   width: 250,
                      // ),
                      // CachedNetworkImage(
                      //   height: 150,
                      //   imageUrl:
                      //       "https://img.favpng.com/4/22/14/logo-brand-button-icon-png-favpng-6vjJ5T7t7zrXkhnpPQ80mB7mt.jpg",
                      //   placeholder: (context, url) => CircularProgressIndicator(),
                      //   errorWidget: (context, url, error) => Icon(Icons.error),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60, left: 20),
                        child: Text("Welcome\nCreate your Account",
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
                      ),
                      textFieldDefaultGap,
                      textFieldDefaultGap,
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        controller: firstNameController,
                        onChanged: (value) {
                          log("value:$value");
                          _formKey.currentState!.validate();
                        },
                        maxLength: 100,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your first name";
                          } else if (value.length < 2) {
                            return 'First name must be at least 2 characters';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "First_name",
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          label: Text(
                            "First_name",
                            style: TextStyle(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: Colors.white,
                          ),
                          counterText: "",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        cursorRadius: Radius.circular(10),
                      ),
                      textFieldDefaultGap,
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        cursorRadius: Radius.circular(10),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        controller: lastNameController,
                        onChanged: (value) {
                          log("value:$value");
                          _formKey.currentState!.validate();
                        },
                        maxLength: 100,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your last name";
                          } else if (value.length < 2) {
                            return 'Last name must be at least 2 characters';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Last_name",
                          label: Text(
                            "Last_name",
                            style: TextStyle(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: Colors.white,
                          ),
                          counterText: "",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                      ),
                      textFieldDefaultGap,
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        cursorRadius: Radius.circular(10),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        controller: emailController,
                        onChanged: (value) {
                          log("value:$value");
                          _formKey.currentState!.validate();
                        },
                        maxLength: 100,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value ?? "");
                          log("emailValid $emailValid");
                          if (value == null || value.isEmpty) {
                            return "Please enter email address";
                          } else if (!emailValid) {
                            return "Please enter valid email address";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter Email",
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          label: Text(
                            "Email",
                            style: TextStyle(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                          counterText: "",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          errorBorder: OutlineInputBorder(
                              // Add this for error state
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 244, 242, 248),
                                  width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          focusedErrorBorder: OutlineInputBorder(
                            // Add this for focused error state
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 239, 239, 244),
                                width: 2.0),
                          ),
                          // errorStyle: TextStyle(
                          //     color: Color.fromARGB(255, 255, 255, 255)
                          //     ),
                        ),
                      ),
                      textFieldDefaultGap,
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        cursorRadius: Radius.circular(10),
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        controller: passwordController,
                        onChanged: (value) {
                          log("value:$value");
                          _formKey.currentState!.validate();
                        },
                        validator: (value) {
                          bool validateStructure(String value) {
                            String pattern =
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                            RegExp regExp = RegExp(pattern);
                            return regExp.hasMatch(value);
                          }

                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          } else if (value.length < 8) {
                            return "Password must be at least 8 characters";
                          } else if (!validateStructure(value)) {
                            return """Password must contain:
                          • At least one uppercase letter
                          • At least one lowercase letter  
                          • At least one number
                          • At least one special character (!@#\$&*~)
                          • Minimum 8 characters""";
                          }
                          return null;
                        },
                        maxLength: 100,
                        keyboardType: TextInputType.text,
                        obscureText: vissiblePassword,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Password",
                            style: TextStyle(color: Colors.white),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.password_outlined,
                            color: Colors.white,
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                vissiblePassword = !vissiblePassword;
                                setState(() {});
                              },
                              child: Icon(
                                vissiblePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.white,
                              )),
                          counterText: "",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 250, 248, 248),
                                  width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 245, 242, 242),
                                  width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                      ),
                      textFieldDefaultGap,

                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => const LoginScreen()));
                            },
                            child: const Text(
                              "Already have an Account",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 8, 19, 238)),
                            )),
                      ),
                      textFieldDefaultGap,

    //                   ElevatedButton(
    //                     style: ElevatedButton.styleFrom(
    //                         backgroundColor:
    //                             const Color.fromARGB(255, 219, 9, 205),
    //                         shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(15))),
    //                     onPressed: () {
    //                       // Comment out your API call logic
    //                       /*
    // Your existing API call code here
    // */

    //                       // Call dummy register instead
    //                       handleDummyRegister();
    //                     },
    //                     child: const Text("Register"),
    //                   ),

                      ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 219, 9, 205),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final firstName = firstNameController.text.trim();
                              final lastName = lastNameController.text.trim();
                              final email = emailController.text.trim();
                              final password = passwordController.text;

                              // Call the API
                              log('first_name: $firstName');
                              log('last_name: $lastName');
                              log('email: $email');
                              log('password: $password');
                              await registerUser(
                                  firstName, lastName, email, password);
                            }
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 580),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
