import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../helpers/mysql_database_helper.dart';  // Changed from screens/helpers
import '../utils/password_hasher.dart';         // Changed from screens/utils
import '../utils/database_exception.dart';       // Changed from screens/utils

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController(); // Added email controller
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final MySqlDatabaseHelper dbHelper = MySqlDatabaseHelper();
  bool isLoading = false;

  Future<void> handleRegister() async {
    setState(() => isLoading = true);
    try {
      String username = usernameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text;
      
      String hashedPassword = PasswordHasher.hashPassword(password);
      
      // Make sure dbHelper.registerUser returns a bool
      await dbHelper.registerUser(username, hashedPassword, email); // Remove bool assignment if registerUser returns void
      
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1497294815431-9365093b7331?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1950&q=80'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withAlpha(179), // Match welcome page opacity
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Navbar
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                Icon(Icons.store, color: Colors.white),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/welcome');
                  },
                  child: Text(
                    'SmartStore',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Center(
            child: Container(
              width: 400,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Card Header
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent, // Changed from blueAccent to pinkAccent
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Register',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Create your account to continue',
                            style: GoogleFonts.roboto(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelStyle: TextStyle(color: Colors.pinkAccent), // Changed from blueAccent to pinkAccent
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.pinkAccent), // Changed from blueAccent to pinkAccent
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: emailController, // Added email field
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelStyle: TextStyle(color: Colors.pinkAccent), // Changed from blueAccent to pinkAccent
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.pinkAccent), // Changed from blueAccent to pinkAccent
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent, // Changed from blueAccent to pinkAccent
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6), // Changed to match welcome page
                                ),
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text('Register',
                                      style: TextStyle(fontSize: 16)),
                            ),
                          ),

                          // Additional Links
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(color: Colors.grey), // Changed to gray color
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.pinkAccent, // Changed from blueAccent to pinkAccent
                                ),
                                child: Text('Sign in'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Footer
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              '© 2025 SmartStore. All rights reserved.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
