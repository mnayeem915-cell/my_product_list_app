import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'menu_screen.dart';
import 'search_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // এখানে ৫টি পেজের লিস্ট দেওয়া হলো
  final List<Widget> _pages = [
    const HomeScreen(),
    const MenuScreen(),     // ক্যাটাগরি মেনু
    const SearchScreen(),   // সার্চ স্ক্রিন
    const CartScreen(),     // কার্ট স্ক্রিন
    const ProfileScreen(),  // প্রোফাইল স্ক্রিন
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // বডিতে বর্তমানে সিলেক্ট করা পেজটি দেখাবে
      body: _pages[_currentIndex],

      // নিচের নেভিগেশন বার
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}