import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/mysql_database_helper.dart';
import '../utils/password_hasher.dart';
import '../utils/database_exception.dart';
import '../utils/validators.dart';  // Add this import
import '../utils/shared_prefs.dart';  // Add this import

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final MySqlDatabaseHelper dbHelper = MySqlDatabaseHelper();
  bool isLoading = false;
  bool rememberMe = false;

  Future<void> handleLogin() async {
    setState(() => isLoading = true);

    if (!Validators.isValidEmail(emailController.text.trim())) {
      showMessage('Please enter a valid email address', Colors.red);
      setState(() => isLoading = false);
      return;
    }

    try {
      final userData = await dbHelper.loginUser(
        emailController.text.trim(),
        passwordController.text,
      );

      if (userData == null) {
        throw 'Invalid email or password';
      }

      // Save user session
      await SharedPrefs.saveUserSession(userData);

      if (mounted) {
        // Navigate to dashboard and remove login from navigation stack
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
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
                        color: Colors.pinkAccent, // Changed from blue to pinkAccent
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Sign in',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Enter your credentials to continue',
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
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelStyle: TextStyle(color: Colors.pinkAccent), // Added pink accent color
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.pinkAccent), // Added pink accent color
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
                          
                          // Remember Me Switch
                          Row(
                            children: [
                              Switch(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() => rememberMe = value);
                                },
                                activeColor: Colors.pinkAccent, // Added pink accent color
                              ),
                              Text(
                                'Remember me',
                                style: TextStyle(color: Colors.grey), // Changed to gray color
                              ),
                            ],
                          ),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent, // Changed from blue to pinkAccent
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6), // Changed to match welcome page
                                ),
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text('Sign in',
                                      style: TextStyle(fontSize: 16)),
                            ),
                          ),

                          // Additional Links
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.pinkAccent, // Added pink accent color
                            ),
                            child: Text('Forgot your password?'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey), // Changed to gray color
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.pinkAccent, // Added pink accent color
                                ),
                                child: Text('Sign up'),
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
