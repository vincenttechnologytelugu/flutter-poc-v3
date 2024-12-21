import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/main.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:flutter_poc_v3/services/api_services.dart';
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
  SizedBox textFieldDefaultGap = const SizedBox(height: 16);
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
        Uri.parse("http://192.168.96.1:8080/authentication/register"),
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
        Navigator.pop(context);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Changed from 'token' to 'session'
        final token = responseData['session'];
        if (token != null && token.toString().isNotEmpty) {
          // Save token and user data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          // Save user data from the 'data' object
          if (responseData['data'] != null) {
            await prefs.setString(
                'first_name', responseData['data']['first_name']);
            await prefs.setString(
                'last_name', responseData['data']['last_name']);
            await prefs.setString('email', responseData['data']['email']);
          }

          // Show success message
          Fluttertoast.showToast(
            msg: responseData['message'] ?? "Registration successful!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
          );

          // Navigate to home screen
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
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
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await ApiService.register(
         firstNameController.text,
          lastNameController.text,
        emailController.text,
        passwordController.text
      );

      if (mounted) {
        Fluttertoast.showToast(
          msg: "Registration successful!",
          backgroundColor: Colors.green,
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

 
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Image.asset("assets/images/Register.jpg",
             
                width: 250,
                ),
                // CachedNetworkImage(
                //   height: 150,
                //   imageUrl:
                //       "https://img.favpng.com/4/22/14/logo-brand-button-icon-png-favpng-6vjJ5T7t7zrXkhnpPQ80mB7mt.jpg",
                //   placeholder: (context, url) => CircularProgressIndicator(),
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // ),
                Text(
                  "Welcome to The App\n Create your Account",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
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
                      hintText: "Lirst_name",
                      label: Text("First_name"),
                      prefixIcon: Icon(Icons.person_2_outlined),
                      counterText: "",
                      border: OutlineInputBorder()),
                ),
                textFieldDefaultGap,
                TextFormField(
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
                      label: Text("Last_name"),
                      prefixIcon: Icon(Icons.person_2_outlined),
                      counterText: "",
                      border: OutlineInputBorder()),
                ),
                textFieldDefaultGap,
                TextFormField(
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
                    log("emailValid ${emailValid}");
                    if (value == null || value.isEmpty) {
                      return "Please enter email address";
                    } else if (!emailValid) {
                      return "Please enter valid email address";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "Enter Email",
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email_outlined),
                      counterText: "",
                      border: OutlineInputBorder()),
                ),
                textFieldDefaultGap,
                TextFormField(
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
                      label: const Text("Password"),
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            vissiblePassword = !vissiblePassword;
                            setState(() {});
                          },
                          child: Icon(vissiblePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined)),
                      counterText: "",
                      border: const OutlineInputBorder()),
                ),
                textFieldDefaultGap,
                ElevatedButton(
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
                    child: const Text("Register")),
                TextButton(
                    onPressed: () {
                      firstNameController.clear();
                      lastNameController.clear();
                      emailController.clear();
                      passwordController.clear();
                    },
                    child: Text(
                      "Clear",
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const LoginScreen()));
                    },
                    child: const Text(
                      "Already have an Account",
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
