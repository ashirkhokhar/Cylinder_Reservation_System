// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_panel/adminpanel.dart';
import 'package:google_fonts/google_fonts.dart';

class adminlogin extends StatefulWidget {
  adminlogin({super.key});

  @override
  _adminloginState createState() => _adminloginState();
}

class _adminloginState extends State<adminlogin> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _showPassword = false; // Track the visibility of the password
  bool _isLoading = false; // To track whether login is in progress

  // Predefined username and password
  final String predefinedUsername = "superadmin";
  final String predefinedPassword = "admin123";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //const SizedBox(height: 25),
                    const SizedBox(height: 30),
                    Text(
                      'Welcome  Admin !',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 40,
                      ),
                    ),
                    const Text(
                      'Login to Proceed !',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: emailcontroller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'username',
                                suffixIcon: Icon(
                                  Icons.admin_panel_settings,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                    ),
                    //const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: passwordcontroller,
                            obscureText:
                                !_showPassword, // Toggle password visibility
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'password',
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                  child: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: () {
                          // Check if entered credentials match predefined values
                          if (emailcontroller.text.trim() ==
                                  predefinedUsername &&
                              passwordcontroller.text.trim() ==
                                  predefinedPassword) {
                            // Simulate a loading state
                            setState(() {
                              _isLoading = true;
                            });

                            // Simulate a delay to demonstrate loading state
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                _isLoading = false;
                              });

                              // TODO: Perform navigation or other actions upon successful login

                              // Example: Navigating to a new screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AdminPanel()),
                              );
                            });
                          } else {
                            showSnackBar(context, "Invalid credentials");
                          }
                        },
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ),
            // Show circular progress indicator when _isLoading is true
            if (_isLoading)
              Container(
                color: Colors.black45, // Semi-transparent background
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
