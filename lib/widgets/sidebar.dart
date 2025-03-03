import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/app_theme.dart';

class SideBar extends StatelessWidget {
  final String userName;
  final String userRole;
  final VoidCallback onLogout;

  const SideBar({
    Key? key,
    required this.userName,
    required this.userRole,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          // Logo Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.store, color: Colors.black),
                const SizedBox(width: 12),
                Text(
                  'SmartStore',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNavItem(
                  icon: FontAwesomeIcons.gaugeHigh,
                  label: 'Dashboard',
                  isSelected: true,
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.boxesStacked,
                  label: 'Products',
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.cartShopping,
                  label: 'Sales',
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.moneyBill,
                  label: 'Expenses',
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.bell,
                  label: 'Stock Alerts',
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.chartLine,
                  label: 'Reports',
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.users,
                  label: 'Users',
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          // User Profile Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primary,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userRole,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_outline),
                          SizedBox(width: 8),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'logout') {
                      onLogout();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: FaIcon(
        icon,
        color: isSelected ? Colors.blue : Colors.grey[600],
        size: 20,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: onTap,
    );
  }
}