import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sidebar.dart';
import '../widgets/stats_card.dart';
import '../widgets/sales_chart.dart';
import '../config/app_theme.dart';
import '../models/user.dart';
import '../helpers/mysql_database_helper.dart';
import '../utils/shared_prefs.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final dbHelper = MySqlDatabaseHelper();
  User? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<int?> getUserIdFromStorage() async {
    return await SharedPrefs.getUserId();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = await getUserIdFromStorage();
      if (userId == null) {
        // No stored user ID, redirect to login
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
        return;
      }

      final userData = await dbHelper.getUserById(userId);
      if (userData != null) {
        setState(() {
          currentUser = User.fromJson(userData);
          isLoading = false;
        });
      } else {
        // User not found in database, clear session and redirect to login
        await SharedPrefs.clearUserSession();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Row(
        children: [
          SideBar(
            userName: currentUser?.name ?? 'User',
            userRole: currentUser?.role ?? 'Guest',
            onLogout: () async {
              try {
                await dbHelper.logoutUser(); // Implement this method
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              } catch (e) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            },
          ),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Navbar
                buildNavBar(),
                
                // Dashboard Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: StatsCard(
                                title: 'Total Sales',
                                value: '₱125,000.00',
                                percentage: '+55%',
                                icon: Icons.attach_money,
                                iconColor: AppTheme.primary,
                                backgroundColor: AppTheme.primary.withOpacity(0.1),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatsCard(
                                title: 'Total Inventory',
                                value: '1,234',
                                percentage: '-2%',
                                icon: Icons.inventory,
                                iconColor: AppTheme.secondary,
                                backgroundColor: AppTheme.secondary.withOpacity(0.1),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatsCard(
                                title: 'Total Expenses',
                                value: '₱45,000.00',
                                percentage: '-3%',
                                icon: Icons.receipt,
                                iconColor: AppTheme.accent,
                                backgroundColor: AppTheme.accent.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Charts Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sales Chart
                            Expanded(
                              flex: 2,
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Sales Overview',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {},
                                            icon: const Icon(Icons.add),
                                            label: const Text('Add Sale'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: 300,
                                        child: SalesChart(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            
                            // Stock Alerts
                            Expanded(
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Stock Alerts',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.qr_code_scanner),
                                          ),
                                        ],
                                      ),
                                      // Add stock alerts list here
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Add navbar items (search, notifications, profile) here
        ],
      ),
    );
  }
}