import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFF57C00);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    primaryColor: primaryOrange,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF9F9F9),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    cardColor: Colors.white,
    useMaterial3: true,

    // 👇 এখানে Bottom Navigation Bar এর ডিফল্ট সেটিংস দিয়ে দিলাম
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryOrange,
      unselectedItemColor: Colors.black87,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    primaryColor: primaryOrange,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF1E1E1E),
    useMaterial3: true,

    // 👇 ডার্ক মোডে Bottom Navigation Bar এর সেটিংস
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: primaryOrange,
      unselectedItemColor: Colors.white70, // ডার্ক মোডে আনসিলেক্ট আইকন সাদা হবে
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
  );
}