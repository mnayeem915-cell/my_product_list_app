import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// নতুন ইমপোর্ট
import 'l10n/translations/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart'; // নতুন ইমপোর্ট

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    ChangeNotifierProvider.value(
      value: settingsProvider,
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
      home: const HomeScreen(), // এখানে পরিবর্তন করো
    );
  }
}

