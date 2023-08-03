import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Authentication/loginpage.dart';
import 'package:google_fonts/google_fonts.dart';

class Registerpage extends StatefulWidget {
  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final namecontroller = TextEditingController();
  final mobileNocontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  bool isLoading = false; // To track whether registration is in progress

  @override
  void dispose() {
    namecontroller.dispose();
    mobileNocontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();

    super.dispose();
  }

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
                    const SizedBox(height: 25),
                    Text(
                      'Create Account !',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 40,
                      ),
                    ),
                    const Text(
                      'Register Below with your details',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: namecontroller,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: 'Name'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: mobileNocontroller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Mobile No'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: emailcontroller,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: 'Email'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            obscureText: true,
                            controller: passwordcontroller,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: 'Password'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: confirmpasswordcontroller,
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Confirm Password'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: () {
                          registerAccount(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple[300],
                              borderRadius: BorderRadius.circular(12)),
                          child: const Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Do you already have an account?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginpage()),
                            );
                          },
                          child: const Text(
                            "Login Page",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            // Show circular progress indicator when isLoading is true
            if (isLoading)
              Container(
                color: Colors.black45, // Semi-transparent background
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple[300],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void registerAccount(BuildContext context) async {
    final String name = namecontroller.text.trim();
    final String mobileNo = mobileNocontroller.text.trim();
    final String email = emailcontroller.text.trim();
    final String password = passwordcontroller.text;
    final String confirmPassword = confirmpasswordcontroller.text;

    if (password != confirmPassword) {
      // Passwords don't match, show a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match."),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // Register the user with email and password using Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Additional step: Update the user's display name (optional)
      await userCredential.user!.updateDisplayName(name);

      // Save user data to Firestore
      await saveUserDataToFirestore(name, mobileNo, email);

      // If registration is successful, show a SnackBar and navigate back to the login page.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Account registered successfully."),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginpage()),
      );
    } catch (e) {
      // Handle registration errors and show a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed. Error: $e"),
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> saveUserDataToFirestore(
      String name, String mobileNo, String email) async {
    try {
      // Get the reference to the Firestore collection for users
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Create a new document with the user's email as the document ID
      await usersCollection.doc(email).set({
        'name': name,
        'mobileNo': mobileNo,
        'email': email,
        // Add more fields if needed
      });
    } catch (e) {
      print("Account already taken try different:");
    }
  }
}
