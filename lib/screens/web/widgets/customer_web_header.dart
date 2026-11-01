import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/category_provider.dart'; // ক্যাটাগরির জন্য
import '../login_web_screen.dart';

class CustomerWebHeader extends StatelessWidget {
  const CustomerWebHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Column(
      children: [
        // ==========================================
        // ১. উপরের অংশ (লোগো, সার্চ, আইকন)
        // ==========================================
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          child: Row(
            children: [
              // লোগো
              Row(
                children: [
                  Icon(Icons.shopping_bag, color: Theme.of(context).primaryColor, size: 40),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Shop',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 26, height: 1),
                      ),
                      const Text('Premium Grocery', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 60),

              // সার্চ বার (গোলাকার)
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(25), // গোলাকার
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search in...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),

              // ডান দিকের আইকনগুলো (Track Order, Sign In, Wishlist, Cart, More)
              _buildHeaderIcon(Icons.location_on_outlined, 'Track Order', () {}),

              // লগইন/লগআউট
              if (authProvider.isLoggedIn)
                _buildHeaderIcon(Icons.person, 'Logout', () async => await authProvider.logout())
              else
                _buildHeaderIcon(Icons.person_outline, 'Sign In', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginWebScreen()));
                }),

              _buildHeaderIcon(Icons.favorite_border, 'Wishlist', () {}),
              _buildHeaderIcon(Icons.shopping_cart_outlined, 'Cart', () {}),
              _buildHeaderIcon(Icons.menu, 'More', () {}),
            ],
          ),
        ),

        // ==========================================
        // ২. নিচের অংশ (ক্যাটাগরি মেনু বার)
        // ==========================================
        Container(
          color: const Color(0xFF2E2E2E), // গাঢ় ধূসর/কালো (ঘরের বাজার স্টাইল)
          height: 50,
          child: categoryProvider.categories.isEmpty
              ? const Center(child: Text('Loading Categories...', style: TextStyle(color: Colors.white)))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Text(
                    categoryProvider.categories[index].name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // আইকন এবং টেক্সট তৈরি করার হেল্পার ফাংশন
  Widget _buildHeaderIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black87, size: 24),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}