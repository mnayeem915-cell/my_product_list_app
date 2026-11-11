import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:url_strategy/url_strategy.dart';

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
import 'providers/shop_provider.dart';
import 'providers/admin_provider.dart';

// স্ক্রিন ইম্পোর্ট
import 'screens/main_screen.dart';
import 'web/customer/customer_web_screen.dart';
import 'web/vendor/vendor_dashboard_screen.dart';
import 'web/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    setPathUrlStrategy();
  }

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
        ChangeNotifierProvider(create: (_) => AuthProvider()), // অ্যাপ চালু হলেই AuthProvider তৈরি হবে
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settings.languageCode),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // 👇 এখানে Consumer ব্যবহার করেছি, যা AuthProvider-এর রোল চেঞ্জ অটোমেটিক ধরে নেবে
      home: kIsWeb
          ? Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // ১. লগইন না থাকলে কাস্টমার পেজ
          if (!authProvider.isLoggedIn) {
            return const CustomerWebScreen();
          }

          // ২. রোল অনুযায়ী পেজ
          if (authProvider.userRole == 'admin') {
            return const AdminDashboardScreen();
          } else if (authProvider.userRole == 'vendor') {
            return const VendorDashboardScreen();
          } else {
            return const CustomerWebScreen();
          }
        },
      )
          : const MainScreen(), // মোবাইল অ্যাপ

      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/shop/')) {
          final shopName = settings.name!.replaceFirst('/shop/', '');
          return MaterialPageRoute(
            builder: (context) => CustomerWebScreen(initialShopName: shopName),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}