import 'package:flutter/material.dart';

class WebSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onLogout;

  const WebSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF1E293B), // ডার্ক নেভি ব্লু
      child: Column(
        children: [
          const SizedBox(height: 30),
          // লোগো
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag, color: Colors.orange, size: 30),
              const SizedBox(width: 8),
              const Text(
                'My Shop',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // মেনু আইটেম
          _buildSidebarItem(Icons.dashboard, 'Dashboard', 0, selectedIndex, onItemSelected),
          _buildSidebarItem(Icons.shopping_bag_outlined, 'Products', 1, selectedIndex, onItemSelected),
          _buildSidebarItem(Icons.receipt_long, 'Orders', 2, selectedIndex, onItemSelected),
          _buildSidebarItem(Icons.people, 'Customers', 3, selectedIndex, onItemSelected),
          _buildSidebarItem(Icons.settings, 'Settings', 4, selectedIndex, onItemSelected),

          const Spacer(),
          // লগআউট বাটন
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: onLogout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index, int selectedIndex, Function(int) onItemSelected) {
    final isSelected = index == selectedIndex;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.orange : Colors.grey.shade400),
        title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade400)),
        onTap: () => onItemSelected(index),
      ),
    );
  }
}