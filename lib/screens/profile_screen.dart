import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/translations/app_localizations.dart';
import 'wishlist_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ১. উপরের সুন্দর হেডার (Ghorer Bazar স্টাইল)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hello there!',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sign in to get the best experience',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // ২. অ্যাপ সেটিংস (থিম ও ভাষা)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        // ডার্ক মোড সুইচ
                        SwitchListTile(
                          title: const Text('Dark Mode'),
                          subtitle: const Text('Toggle between light and dark theme'),
                          value: settings.isDarkMode,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            settings.toggleTheme();
                          },
                        ),
                        const Divider(height: 1),
                        // ভাষা পরিবর্তন
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: const Text('Language'),
                          subtitle: Text(settings.languageCode == 'en' ? 'English' : 'বাংলা'),
                          trailing: DropdownButton<String>(
                            value: settings.languageCode,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(value: 'en', child: Text('English')),
                              DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
                            ],
                            onChanged: (newValue) {
                              if (newValue != null) {
                                settings.changeLanguage(newValue);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ৩. অন্যান্য অপশন
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildProfileOption(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.favorite_border,
                    title: 'Wishlist',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WishlistScreen()),
                      );
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.support_agent,
                    title: 'Contact Support',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // কাস্টম লিস্ট টাইল উইজেট তৈরি
  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}