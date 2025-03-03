import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/dashboard_screen.dart';
import 'utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check for existing session
  final hasSession = await SharedPrefs.hasActiveSession();
  
  runApp(SmartStoreApp(initialRoute: hasSession ? '/dashboard' : '/'));
}

class SmartStoreApp extends StatelessWidget {
  final String initialRoute;
  
  const SmartStoreApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE91E63),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE91E63),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) =>  WelcomePage(),
        '/login': (context) =>  LoginScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/dashboard': (context) =>  DashboardScreen(),
      },
    );
  }
}
