import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://images.unsplash.com/photo-1497294815431-9365093b7331?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1950&q=80"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(179),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🏪 App Icon
                Icon(
                  Icons.storefront,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),

                // 📢 Welcome Text (Styled Like Laravel)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "Welcome to SmartStore",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Effortlessly manage inventory, track sales, and optimize your store's performance",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 📋 Feature Cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFeatureCard(
                    icon: Icons.inventory,
                    title: "Inventory Management",
                    description: "Track your stock levels in real-time",
                    ),
                    const SizedBox(width: 10),
                    _buildFeatureCard(
                    icon: Icons.analytics,
                    title: "Sales Analytics",
                    description: "Monitor your business performance",
                    ),
                  ],
                  ),
                ),
                const SizedBox(height: 30),

                // 🔐 Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(Icons.login, "Login", Colors.pinkAccent, () {
                      Navigator.pushNamed(context, '/login');
                    }),
                    const SizedBox(width: 10),
                    _buildButton(Icons.person_add, "Register", Colors.grey[800]!, () {
                      Navigator.pushNamed(context, '/register');
                    }),
                  ],
                ),
                const SizedBox(height: 20),

                // 📌 Footer
                const Text(
                  "© 2025, SmartStore. All rights reserved.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Feature Card Widget
  Widget _buildFeatureCard({required IconData icon, required String title, required String description}) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.9 * 255).toInt()),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).toInt()),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 40),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 5),
          Text(description, textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }

  // 🔹 Button Widget
  Widget _buildButton(IconData icon, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onPressed: onPressed,
    );
  }
}
