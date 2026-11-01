import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart'; // kIsWeb এর জন্য

import 'l10n/translations/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/category_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/product_provider.dart';
import 'providers/banner_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'screens/main_screen.dart';
import 'screens/web/customer/customer_web_screen.dart';
import 'screens/web/vendor/vendor_dashboard_screen.dart'; // ভেন্ডর ড্যাশবোর্ডের পাথ

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mwjgomchnayflyyjmqgc.supabase.co',
    anonKey: 'sb_publishable_mJR3mwsyCLH8iLd0P3qPUQ_BUrBfefr',
  );

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settings.languageCode),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // এখানে কন্ডিশন দেওয়া হলো কে কোন স্ক্রিন দেখবে
      home: kIsWeb
          ? (authProvider.isLoggedIn
          ? (authProvider.userRole == 'vendor'
          ? const VendorDashboardScreen()
          : const CustomerWebScreen())
          : const CustomerWebScreen()) // লগইন না থাকলে কাস্টমার ওয়েব
          : const MainScreen(), // মোবাইলে কাস্টমার অ্যাপ
    );
  }
}