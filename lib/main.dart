import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // নতুন ইম্পোর্ট
import 'l10n/translations/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/category_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/main_screen.dart';
import 'providers/product_provider.dart';
import 'providers/banner_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase ইনিশিয়ালাইজ করা
  await Supabase.initialize(
    url: 'https://mwjgomchnayflyyjmqgc.supabase.co', // 👈 এখানে তোমার Project URL বসাও
    anonKey: 'sb_publishable_mJR3mwsyCLH8iLd0P3qPUQ_BUrBfefr', // 👈 এখানে তোমার anon key বসাও
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
      home: const MainScreen(),
    );
  }
}