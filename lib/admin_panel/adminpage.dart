import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'adminpanel.dart';

class adminlogin extends StatefulWidget {
  @override
  State<adminlogin> createState() => _adminloginState();
}

class _adminloginState extends State<adminlogin> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _showPassword = false; // Track the visibility of the password
  bool _isLoading = false; // To track whether login is in progress

  // Predefined username and password
  final String predefinedUsername = "admin@gmail.com";
  final String predefinedPassword = "admin123";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.deepPurple[300]!,
          Colors.deepPurple[400]!,
          Colors.deepPurple[700]!,
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "A d m i n   L o g i n",
                    style: GoogleFonts.bebasNeue(
                      color: Colors.white,
                      fontSize: 40,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome Admin ! ",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color:
                                          Color.fromRGBO(167, 165, 163, 0.286),
                                      blurRadius: 20,
                                      offset: Offset(1, 10))
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                  ),
                                  child: TextField(
                                    controller: emailcontroller,
                                    decoration: InputDecoration(
                                        hintText: "Username",
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.grey,
                                        ),
                                        border: InputBorder.none,
                                        suffixIcon: const Icon(
                                          Icons.admin_panel_settings,
                                          color: Colors.deepPurple,
                                        )),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                  ),
                                  child: TextField(
                                    controller: passwordcontroller,
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: GoogleFonts.poppins(
                                            color: Colors.grey),
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
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        border: InputBorder.none),
                                    obscureText: !_showPassword,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Check if entered credentials match predefined values
                            if (!_isLoading &&
                                emailcontroller.text.trim() ==
                                    predefinedUsername &&
                                passwordcontroller.text.trim() ==
                                    predefinedPassword) {
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
                                    builder: (context) => AdminPanel(),
                                  ),
                                );
                              });
                            } else {
                              showSnackBar(
                                context,
                                "Invalid credentials",
                              );
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.deepPurple[300]),
                            child: Center(
                              child: _isLoading
                                  ? Container(
                                      width: 24, // Adjust the size as needed
                                      height: 24, // Adjust the size as needed
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
